// import 'package:dartz/dartz.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:quickpalo/core/error/failures.dart';
// import 'package:quickpalo/core/usecases/app_usecase.dart';
// import 'package:quickpalo/features/profile/data/repositories/profile_repository.dart';
// import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';
// import 'package:quickpalo/features/profile/domain/repositories/profile_repository.dart';

// final getAllProfilesUsecaseProvider = Provider<GetAllProfilesUsecase>((ref) {
//   final profileRepository = ref.read(profileRepositoryProvider);
//   return GetAllProfilesUsecase(profileRepository: profileRepository);
// });

// class GetAllProfilesUsecase
//     implements UsecaseWithoutParams<List<ProfileEntity>> {
//   final IProfileRepository _profileRepository;

//   GetAllProfilesUsecase({required IProfileRepository profileRepository})
//       : _profileRepository = profileRepository;

//   @override
//   Future<Either<Failure, List<ProfileEntity>>> call() {
//     return _profileRepository.getAllProfiles();
//   }
// }
