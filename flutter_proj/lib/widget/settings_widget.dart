import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsWidget extends ConsumerWidget {
  SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 버전 정보
          const ListTile(
            title: Text('버전 정보'),
            subtitle: Text('1.0.0'),
          ),
          const Divider(),

          // 감사 메시지
          const ListTile(
            title: Text('감사 메시지'),
            subtitle: Text('계엄을 막아준 의원님들께 깊은 감사를 전합니다.'),
          ),
        ],
      ),
    );
  }
}