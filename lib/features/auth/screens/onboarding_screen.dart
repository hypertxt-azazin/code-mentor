import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/features/auth/controllers/auth_controller.dart';

const _interests = [
  'Python',
  'JavaScript',
  'Web',
  'Data',
  'Algorithms',
  'Mobile',
  'Databases',
  'Security',
  'DevOps',
  'Cloud',
];

final _selectedInterestsProvider =
    StateProvider<Set<String>>((ref) => {});

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(_selectedInterestsProvider);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    Future<void> onContinue() async {
      final profile = ref.read(currentUserProfileProvider);
      if (profile == null) {
        context.go('/');
        return;
      }
      await ref
          .read(authControllerProvider.notifier)
          .updateInterests(profile.id, selected.toList());
      if (context.mounted) context.go('/');
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  Text(
                    'What are you interested\nin learning?',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pick one or more topics to personalise your experience.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: _interests.map((interest) {
                          final isSelected = selected.contains(interest);
                          return FilterChip(
                            label: Text(interest),
                            selected: isSelected,
                            onSelected: (on) {
                              final updated = {...selected};
                              on
                                  ? updated.add(interest)
                                  : updated.remove(interest);
                              ref
                                  .read(_selectedInterestsProvider
                                      .notifier)
                                  .state = updated;
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : onContinue,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Continue'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: isLoading ? null : () => context.go('/'),
                    child: const Text('Skip for now'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
