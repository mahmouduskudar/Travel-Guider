class UserModel {
  String? socketId;
  int? guiderId;
  int? customerId;

  UserModel({
    this.socketId,
    this.guiderId,
    this.customerId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      socketId: json['socketId'],
      guiderId: json['guiderId'],
      customerId: json['customerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'socketId': socketId,
      'guiderId': guiderId,
      'customerId': customerId,
    };
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          socketId == other.socketId &&
          guiderId == other.guiderId &&
          customerId == other.customerId;

  @override
  int get hashCode =>
      socketId.hashCode ^ guiderId.hashCode ^ customerId.hashCode;
}
