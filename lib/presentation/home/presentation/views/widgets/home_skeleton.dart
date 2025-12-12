import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header skeleton
                _line(width: 180, height: 20),
                const SizedBox(height: 10),
                _line(width: 110, height: 14),
                const SizedBox(height: 22),

                // Welcome card skeleton
                _box(height: 110),
                const SizedBox(height: 22),

                // Stats skeleton (3 tiles)
                Row(
                  children: const [
                    Expanded(child: _StatBox()),
                    SizedBox(width: 10),
                    Expanded(child: _StatBox()),
                    SizedBox(width: 10),
                    Expanded(child: _StatBox()),
                  ],
                ),
                const SizedBox(height: 28),

                // Role section title
                _line(width: 160, height: 18),
                const SizedBox(height: 16),

                // Role cards skeleton
                _box(height: 90),
                const SizedBox(height: 14),
                _box(height: 90),
                const SizedBox(height: 14),
                _box(height: 90),
              ],
            ),
          ),
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
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _box({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
