class FruitResultData {
  final String message_win;
  final String message_lose;
  final String election_prefix;
  final String election_suffix_participate;
  final String election_suffix_not_participate;

  FruitResultData({
    required this.message_win,
    required this.message_lose,
    required this.election_prefix,
    required this.election_suffix_participate,
    required this.election_suffix_not_participate,
  });

  @override
  String toString() {
    return 'Fruit{message_win: $message_win, message_lose: $message_lose, election_prefix: $election_prefix, election_suffix_participate: $election_suffix_participate, election_suffix_not_participate: $election_suffix_not_participate}';
  }
}