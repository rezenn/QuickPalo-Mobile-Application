import 'package:equatable/equatable.dart';

class StreamTokenEntity extends Equatable {
  final String apiKey;
  final String token;
  final String userId;
  final String userName;
  final String? userImage;
  final String role;

  const StreamTokenEntity({
    required this.apiKey,
    required this.token,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.role,
  });

  @override
  List<Object?> get props => [token, userId];
}
