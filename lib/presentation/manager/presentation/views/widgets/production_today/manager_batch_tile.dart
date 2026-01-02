import 'package:flutter/material.dart';

class ManagerBatchTile extends StatelessWidget {
  final String product;
  final String line;
  final int qty;
  final String status;
  final String? imageUrl;

  const ManagerBatchTile({
    super.key,
    required this.product,
    required this.line,
    required this.qty,
    required this.status,
    this.imageUrl,
  });

  Color _statusColor() {
    switch (status) {
      case "passed":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "waiting_qc":
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          /// ✅ Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.withOpacity(0.15),
                    child: const Icon(Icons.image, size: 26),
                  ),
          ),

          const SizedBox(width: 12),

          /// ✅ Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Line: $line | Qty: $qty",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// ✅ Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor().withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _statusColor().withOpacity(0.25)),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: _statusColor(),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
