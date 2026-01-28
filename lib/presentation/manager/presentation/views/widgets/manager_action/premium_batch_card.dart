import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumBatchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusRaw;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onPdf;
    

  const PremiumBatchCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusRaw,
    required this.imageUrl,
    required this.onTap,
    this.onPdf,
  });

  bool get _isHighRisk => statusRaw.toUpperCase().contains("HIGH_RISK");
  bool get _isFailed => statusRaw.toUpperCase().contains("FAIL");
  bool get _isPending =>
      statusRaw.toUpperCase().contains("WAIT") ||
      statusRaw.toUpperCase().contains("PENDING");
  bool get _isApproved =>
      statusRaw.toUpperCase().contains("PASS") ||
      statusRaw.toUpperCase().contains("APPROV");
  bool get _isBlocked => statusRaw.toUpperCase().contains("BLOCK");

  Color get _statusColor {
    if (_isHighRisk) return Colors.orange;
    if (_isBlocked) return Colors.blueGrey;
    if (_isFailed) return Colors.red;
    if (_isApproved) return Colors.green;
    if (_isPending) return Colors.amber;
    return Colors.grey;
  }

  IconData get _statusIcon {
    if (_isHighRisk) return Icons.warning_amber_rounded;
    if (_isBlocked) return Icons.lock_rounded;
    if (_isFailed) return Icons.cancel_rounded;
    if (_isApproved) return Icons.verified_rounded;
    if (_isPending) return Icons.hourglass_bottom_rounded;
    return Icons.info_outline_rounded;
  }

  String get _statusLabel {
    final s = statusRaw.trim();
    if (s.isEmpty) return "UNKNOWN";
    return s.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor;

    Widget glowWrapper({required Widget child}) {
      if (!_isHighRisk) return child;

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.18, end: 0.45),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
        builder: (context, v, _) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(v),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          );
        },
        onEnd: () {},
      );
    }

    return glowWrapper(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // status bar
                      Container(
                        width: 5,
                        height: 62,
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // image
                      _Thumb(imageUrl: imageUrl),
                      const SizedBox(width: 12),

                      // text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(_statusIcon, size: 16, color: statusColor),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14.5,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _StatusPill(
                              label: _statusLabel,
                              color: statusColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ✅ Trailing actions (PDF + chevron) aligned & consistent
                      SizedBox(
                        width: onPdf == null ? 28 : 68,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (onPdf != null) ...[
                              _MiniIconBtn(
                                icon: Icons.picture_as_pdf_rounded,
                                color: statusColor,
                                onTap: onPdf!,
                                tooltip: "Generate PDF",
                              ),
                              const SizedBox(width: 6),
                            ],
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String imageUrl;
  const _Thumb({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Center(
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.grey.shade400,
                  ),
                )
              : Icon(Icons.inventory_2_outlined, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _MiniIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? tooltip;

  const _MiniIconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final btn = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );

    if (tooltip == null) return btn;
    return Tooltip(message: tooltip!, child: btn);
  }
}
