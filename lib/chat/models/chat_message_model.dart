class ChatMessageModel {
  final String? id;
  final int? receiverGuiderId;
  final int? receiverCustomerId;
  final String? senderId;
  final DateTime date;

  final String message;

  const ChatMessageModel({
    this.id,
    required this.message,
    required this.date,
    this.senderId,
    this.receiverGuiderId,
    this.receiverCustomerId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      senderId: json['senderId'],
      receiverGuiderId: json['receiverGuiderId'],
      receiverCustomerId: json['receiverCustomerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'date': date.toIso8601String(),
      'senderId': senderId,
      'receiverGuiderId': receiverGuiderId,
      'receiverCustomerId': receiverCustomerId,
    };
  }
}
