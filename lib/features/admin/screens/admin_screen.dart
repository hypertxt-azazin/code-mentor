import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/core/widgets/loading_widget.dart';
import 'package:code_mentor/features/catalog/controllers/catalog_controller.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.adminPanel)),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('You need admin privileges to view this page.'),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.adminPanel),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tracks'),
              Tab(text: 'Modules'),
              Tab(text: 'Lessons'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TracksTab(),
            _ModulesTab(),
            _LessonsTab(),
          ],
        ),
      ),
    );
  }
}

// ── Tracks Tab ──────────────────────────────────────────────────────────────

class _TracksTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(tracksProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addTrack),
        onPressed: () => _showEditDialog(context, null),
      ),
      body: tracksAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (tracks) => ListView.separated(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: tracks.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final track = tracks[i];
            return ListTile(
              title: Text(track.title),
              subtitle: Text(track.difficulty),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showEditDialog(context, track.title),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => _confirmDelete(context, track.title),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String? currentTitle) {
    _showFormDialog(
      context,
      title: currentTitle == null
          ? AppStrings.addTrack
          : AppStrings.editTrack,
      fields: const ['Title', 'Description', 'Difficulty'],
      initialValues: [currentTitle ?? '', '', 'beginner'],
    );
  }

  void _confirmDelete(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.confirmDelete),
        content: Text('Delete "$title"? ${AppStrings.cannotUndo}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel)),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Delete not yet wired up.')));
              },
              child: const Text(AppStrings.deleteTrack,
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

// ── Modules Tab ─────────────────────────────────────────────────────────────

class _ModulesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(tracksProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addModule),
        onPressed: () => _showFormDialog(context,
            title: AppStrings.addModule,
            fields: const ['Title', 'Description', 'Track ID'],
            initialValues: const ['', '', '']),
      ),
      body: tracksAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (tracks) => ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: tracks.length,
          itemBuilder: (context, ti) {
            final track = tracks[ti];
            return Consumer(builder: (context, ref, _) {
              final modulesAsync = ref.watch(modulesProvider(track.id));
              return modulesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (modules) => ExpansionTile(
                  title: Text(track.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: modules.map((m) => ListTile(
                        title: Text(m.title),
                        subtitle: Text('Order: ${m.order}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _showFormDialog(context,
                                  title: AppStrings.editModule,
                                  fields: const ['Title', 'Description'],
                                  initialValues: [m.title, m.description]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  size: 20, color: Colors.red),
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Delete not yet wired up.'))),
                            ),
                          ],
                        ),
                      )).toList(),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

// ── Lessons Tab ─────────────────────────────────────────────────────────────

class _LessonsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
          'Select a module in the Modules tab to manage its lessons.'),
    );
  }
}

// ── Shared helpers ───────────────────────────────────────────────────────────

void _showFormDialog(
  BuildContext context, {
  required String title,
  required List<String> fields,
  required List<String> initialValues,
}) {
  final controllers = List.generate(
      fields.length,
      (i) => TextEditingController(
          text: i < initialValues.length ? initialValues[i] : ''));

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            fields.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: controllers[i],
                decoration: InputDecoration(
                  labelText: fields[i],
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel)),
        FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Save not yet wired up.')));
            },
            child: const Text(AppStrings.saveChanges)),
      ],
    ),
  );
}
