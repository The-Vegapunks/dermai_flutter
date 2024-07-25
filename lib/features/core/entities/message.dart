class Message {
  const Message({
    required this.messageID,
    required this.message,
    required this.dateTime,
    required this.isGenerated,
    required this.diagnosedID,
  });

  final String messageID;
  final String message;
  final DateTime dateTime;
  final bool isGenerated;
  final String diagnosedID;
}