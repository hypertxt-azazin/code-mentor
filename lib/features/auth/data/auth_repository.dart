import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:code_mentor/core/errors/app_error.dart';
import 'package:code_mentor/features/auth/domain/models/user_profile.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserProfile> signUp(
      {required String email,
      required String password,
      String? username});
  Future<UserProfile> signIn(
      {required String email, required String password});
  Future<void> signOut();
  Future<UserProfile?> getProfile(String userId);
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<UserProfile> updateInterests(
      String userId, List<String> interests);
}

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;
  SupabaseAuthRepository(this._client);

  @override
  Stream<User?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((e) => e.session?.user);

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Future<UserProfile> signUp(
      {required String email,
      required String password,
      String? username}) async {
    try {
      final response =
          await _client.auth.signUp(email: email, password: password);
      if (response.user == null) throw const AuthError('Sign up failed');
      final profile = UserProfile(
        id: response.user!.id,
        username: username ?? email.split('@').first,
        displayName: username ?? email.split('@').first,
      );
      await _client.from('profiles').upsert(profile.toJson());
      return profile;
    } on AuthException catch (e) {
      throw AuthError(e.message, code: e.statusCode);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError(e.toString());
    }
  }

  @override
  Future<UserProfile> signIn(
      {required String email, required String password}) async {
    try {
      final response = await _client.auth
          .signInWithPassword(email: email, password: password);
      if (response.user == null) throw const AuthError('Sign in failed');
      final profile = await getProfile(response.user!.id);
      return profile ?? UserProfile(id: response.user!.id);
    } on AuthException catch (e) {
      throw AuthError(e.message, code: e.statusCode);
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return UserProfile.fromJson(data);
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    await _client.from('profiles').upsert(profile.toJson());
    return profile;
  }

  @override
  Future<UserProfile> updateInterests(
      String userId, List<String> interests) async {
    await _client
        .from('profiles')
        .update({'interests': interests}).eq('id', userId);
    final profile = await getProfile(userId);
    return profile!;
  }
}

class DevAuthRepository implements AuthRepository {
  UserProfile? _profile;

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  User? get currentUser => null;

  @override
  Future<UserProfile> signUp(
      {required String email,
      required String password,
      String? username}) async {
    _profile = UserProfile(
      id: 'dev-user-001',
      username: username ?? 'devuser',
      displayName: username ?? 'Dev User',
      isPremium: false,
      isAdmin: true,
    );
    return _profile!;
  }

  @override
  Future<UserProfile> signIn(
      {required String email, required String password}) async {
    _profile = UserProfile(
      id: 'dev-user-001',
      username: 'devuser',
      displayName: 'Dev User',
      isPremium: false,
      isAdmin: true,
    );
    return _profile!;
  }

  @override
  Future<void> signOut() async {
    _profile = null;
  }

  @override
  Future<UserProfile?> getProfile(String userId) async => _profile;

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    _profile = profile;
    return profile;
  }

  @override
  Future<UserProfile> updateInterests(
      String userId, List<String> interests) async {
    _profile = _profile?.copyWith(interests: interests) ??
        UserProfile(id: userId, interests: interests);
    return _profile!;
  }
}
