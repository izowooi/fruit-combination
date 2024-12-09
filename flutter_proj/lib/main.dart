// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruit_combination/controller/fruit_data_controller.dart';
import 'package:fruit_combination/widget/first_tab_widget.dart';
import 'package:fruit_combination/widget/settings_widget.dart';

final navigationIndexProvider = StateProvider<int>((ref) {
  return 0;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화

  final FruitDataController fruitController = FruitDataController();
  // Initialize controller
  await fruitController.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(ProviderScope(child: MainApp()));
  });
}

class MainApp extends ConsumerWidget {

  MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentPageIndex = ref.watch(navigationIndexProvider);

    return MaterialApp(
      home: Builder(builder: (context){
        return Scaffold(
        bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.how_to_vote), label: '12.7 탄핵'),
          // NavigationDestination(icon: Icon(Icons.how_to_vote), label: '12.14 탄핵'),
          // NavigationDestination(icon: Icon(Icons.emoji_events), label: '리더보드'),
          NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
            ref.read(navigationIndexProvider.notifier).state = index;
          },
        ),
        
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            FirstTabWidget(),
            //SettingsWidget(),
            // FirstTabWidget(),
            // FirstTabWidget(),
            SettingsWidget(),
          ],
        ),
      );
    })
    );
  }
}