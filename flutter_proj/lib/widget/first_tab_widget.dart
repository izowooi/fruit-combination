import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:fruit_combination/controller/fruit_data_controller.dart';
import 'package:fruit_combination/data/fruit_result_data.dart';
import 'package:fruit_combination/widget/loading_widget.dart';
import 'card_select_widget.dart';

class FirstTabWidget extends ConsumerStatefulWidget {
  FirstTabWidget({Key? key}) : super(key: key);

  @override
  _FirstTabWidgetState createState() => _FirstTabWidgetState();
}

class _FirstTabWidgetState extends ConsumerState<FirstTabWidget> {
  List<String> cardIndex = List.generate(
    300,
    (index) => (index+1).toString().padLeft(3, '0'),
  );

  List<FlipCardController> controllers = List.generate(300, (_) => FlipCardController());
  
  @override
  void initState() {
    super.initState();
    // Fruit Data Controller 에서 isD1203 변수를 확인해서 해당 Index 를 제거합니다.
    List<int> index300 = List.generate(300, (index) => index);
    for (int i in index300) {
      if (FruitDataController().fruitMap[i+1]!.d1203 == false) {
        cardIndex.remove((i+1).toString().padLeft(3, '0'));
      }
    }

    cardIndex.shuffle(); // 초기화 시 리스트를 섞습니다.
  }

  void shuffleImages() async {
    for (var controller in controllers) {
      if (controller.state?.isFront == false) {
        await controller.flipcard(); // 플립된 카드를 원래대로 되돌립니다.
      }
    }
    setState(() {
      cardIndex.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showLoadingOverlay = ref.watch(isLoading);
    
    FruitResultData fruitResultData = FruitResultData(
      message_win: '계엄이 무효화되었습니다!',
      message_lose: '계엄이 무효화되었습니다!',
      election_prefix: '계엄 선포 무효화에 ',
      election_suffix_participate: '참여하셨습니다.',
      election_suffix_not_participate: '불참하였습니다.',
    );

    return ProviderScope(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('12.3 내란'),
            ),
            body: Container(
              child: CardSelectWidget(
                appBarTitle: '12.3 내란',
                pickMessage: '계엄을 무효화할 용기있는 의원 3명을 선택해주세요',
                cardIndex: cardIndex,
                controllers: controllers,
                onShuffle: shuffleImages,
                maxSelectableCards: 3,
                fruitResultData: fruitResultData,
                tabName: "first",
              ),
            ),
          ),
          if (showLoadingOverlay)
            const LoadingWidget(), // 로딩 화면 위젯
        ],
      ),
    );
  }
}