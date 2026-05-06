import 'package:flutter_test/flutter_test.dart';
import 'package:jinhan_flutter/core/api/user_repository.dart';
import 'package:jinhan_flutter/core/storage/token_manager.dart';
import 'package:jinhan_flutter/pages/my/providers/my_page_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenManager tokenManager;
  late MyPageProvider provider;

  setUp(() async {
    tokenManager = TokenManager.instance;
    await tokenManager.clearToken();
    provider = MyPageProvider(
      userRepository: UserRepository(),
      tokenManager: tokenManager,
    );
  });

  tearDown(() async {
    await tokenManager.clearToken();
  });

  test('logout clears token and leaves provider in logged-out state', () async {
    await tokenManager.saveToken(accessToken: 'session-token');

    await provider.logout();

    expect(tokenManager.isLoggedIn, isFalse);
    expect(provider.isLoggedIn, isFalse);
    expect(provider.profile, isNull);
    expect(provider.isLoggingOut, isFalse);
  });
}
