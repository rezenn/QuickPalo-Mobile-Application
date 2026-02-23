import 'package:flutter_riverpod/flutter_riverpod.dart';

final shakeRefreshProvider = NotifierProvider<ShakeRefreshNotifier, int>(
  ShakeRefreshNotifier.new,
);

class ShakeRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() => state = state + 1;
}
