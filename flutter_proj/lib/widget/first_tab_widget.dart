import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:fruit_combination/controller/fruit_data_controller.dart';
import 'package:fruit_combination/widget/loading_widget.dart';
import 'card_select_widget.dart';

class FirstTabWidget extends ConsumerStatefulWidget {
  FirstTabWidget({Key? key}) : super(key: key);

  @override
  _FirstTabWidgetState createState() => _FirstTabWidgetState();
}

class _FirstTabWidgetState extends ConsumerState<FirstTabWidget> {
  List<String> cardIndex = List.generate(
    100,
    (index) => index.toString().padLeft(3, '0'),
  );

  List<FlipCardController> controllers = List.generate(100, (_) => FlipCardController());
  
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

    return ProviderScope(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('12.7 탄핵'),
            ),
            body: Container(
              child: CardSelectWidget(
                appBarTitle: '12.7 탄핵',
                pickMessage: '3장을 선택해주세요',
                cardIndex: cardIndex,
                controllers: controllers,
                onShuffle: shuffleImages,
                maxSelectableCards: 3,
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