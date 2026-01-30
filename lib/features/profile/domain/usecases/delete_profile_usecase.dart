// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:quickpalo/core/error/failures.dart';
// import 'package:quickpalo/core/usecases/app_usecase.dart';
// import 'package:quickpalo/features/profile/data/repositories/profile_repository.dart';
// import 'package:quickpalo/features/profile/domain/repositories/profile_repository.dart';

// class DeleteProfileParams extends Equatable {
//   final String userId;

//   const DeleteProfileParams({required this.userId});

//   @override
//   List<Object?> get props => [userId];
// }

// final deleteProfileUsecaseProvider = Provider<DeleteProfileUsecase>((ref) {
//   final profileRepository = ref.read(profileRepositoryProvider);
//   return DeleteProfileUsecase(profileRepository: profileRepository);
// });

// class DeleteProfileUsecase
//     implements UsecaseWithParams<bool, DeleteProfileParams> {
//   final IProfileRepository _profileRepository;

//   DeleteProfileUsecase({required IProfileRepository profileRepository})
//       : _profileRepository = profileRepository;

//   @override
//   Future<Either<Failure, bool>> call(DeleteProfileParams params) {
//     return _profileRepository.deleteProfile(params.userId);
//   }
// }
