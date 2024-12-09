import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:fruit_combination/widget/fruit_result_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruit_combination/controller/fruit_data_controller.dart';

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
    //final cardPath = 'assets/images/portrait/fruit_$cardIndex.jpeg';
    final cardPath = 'assets/images/portrait/fruit_125.png';
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
    setState(() {
      selectedCards.clear();
      selectedCardIndices.clear();
    });
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
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(
            widget.pickMessage,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        // GridView with 24 cards
        Expanded(
          flex: 5,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal:4.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
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
                      selectedCardIndices.add(index);
                      controller.flipcard();
                      _selectCard(index);
                    },
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
                            //'assets/images/portrait/fruit_${widget.cardIndex[index]}.png',
                            'assets/images/portrait/fruit_125.png',
                            width: 200.0,
                            fit: BoxFit.cover,
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
      ],
    );
  }
}