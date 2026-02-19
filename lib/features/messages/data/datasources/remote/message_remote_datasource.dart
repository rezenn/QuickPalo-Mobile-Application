// import 'package:dio/dio.dart';
// import 'package:quickpalo/core/error/failures.dart';
// import 'package:quickpalo/features/messages/data/models/message_api_model.dart';
// import 'package:quickpalo/features/messages/data/models/stream_token_api_model.dart';

// abstract class IMessageRemoteDataSource {
//   Future<StreamTokenApiModel> getStreamToken();
//   Future<Map<String, dynamic>> sendMessageToOrganization(
//     String orgUserId,
//     String message,
//   );
// }

// class MessageRemoteDataSource implements IMessageRemoteDataSource {
//   final Dio _dio;

//   MessageRemoteDataSource({required Dio dio}) : _dio = dio;

//   @override
//   Future<StreamTokenApiModel> getStreamToken() async {
//     try {
//       final response = await _dio.get('/message/stream-token');

//       if (response.statusCode == 200) {
//         return StreamTokenApiModel.fromJson(response.data);
//       }

//       throw ServerFailure(message: 'Failed to get stream token');
//     } on DioException catch (e) {
//       throw ServerFailure(
//         message: e.response?.data['message'] ?? 'Failed to get stream token',
//       );
//     }
//   }

//   @override
//   Future<Map<String, dynamic>> sendMessageToOrganization(
//     String orgUserId,
//     String message,
//   ) async {
//     try {
//       final response = await _dio.post(
//         '/message/send-to-org',
//         data: {
//           'orgUserId': orgUserId,
//           'message': message,
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = response.data['data'];
//         final messageData = data['message'];

//         // Extract user info from the message response
//         final user = messageData['user'];

//         return {
//           'channelId': data['channelId'],
//           'message': MessageApiModel(
//             id: messageData['id'],
//             channelId: data['channelId'],
//             text: messageData['text'],
//             userId: user['id'],
//             userName: user['name'],
//             userImage: user['image'],
//             createdAt: DateTime.parse(messageData['created_at']),
//           ),
//         };
//       }

//       throw ServerFailure(message: 'Failed to send message');
//     } on DioException catch (e) {
//       throw ServerFailure(
//         message: e.response?.data['message'] ?? 'Failed to send message',
//       );
//     }
//   }
// }

// lib/features/messages/data/datasources/remote/message_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/messages/data/models/message_api_model.dart';
import 'package:quickpalo/features/messages/data/models/stream_token_api_model.dart';

abstract class IMessageRemoteDataSource {
  Future<StreamTokenApiModel> getStreamToken();
  Future<Map<String, dynamic>> sendMessageToOrganization(
    String orgUserId,
    String message,
  );
  Future<List<MessageApiModel>> getMessages(String channelId); // Add this
}

class MessageRemoteDataSource implements IMessageRemoteDataSource {
  final Dio _dio;

  MessageRemoteDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<StreamTokenApiModel> getStreamToken() async {
    try {
      final response = await _dio.get('/message/stream-token');
      if (response.statusCode == 200) {
        return StreamTokenApiModel.fromJson(response.data);
      }
      throw ServerFailure(message: 'Failed to get stream token');
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Failed to get stream token',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> sendMessageToOrganization(
    String orgUserId,
    String message,
  ) async {
    try {
      final response = await _dio.post(
        '/message/send-to-org',
        data: {
          'orgUserId': orgUserId,
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final messageData = data['message'];
        final user = messageData['user'];

        return {
          'channelId': data['channelId'],
          'message': MessageApiModel(
            id: messageData['id'],
            channelId: data['channelId'],
            text: messageData['text'],
            userId: user['id'],
            userName: user['name'],
            userImage: user['image'],
            createdAt: DateTime.parse(messageData['created_at']),
          ),
        };
      }
      throw ServerFailure(message: 'Failed to send message');
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Failed to send message',
      );
    }
  }

  @override
  Future<List<MessageApiModel>> getMessages(String channelId) async {
    try {
      final response = await _dio.get(
        '/message/get-messages',
        queryParameters: {'channelId': channelId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> messagesJson = response.data['data'] ?? [];
        return messagesJson
            .map((json) => MessageApiModel.fromJson(json))
            .toList();
      }
      throw ServerFailure(message: 'Failed to get messages');
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Failed to get messages',
      );
    }
  }
}
