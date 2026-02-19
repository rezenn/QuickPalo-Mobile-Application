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

  void setCurrentChannel(String orgUserId) {
    if (_token == null) return;

    final channelId = [_token!.userId, orgUserId]..sort();
    final channelIdStr = channelId.join('_');

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
          if (!_channelMessages.containsKey(channelIdStr)) {
            _channelMessages[channelIdStr] = [];
          }
          _channelMessages[channelIdStr] = [
            messageEntity,
            ...?_channelMessages[channelIdStr]
          ];

          if (state.currentChannelId == channelIdStr) {
            state = state.copyWith(
              isSending: false,
              messages: _channelMessages[channelIdStr] ?? [],
            );
          } else {
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

  Future<void> loadChannelMessages(String orgUserId) async {
    if (_token == null) return;

    final channelId = [_token!.userId, orgUserId]..sort();
    final channelIdStr = channelId.join('_');

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
