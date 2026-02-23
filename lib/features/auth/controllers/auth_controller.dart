import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/features/auth/data/auth_repository.dart';
import 'package:code_mentor/features/auth/domain/models/user_profile.dart';

class AuthController
    extends StateNotifier<AsyncValue<UserProfile?>> {
  final AuthRepository _repo;
  final Ref _ref;

  AuthController(this._repo, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final profile =
          await _repo.signIn(email: email, password: password);
      _ref.read(currentUserProfileProvider.notifier).state = profile;
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String email, String password,
      {String? username}) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repo.signUp(
          email: email, password: password, username: username);
      _ref.read(currentUserProfileProvider.notifier).state = profile;
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _ref.read(currentUserProfileProvider.notifier).state = null;
    state = const AsyncValue.data(null);
  }

  Future<void> updateInterests(
      String userId, List<String> interests) async {
    try {
      final profile =
          await _repo.updateInterests(userId, interests);
      _ref.read(currentUserProfileProvider.notifier).state = profile;
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController,
    AsyncValue<UserProfile?>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider), ref);
});
