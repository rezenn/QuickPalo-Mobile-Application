// import 'package:flutter_riverpod/legacy.dart';
// import 'package:quickpalo/features/messages/domain/entities/stream_token_entity.dart';
// import 'package:quickpalo/features/messages/domain/usecases/get_stream_token_usecase.dart';
// import 'package:quickpalo/features/messages/domain/usecases/send_message_usecase.dart';
// import '../state/message_state.dart';

// final messageViewModelProvider =
//     StateNotifierProvider<MessageViewModel, MessagesState>((ref) {
//   final getToken = ref.read(getStreamTokenUsecaseProvider);
//   final sendMessage = ref.read(sendMessageUsecaseProvider);
//   return MessageViewModel(getToken, sendMessage);
// });

// class MessageViewModel extends StateNotifier<MessagesState> {
//   final GetStreamTokenUsecase _getStreamToken;
//   final SendMessageUsecase _sendMessage;

//   // Store token for later use
//   StreamTokenEntity? _token;

//   MessageViewModel(this._getStreamToken, this._sendMessage)
//       : super(MessagesState.initial());

//   Future<void> initializeChat() async {
//     // Don't reinitialize if already loaded
//     if (_token != null) {
//       return;
//     }

//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final result = await _getStreamToken(const GetStreamTokenParams());

//       result.fold(
//         (failure) {
//           state = state.copyWith(
//             isLoading: false,
//             error: failure.message,
//           );
//         },
//         (token) {
//           _token = token;
//           state = state.copyWith(
//             isLoading: false,
//             streamToken: token,
//           );
//         },
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   Future<void> sendMessage(String orgUserId, String message) async {
//     if (_token == null) {
//       state = state.copyWith(
//         error: "Chat not initialized",
//       );
//       return;
//     }

//     state = state.copyWith(isSending: true, error: null);

//     try {
//       final result = await _sendMessage(
//         SendMessageParams(orgUserId: orgUserId, message: message),
//       );

//       result.fold(
//         (failure) {
//           state = state.copyWith(
//             isSending: false,
//             error: failure.message,
//           );
//         },
//         (messageEntity) {
//           // Add the new message to the list
//           state = state.copyWith(
//             isSending: false,
//             messages: [messageEntity, ...state.messages],
//           );
//         },
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isSending: false,
//         error: e.toString(),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // Just clean up, no Stream client to dispose
//     _token = null;
//     super.dispose();
//   }
// }

// lib/features/messages/presentation/view_model/message_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';
import 'package:quickpalo/features/messages/domain/entities/stream_token_entity.dart';
import 'package:quickpalo/features/messages/domain/usecases/get_stream_token_usecase.dart';
import 'package:quickpalo/features/messages/domain/usecases/send_message_usecase.dart';
import '../state/message_state.dart';

final messageViewModelProvider =
    StateNotifierProvider<MessageViewModel, MessagesState>((ref) {
  final getToken = ref.read(getStreamTokenUsecaseProvider);
  final sendMessage = ref.read(sendMessageUsecaseProvider);
  return MessageViewModel(getToken, sendMessage);
});

class MessageViewModel extends StateNotifier<MessagesState> {
  final GetStreamTokenUsecase _getStreamToken;
  final SendMessageUsecase _sendMessage;

  // Store messages per channel
  final Map<String, List<MessageEntity>> _channelMessages = {};

  StreamTokenEntity? _token;

  MessageViewModel(this._getStreamToken, this._sendMessage)
      : super(MessagesState.initial());

  Future<void> initializeChat() async {
    if (_token != null) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _getStreamToken(const GetStreamTokenParams());

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (token) {
          _token = token;
          state = state.copyWith(
            isLoading: false,
            streamToken: token,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Set current channel and load its messages
  void setCurrentChannel(String orgUserId) {
    if (_token == null) return;

    final channelId = [_token!.userId, orgUserId]..sort();
    final channelIdStr = channelId.join('_');

    // Get messages for this channel
    final channelMessages = _channelMessages[channelIdStr] ?? [];

    state = state.copyWith(
      currentChannelId: channelIdStr,
      messages: channelMessages,
    );
  }

  Future<void> sendMessage(String orgUserId, String message) async {
    if (_token == null) {
      state = state.copyWith(
        error: "Chat not initialized",
      );
      return;
    }

    // Calculate channel ID
    final channelId = [_token!.userId, orgUserId]..sort();
    final channelIdStr = channelId.join('_');

    state = state.copyWith(isSending: true, error: null);

    try {
      final result = await _sendMessage(
        SendMessageParams(orgUserId: orgUserId, message: message),
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            isSending: false,
            error: failure.message,
          );
        },
        (messageEntity) {
          // Add message to channel-specific storage
          if (!_channelMessages.containsKey(channelIdStr)) {
            _channelMessages[channelIdStr] = [];
          }
          _channelMessages[channelIdStr] = [
            messageEntity,
            ...?_channelMessages[channelIdStr]
          ];

          // Only update UI if this is the current channel
          if (state.currentChannelId == channelIdStr) {
            state = state.copyWith(
              isSending: false,
              messages: _channelMessages[channelIdStr] ?? [],
            );
          } else {
            // Just update storage without changing UI
            state = state.copyWith(isSending: false);
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: e.toString(),
      );
    }
  }

  // Load messages for a specific channel (you can implement this to fetch from backend)
  Future<void> loadChannelMessages(String orgUserId) async {
    if (_token == null) return;

    final channelId = [_token!.userId, orgUserId]..sort();
    final channelIdStr = channelId.join('_');

    // Here you would typically fetch messages from your backend
    // For now, just load from local storage
    final channelMessages = _channelMessages[channelIdStr] ?? [];

    state = state.copyWith(
      currentChannelId: channelIdStr,
      messages: channelMessages,
    );
  }

  @override
  void dispose() {
    _token = null;
    _channelMessages.clear();
    super.dispose();
  }
}
