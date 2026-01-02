import 'package:flutter/material.dart';

class KpiShimmerGrid extends StatelessWidget {
  const KpiShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 140,
          ),
          itemBuilder: (_, __) => _shimmerBox(),
        ),
        const SizedBox(height: 14),
        _shimmerBox(height: 82),
      ],
    );
  }

  Widget _shimmerBox({double height = 140}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }
}
