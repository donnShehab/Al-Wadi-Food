import 'package:flutter/material.dart';

class ActionNeededItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  final String badgeText;
  final Color badgeColor;

  final VoidCallback onOpen;
  final VoidCallback? onResolve;
  final VoidCallback? onAssign;

  /// ✅ NEW
  final bool isAssigned;
  final String? assignedTo;

  const ActionNeededItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badgeText,
    required this.badgeColor,
    required this.onOpen,
    this.onResolve,
    this.onAssign,
    this.isAssigned = false,
    this.assignedTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image),
                  ),
          ),

          const SizedBox(width: 12),

          /// ✅ Right Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ✅ Title + Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// ✅ CRITICAL / FAILED badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: badgeColor.withOpacity(0.25)),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// ✅ Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                /// ✅ Assigned Label
                if (isAssigned) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                      assignedTo == null || assignedTo!.isEmpty
                          ? "Assigned"
                          : "Assigned: $assignedTo",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                /// ✅ Buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _miniBtn(
                      label: "Open",
                      color: Colors.blue,
                      icon: Icons.open_in_new,
                      onTap: onOpen,
                    ),

                    if (onAssign != null)
                      _miniBtn(
                        label: isAssigned ? "Re-assign" : "Assign",
                        color: Colors.orange,
                        icon: Icons.person_add_alt_1,
                        onTap: onAssign!,
                      ),

                    if (onResolve != null)
                      _miniBtn(
                        label: "Resolve",
                        color: Colors.green,
                        icon: Icons.check_circle_outline,
                        onTap: onResolve!,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
