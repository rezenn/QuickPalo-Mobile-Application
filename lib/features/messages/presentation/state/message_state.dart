import 'package:equatable/equatable.dart';
import '../../domain/entities/stream_token_entity.dart';
import '../../domain/entities/message_entity.dart';

class MessagesState extends Equatable {
  final bool isLoading;
  final bool isSending;
  final String? error;
  final StreamTokenEntity? streamToken;
  final List<MessageEntity> messages;
  final String? currentChannelId;

  const MessagesState({
    required this.isLoading,
    required this.isSending,
    this.error,
    this.streamToken,
    required this.messages,
    this.currentChannelId,
  });

  factory MessagesState.initial() {
    return const MessagesState(
      isLoading: false,
      isSending: false,
      error: null,
      streamToken: null,
      messages: [],
      currentChannelId: null,
    );
  }

  MessagesState copyWith({
    bool? isLoading,
    bool? isSending,
    String? error,
    StreamTokenEntity? streamToken,
    List<MessageEntity>? messages,
    String? currentChannelId,
  }) {
    return MessagesState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      streamToken: streamToken ?? this.streamToken,
      messages: messages ?? this.messages,
      currentChannelId: currentChannelId ?? this.currentChannelId,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isSending, error, streamToken, messages, currentChannelId];
}
