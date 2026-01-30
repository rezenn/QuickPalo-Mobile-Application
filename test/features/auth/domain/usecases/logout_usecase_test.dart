import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/features/auth/domain/entities/auth_entity.dart';
import 'package:quickpalo/features/auth/domain/repositories/auth_repository.dart';
import 'package:quickpalo/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const AuthEntity(
      fullName: "FALLBACK",
      email: "FALLBACK",
      phoneNumber: "FALLBACK",
      password: "FALLBACK",
      confirmPassword: "FALLBACK",
    ));
  });
  const 

  testWidgets('logout usecase ...', (tester) async {
    // TODO: Implement test
  });
}
