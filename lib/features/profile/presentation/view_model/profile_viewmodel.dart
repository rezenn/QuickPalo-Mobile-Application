import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider =
    NotifierProvider<profileViewModel, ProfileState>(
        () => ProfileViewModel.new);

class ProfileViewmodel extends Notifier<ProfileState> {
  late final GetProfileByIdUscase _getProfileByIdUscase;
}
