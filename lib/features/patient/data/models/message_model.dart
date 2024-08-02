import 'package:dermai/features/core/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.messageID,
    required super.message,
    required super.dateTime,
    required super.isGenerated,
    required super.diagnosedID,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageID: json['messageID'],
      message: json['message'],
      dateTime: DateTime.parse(json['dateTime']),
      isGenerated: json['isGenerated'],
      diagnosedID: json['diagnosedID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'dateTime': dateTime.toIso8601String(),
      'isGenerated': isGenerated,
      'diagnosedID': diagnosedID,
    };
  }
        
}
