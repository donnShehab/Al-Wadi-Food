import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:alwadi_food/theme.dart';

class QCDashboardSkeleton extends StatelessWidget {
  const QCDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingLg,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(width: 240, height: 18),
            const SizedBox(height: 18),
            Row(
              children: const [
                Expanded(child: _box(height: 92)),
                SizedBox(width: 12),
                Expanded(child: _box(height: 92)),
                SizedBox(width: 12),
                Expanded(child: _box(height: 92)),
              ],
            ),
            const SizedBox(height: 22),
            const _box(height: 90),
            const SizedBox(height: 16),
            const _box(height: 70),
            const SizedBox(height: 22),
            _line(width: 180, height: 16),
            const SizedBox(height: 10),
            const _box(height: 70),
            const SizedBox(height: 10),
            const _box(height: 70),
          ],
        ),
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}

class _box extends StatelessWidget {
  final double height;
  const _box({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
