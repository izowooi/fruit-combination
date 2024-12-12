import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:fruit_combination/controller/fruit_data_controller.dart';
import 'package:fruit_combination/data/fruit_result_data.dart';
import 'package:fruit_combination/widget/loading_widget.dart';
import 'card_select_widget.dart';

class SecondTabWidget extends ConsumerStatefulWidget {
  SecondTabWidget({Key? key}) : super(key: key);

  @override
  _SecondTabWidgetState createState() => _SecondTabWidgetState();
}

class _SecondTabWidgetState extends ConsumerState<SecondTabWidget> {
  List<String> cardIndex = List.generate(
    300,
    (index) => (index+1).toString().padLeft(3, '0'),
  );

  List<FlipCardController> controllers = List.generate(300, (_) => FlipCardController());
  
  @override
  void initState() {
    super.initState();
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
      message_win: '탄핵이 가결되었습니다!',
      message_lose: '탄핵이 부결되었습니다',
      election_prefix: '탄핵 투표에 ',
      election_suffix_participate: '참여하셨습니다.',
      election_suffix_not_participate: '불참하였습니다.',
    );

    return ProviderScope(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('12.7 탄핵'),
            ),
            body: Container(
              child: CardSelectWidget(
                appBarTitle: '12.7 탄핵 투표',
                pickMessage: '투표에 참여할 3명을 선택해주세요',
                cardIndex: cardIndex,
                controllers: controllers,
                onShuffle: shuffleImages,
                maxSelectableCards: 3,
                fruitResultData: fruitResultData,
                tabName: "second",
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