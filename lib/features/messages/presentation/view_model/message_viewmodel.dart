import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';
import 'package:quickpalo/features/messages/domain/entities/stream_token_entity.dart';
import 'package:quickpalo/features/messages/domain/usecases/get_stream_token_usecase.dart';
import 'package:quickpalo/features/messages/domain/usecases/send_message_usecase.dart';
import 'package:stream_chat/stream_chat.dart' as stream;
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

  stream.StreamChatClient? _streamClient;
  stream.Channel? _currentChannel;
  StreamSubscription? _messageSubscription;
  StreamTokenEntity? _token;

  MessageViewModel(this._getStreamToken, this._sendMessage)
      : super(MessagesState.initial());

  Future<void> initializeChat() async {
    if (_streamClient != null && _token != null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _getStreamToken(const GetStreamTokenParams());

      await result.fold(
        (failure) async {
          state = state.copyWith(isLoading: false, error: failure.message);
        },
        (token) async {
          _token = token;

          _streamClient = stream.StreamChatClient(token.apiKey);
          await _streamClient!.connectUser(
            stream.User(
              id: token.userId,
              name: token.userName,
              image: token.userImage,
            ),
            token.token,
          );

          state = state.copyWith(isLoading: false, streamToken: token);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadChannelMessages(String orgUserId) async {
    if (_streamClient == null || _token == null) return;

    await _messageSubscription?.cancel();
    _messageSubscription = null;
    await _currentChannel?.stopWatching();

    final channelId = [_token!.userId, orgUserId]..sort();
    final channelIdStr = channelId.join('_');

    state = state.copyWith(
      isLoading: true,
      currentChannelId: channelIdStr,
      messages: [],
      error: null,
    );

    try {
      _currentChannel = _streamClient!.channel(
        'messaging',
        id: channelIdStr,
      );

      final response = await _currentChannel!.watch();

      final existing = (response.messages ?? [])
          .map(_streamMessageToEntity)
          .toList()
          .reversed
          .toList();

      state = state.copyWith(isLoading: false, messages: existing);

      _messageSubscription =
          _currentChannel!.on(stream.EventType.messageNew).listen((event) {
        if (event.message == null) return;
        final newMsg = _streamMessageToEntity(event.message!);

        final alreadyExists = state.messages.any((m) => m.id == newMsg.id);
        if (!alreadyExists) {
          state = state.copyWith(
            messages: [newMsg, ...state.messages],
          );
        }
      });
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(String orgUserId, String message) async {
    if (_token == null) {
      state = state.copyWith(error: 'Chat not initialized');
      return;
    }

    state = state.copyWith(isSending: true, error: null);

    try {
      final result = await _sendMessage(
        SendMessageParams(orgUserId: orgUserId, message: message),
      );

      result.fold(
        (failure) {
          state = state.copyWith(isSending: false, error: failure.message);
        },
        (messageEntity) {
          final alreadyExists =
              state.messages.any((m) => m.id == messageEntity.id);
          if (!alreadyExists) {
            state = state.copyWith(
              isSending: false,
              messages: [messageEntity, ...state.messages],
            );
          } else {
            state = state.copyWith(isSending: false);
          }
        },
      );
    } catch (e) {
      state = state.copyWith(isSending: false, error: e.toString());
    }
  }

  MessageEntity _streamMessageToEntity(stream.Message msg) {
    return MessageEntity(
      id: msg.id,
      channelId: _currentChannel?.id ?? '',
      text: msg.text ?? '',
      userId: msg.user?.id ?? '',
      userName: msg.user?.name ?? '',
      userImage: msg.user?.image,
      createdAt: msg.createdAt,
    );
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _currentChannel?.stopWatching();
    _streamClient?.disconnectUser();
    super.dispose();
  }
}
