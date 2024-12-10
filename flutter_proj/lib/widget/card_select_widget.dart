import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:fruit_combination/widget/fruit_result_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruit_combination/controller/fruit_data_controller.dart';
import 'package:gap/gap.dart';

final interpretationProvider = Provider<Function(String, int)>((ref) {
  return (String cardIndex,int index) => FruitDataController().getYearlyInterpretation(cardIndex, index);
});

class CardSelectWidget extends ConsumerStatefulWidget {
  final String appBarTitle;
  final String pickMessage;
  final List<String> cardIndex;
  final List<FlipCardController> controllers;
  final VoidCallback onShuffle;
  final int maxSelectableCards;

  CardSelectWidget({
    required this.appBarTitle,
    required this.pickMessage,
    required this.cardIndex,
    required this.controllers,
    required this.onShuffle,
    required this.maxSelectableCards,
  });

  @override
  _CardSelectWidgetState createState() => _CardSelectWidgetState();  
}

class _CardSelectWidgetState extends ConsumerState<CardSelectWidget> {
  List<FruitCardData> selectedCards = [];
  Set<int> selectedCardIndices = {}; // 선택된 카드 인덱스를 추적하는 상태 변수
  
  bool _isMaxSelectable() {
    return selectedCards.length >= widget.maxSelectableCards;
  }
  
  void _selectCard(int index) {
    final cardIndex = widget.cardIndex[index];
    final cardPath = 'assets/images/portrait/fruit_$cardIndex.jpeg';
    final cardTitle = FruitDataController().getFruitName(cardIndex);
    final cardContent = ref.read(interpretationProvider)(cardIndex, selectedCards.length);

    selectedCards.add(
      FruitCardData(
      imagePath: cardPath,
      title: cardTitle,
      content: cardContent,)
    );
  }
  
  void _clearSelection() {
    widget.onShuffle(); // 셔플 실행
    setState(() {
      selectedCards.clear();
      selectedCardIndices.clear();
    });
  }
  
  void flipCard() async{
    for( var cardIndex in selectedCardIndices ){
      final controller = widget.controllers[cardIndex];
      await controller.flipcard();
    }
  }

  void _onFlipEnd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FruitResultWidget(
          title: widget.appBarTitle,
          cardDataList: selectedCards,
        ),
      ),
    );
    widget.onShuffle(); // 돌아왔을 때 셔플 실행
    _clearSelection(); // selectedCards 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            widget.pickMessage,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        // GridView with 24 cards
        Expanded(
          flex: 90,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal:4.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 5 / 6,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final controller = widget.controllers[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0), // 여백 추가
                  child: GestureDetector(
                    onTap: () {
                      if (selectedCardIndices.contains(index)) {
                        return; // 이미 선택된 카드는 무시
                      }
                      setState(() {
                        selectedCardIndices.add(index);  
                      });
                      //controller.flipcard();
                      _selectCard(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedCardIndices.contains(index) ? Colors.green : Colors.transparent,
                          width: 6.0,
                        ),
                      ),
                      child: FlipCard(
                        controller: controller,
                        rotateSide: RotateSide.right,
                        animationDuration: const Duration(milliseconds: 300),
                        frontWidget: Card(
                          margin: EdgeInsets.zero,
                          child: Center(child: Image.asset(
                            'assets/images/card_back_1.png',
                            //height: 80.0,
                            width: 200.0,
                            fit: BoxFit.cover)
                          ),
                        ),
                        backWidget: Card(
                          margin: EdgeInsets.zero,
                          child: Center(
                            child: Image.asset(
                              'assets/images/portrait/fruit_${widget.cardIndex[index]}.jpg',
                              width: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(

          flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isMaxSelectable() ? flipCard : null,
                child: const Text('선택 완료'),
              ),
              ElevatedButton(
                onPressed: _clearSelection,
                child: const Text('다시 섞기'),
              ),
              // ElevatedButton(
              //   onPressed: widget.onShuffle,
              //   child: const Text('섞기'),
              // ),
            ],
          )
        )
      ],
    );
  }
}