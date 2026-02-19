import 'package:quickpalo/features/messages/domain/entities/stream_token_entity.dart';

class StreamTokenApiModel {
  final String apiKey;
  final String token;
  final String userId;
  final String userName;
  final String? userImage;
  final String role;

  StreamTokenApiModel({
    required this.apiKey,
    required this.token,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.role,
  });

  factory StreamTokenApiModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return StreamTokenApiModel(
      apiKey: data['apiKey'],
      token: data['token'],
      userId: data['userId'],
      userName: data['user']['name'],
      userImage: data['user']['image'],
      role: data['user']['role'],
    );
  }

  StreamTokenEntity toEntity() => StreamTokenEntity(
        apiKey: apiKey,
        token: token,
        userId: userId,
        userName: userName,
        userImage: userImage,
        role: role,
      );
}
