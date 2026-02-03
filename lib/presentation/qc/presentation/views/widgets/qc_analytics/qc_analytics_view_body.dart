import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_header.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_insights_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_kpi_row.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_trend_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_line_performance_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_top_failure_reasons_card.dart';
import 'package:flutter/material.dart';

class QCAnalyticsViewBody extends StatelessWidget {
  final List<QCTrendDayEntity> trend;
  final List<QCResultEntity> results;

  const QCAnalyticsViewBody({
    super.key,
    required this.trend,
    required this.results,
  });

  int _passRateOf(List<QCTrendDayEntity> t) {
    final p = t.fold<int>(0, (s, d) => s + d.passed);
    final f = t.fold<int>(0, (s, d) => s + d.failed);
    final total = p + f;
    if (total == 0) return 0;
    return ((p / total) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final passedTotal = trend.fold<int>(0, (sum, d) => sum + d.passed);
    final failedTotal = trend.fold<int>(0, (sum, d) => sum + d.failed);
    final total = passedTotal + failedTotal;
    final passRate = total == 0 ? 0 : ((passedTotal / total) * 100).round();

    // ✅ What changed (proxy): last 3 days vs first 3 days
    String? changeLabel;
    String? changeValue;
    bool? isUp;

    if (trend.length >= 6) {
      final first = trend.take(3).toList();
      final last = trend.skip(trend.length - 3).toList();

      final firstRate = _passRateOf(first);
      final lastRate = _passRateOf(last);

      final diff = lastRate - firstRate; // percentage points (pp)
      isUp = diff >= 0;

      changeLabel = "vs early week";
      changeValue = diff == 0 ? "0pp" : "${diff > 0 ? '+' : ''}${diff}pp";
    }

    final bg = BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topCenter,
        radius: 1.15,
        colors: [
          theme.colorScheme.surface,
          theme.colorScheme.primary.withOpacity(0.035),
        ],
      ),
    );

    return DecoratedBox(
      decoration: bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QCAnalyticsHeader(
              changeLabel: changeLabel,
              changeValue: changeValue,
              isUp: isUp,
            ),
            const SizedBox(height: 10),

            _SectionIn(
              delayMs: 0,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  const _Pill(
                    icon: Icons.calendar_today_rounded,
                    text: "Last 7 Days",
                  ),
                  _Pill(
                    icon: Icons.percent_rounded,
                    text: "Pass Rate: $passRate%",
                  ),
                  _Pill(
                    icon: Icons.check_circle_rounded,
                    text: "Total Pass: $passedTotal",
                  ),
                  _Pill(
                    icon: Icons.cancel_rounded,
                    text: "Total Fail: $failedTotal",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _SectionIn(delayMs: 60, child: QCAnalyticsKPIRow(trend: trend)),
            const SizedBox(height: 16),

            _SectionIn(delayMs: 120, child: QCAnalyticsTrendCard(trend: trend)),
            const SizedBox(height: 16),

            _SectionIn(
              delayMs: 180,
              child: QCTopFailureReasonsCard(
                results: results,
                // ✅ لاحقاً بتربطه (هسا بيظهر disabled إذا null)
                onViewBatches: null,
              ),
            ),
            const SizedBox(height: 16),

            _SectionIn(
              delayMs: 240,
              child: QCLinePerformanceCard(results: results),
            ),
            const SizedBox(height: 16),

            _SectionIn(
              delayMs: 300,
              child: QCAnalyticsInsightsCard(trend: trend),
            ),
          ],
        ),
      ),
    );
  }
}

/// دخول خفيف (UI only)
class _SectionIn extends StatelessWidget {
  const _SectionIn({required this.child, required this.delayMs});

  final Widget child;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        final v = t.clamp(0.0, 1.0);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * 10),
            child: child,
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
