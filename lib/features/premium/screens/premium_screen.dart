import 'package:flutter/material.dart';
import 'package:code_mentor/core/constants/strings.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('CodePath Pro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium,
                      color: Colors.white, size: 56),
                  const SizedBox(height: 12),
                  const Text(
                    'Upgrade to CodePath Pro',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Unlock everything and supercharge your learning.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Feature comparison
            Text('What you get',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ComparisonTable(),
            const SizedBox(height: 28),

            // Plans
            Text('Choose a Plan',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PlanCard(
                    title: AppStrings.monthlyPlan,
                    price: '\$9.99',
                    period: '/month',
                    features: const [
                      'All stages unlocked',
                      'Unlimited drills',
                      'Advanced checkpoints',
                    ],
                    isPrimary: false,
                    onTap: () => _showComingSoon(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PlanCard(
                    title: AppStrings.yearlyPlan,
                    price: '\$79.99',
                    period: '/year',
                    features: const [
                      'Everything in Monthly',
                      'Save 33%',
                      'Offline packs (soon)',
                    ],
                    isPrimary: true,
                    badge: 'Best Value',
                    onTap: () => _showComingSoon(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Restore purchases
            Center(
              child: TextButton(
                onPressed: () => _showComingSoon(context),
                child: const Text('Restore Purchases'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon! Payments not yet available.'),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Drill attempts/day', '15', 'Unlimited'),
      ('Stages per roadmap', '2', 'All'),
      ('Progress tracking', 'Basic', 'Advanced'),
      ('Checkpoints', 'Stage checkpoints', 'Advanced checkpoints'),
      ('Offline packs', '✗', 'Coming soon'),
    ];

    return Table(
      border: TableBorder.all(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(8)),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.5)),
          children: const [
            _TableCell(text: 'Feature', isHeader: true),
            _TableCell(text: 'Free', isHeader: true),
            _TableCell(text: 'Pro', isHeader: true),
          ],
        ),
        ...rows.map((r) => TableRow(
              children: [
                _TableCell(text: r.$1),
                _TableCell(text: r.$2),
                _TableCell(
                    text: r.$3,
                    textColor: Theme.of(context).colorScheme.primary),
              ],
            )),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final Color? textColor;
  const _TableCell(
      {required this.text, this.isHeader = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          color: textColor,
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPrimary;
  final String? badge;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isPrimary,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: isPrimary ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isPrimary
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(badge!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            const SizedBox(height: 8),
            Text(title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                text: price,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary),
                children: [
                  TextSpan(
                      text: period,
                      style: TextStyle(
                          fontSize: 13, color: theme.colorScheme.secondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 14, color: Colors.green.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text(f, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                )),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: isPrimary
                  ? FilledButton(
                      onPressed: onTap,
                      child: const Text('Get Started'),
                    )
                  : OutlinedButton(
                      onPressed: onTap,
                      child: const Text('Get Started'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
