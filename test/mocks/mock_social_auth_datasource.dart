import 'package:mockito/annotations.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';

@GenerateMocks([], customMocks: [
  MockSpec<SocialAuthDataSource>(as: #MockSocialAuthDataSource)
])
void main() {}
