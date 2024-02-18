import 'package:mockito/annotations.dart';
import 'package:pedalpulse/features/auth/domain/repositories/social_auth_repository.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SocialAuthRepository>(as: #MockSocialAuthRepository)
])
void main() {}
