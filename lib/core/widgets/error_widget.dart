import 'package:flutter/material.dart';
import 'package:code_mentor/core/constants/strings.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message ?? AppStrings.genericError),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
            ),
          ],
        ],
      ),
    );
  }
}
