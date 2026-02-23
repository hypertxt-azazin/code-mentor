import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:code_mentor/app/env.dart';
import 'package:code_mentor/features/auth/data/auth_repository.dart';
import 'package:code_mentor/features/auth/domain/models/user_profile.dart';
import 'package:code_mentor/features/catalog/data/catalog_repository.dart';
import 'package:code_mentor/features/progress/data/progress_repository.dart';

final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (Env.devSeedMode) return DevAuthRepository();
  return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  if (Env.devSeedMode) return DevCatalogRepository();
  return SupabaseCatalogRepository(ref.watch(supabaseClientProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  if (Env.devSeedMode) return DevProgressRepository();
  return SupabaseProgressRepository(ref.watch(supabaseClientProvider));
});

// Auth state providers
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProfileProvider =
    StateProvider<UserProfile?>((ref) => null);

// Current user convenience
final isAuthenticatedProvider = Provider<bool>((ref) {
  if (Env.devSeedMode) {
    return ref.watch(currentUserProfileProvider) != null;
  }
  final auth = ref.watch(authStateProvider);
  return auth.maybeWhen(
      data: (user) => user != null, orElse: () => false);
});

final isPremiumProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentUserProfileProvider);
  return profile?.isPremium ?? false;
});

final isAdminProvider = Provider<bool>((ref) {
  final profile = ref.watch(currentUserProfileProvider);
  return profile?.isAdmin ?? false;
});
