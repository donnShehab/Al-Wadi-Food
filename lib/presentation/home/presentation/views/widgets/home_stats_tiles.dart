// import 'package:alwadi_food/presentation/animations/animated_number.dart';
// import 'package:flutter/material.dart';

// class HomeStatsTiles extends StatelessWidget {
//   final int total;
//   final int passed;
//   final int issues;

//   const HomeStatsTiles({
//     super.key,
//     required this.total,
//     required this.passed,
//     required this.issues,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _StatTile(
//           label: "Total Batches",
//           value: total,
//           color: Colors.blue,
//           icon: Icons.inventory_2,
//         ),
//         _StatTile(
//           label: "Passed QC",
//           value: passed,
//           color: Colors.green,
//           icon: Icons.check_circle,
//         ),
//         _StatTile(
//           label: "Issues",
//           value: issues,
//           color: Colors.redAccent,
//           icon: Icons.warning_amber_rounded,
//         ),
//       ],
//     );
//   }
// }

// class _StatTile extends StatelessWidget {
//   final String label;
//   final int value;
//   final Color color;
//   final IconData icon;

//   const _StatTile({
//     required this.label,
//     required this.value,
//     required this.color,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.07),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: 28, color: color),
//             const SizedBox(height: 6),
//             _InteractiveNumber(value: value, color: color),

//             const SizedBox(height: 4),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 11),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _InteractiveNumber extends StatefulWidget {
//   final int value;
//   final Color color;

//   const _InteractiveNumber({required this.value, required this.color});

//   @override
//   State<_InteractiveNumber> createState() => _InteractiveNumberState();
// }

// class _InteractiveNumberState extends State<_InteractiveNumber> {
//   bool _pressed = false;

//   void _onTapDown(_) => setState(() => _pressed = true);
//   void _onTapUp(_) => setState(() => _pressed = false);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: _onTapDown,
//       onTapUp: _onTapUp,
//       onTapCancel: () => setState(() => _pressed = false),
//       child: AnimatedScale(
//         scale: _pressed ? 1.08 : 1.0,
//         duration: const Duration(milliseconds: 160),
//         curve: Curves.easeOutBack,
//         child: AnimatedDefaultTextStyle(
//           duration: const Duration(milliseconds: 160),
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: _pressed ? widget.color.withOpacity(0.9) : widget.color,
//           ),
//           child: AnimatedNumber(value: widget.value),
//         ),
//       ),
//     );
//   }
// }
import 'package:alwadi_food/presentation/animations/animated_number.dart';
import 'package:alwadi_food/presentation/animations/staggered_fade_slide_item.dart';
import 'package:flutter/material.dart';

class HomeStatsTiles extends StatelessWidget {
  final int total;
  final int passed;
  final int issues;

  const HomeStatsTiles({
    super.key,
    required this.total,
    required this.passed,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StaggeredSlideFade(
            index: 0,
            offsetY: 18,
            child: _StatTile(
              label: "Total Batches",
              value: total,
              color: Colors.blue,
              icon: Icons.inventory_2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StaggeredSlideFade(
            index: 1,
            offsetY: 18,
            child: _StatTile(
              label: "Passed QC",
              value: passed,
              color: Colors.green,
              icon: Icons.check_circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StaggeredSlideFade(
            index: 2,
            offsetY: 18,
            child: _StatTile(
              label: "Issues",
              value: issues,
              color: Colors.redAccent,
              icon: Icons.warning_amber_rounded,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          _InteractiveNumber(value: value, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _InteractiveNumber extends StatefulWidget {
  final int value;
  final Color color;

  const _InteractiveNumber({required this.value, required this.color});

  @override
  State<_InteractiveNumber> createState() => _InteractiveNumberState();
}

class _InteractiveNumberState extends State<_InteractiveNumber> {
  bool _pressed = false;

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOutBack,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 170),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _pressed ? widget.color.withOpacity(0.9) : widget.color,
          ),
          child: AnimatedNumber(value: widget.value),
        ),
      ),
    );
  }
}
