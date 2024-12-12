import 'package:flutter/material.dart';
import 'package:fruit_combination/data/fruit_result_data.dart';
import 'package:url_launcher/url_launcher.dart';

class FruitResultWidget extends StatelessWidget {
  final String title; // 결과 화면의 제목
  final FruitResultData resultData; // 결과 데이터
  final List<FruitCardData> cardDataList; // 사용자가 고른 카드 데이터 리스트

  const FruitResultWidget({
    required this.title,
    required this.cardDataList,
    required this.resultData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    bool allParticipated = cardDataList.every((cardData) => cardData.participated);
    bool anyNotParticipated = cardDataList.any((cardData) => !cardData.participated);

    if (allParticipated) {
      _showResultDialog(context, resultData.message_win);
    } else if (anyNotParticipated) {
      _showResultDialog(context, resultData.message_lose);
    }
  });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 사용자가 고른 카드 설명
            ...cardDataList.map((cardData) => FruitCardDescription(data: cardData,
            resultData: resultData,
            )).toList(),
          ],
        ),
      ),
    );
  }
}

void _showResultDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
            },
            child: Text("확인"),
          ),
        ],
      );
    },
  );
}

class FruitCardDescription extends StatelessWidget {
  final FruitCardData data;
  final FruitResultData resultData;

  const FruitCardDescription({
    required this.data,
    required this.resultData,
    Key? key,
  }) : super(key: key);

  Future<void> _launchUrl(String urlSuffix) async {
    var url = 'https://www.assembly.go.kr/members/22nd/$urlSuffix';
    Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var participated = data.participated;

    return Card(
      color: participated ? Colors.green[100] : Colors.red[100],
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                data.fruitName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            // 카드 이미지
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300, // 원하는 너비로 설정
                  height: 300, // 원하는 높이로 설정
                  child: Image.asset(
                    data.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2.0),

            Align(
              alignment: Alignment.center,
              child: Text(
                //조국혁신당 | 비례대표 | 초선
                data.briefDesc,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            
            const SizedBox(height: 2.0),

            // 참여 여부 강조
            Row(
              children: [
                Text(
                  //"계엄 선포 무효화에 ",
                  data.electionDesc,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  participated ? resultData.election_suffix_participate : resultData.election_suffix_not_participate,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: participated ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            // 버튼
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  _launchUrl(data.fruitEnName);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text("의원 정보 보기"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FruitCardData {
  final String imagePath;
  final String fruitName;
  final String fruitEnName;
  final String briefDesc;
  final String electionDesc;
  final bool participated;

  FruitCardData({
    required this.imagePath,
    required this.fruitName,
    required this.fruitEnName,
    required this.briefDesc,
    required this.electionDesc,
    required this.participated,
  });
}