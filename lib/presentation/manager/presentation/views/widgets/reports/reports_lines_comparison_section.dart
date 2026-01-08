import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';

enum LineSortMode { passRate, failed, risk, total }

class ReportsLinesComparisonSection extends StatefulWidget {
  final List<ReportsLineComparisonEntity> lines;
  final ReportsLineComparisonEntity? bestLine;
  final ReportsLineComparisonEntity? worstLine;

  const ReportsLinesComparisonSection({
    super.key,
    required this.lines,
    required this.bestLine,
    required this.worstLine,
  });

  @override
  State<ReportsLinesComparisonSection> createState() =>
      _ReportsLinesComparisonSectionState();
}


class _ReportsLinesComparisonSectionState
    extends State<ReportsLinesComparisonSection> {
  bool expanded = false;
  LineSortMode sortMode = LineSortMode.passRate;
  String query = "";

  @override
  Widget build(BuildContext context) {
    if (widget.lines.isEmpty) {
      return _emptyCard(context, "No line comparison data available.");
    }

    final scheme = Theme.of(context).colorScheme;

    // ✅ Filter
    final filtered = widget.lines.where((l) {
      if (query.trim().isEmpty) return true;
      return l.lineName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // ✅ Sort
    filtered.sort((a, b) {
      switch (sortMode) {
        case LineSortMode.failed:
          return b.failed.compareTo(a.failed);
        case LineSortMode.risk:
          return b.highRisk.compareTo(a.highRisk);
        case LineSortMode.total:
          return b.total.compareTo(a.total);
        case LineSortMode.passRate:
        default:
          return b.passRate.compareTo(a.passRate);
      }
    });

    final chartLines = filtered.take(6).toList();
    final visibleRows = expanded ? filtered : filtered.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Header Row
        Row(
          children: [
            Icon(Icons.factory_rounded, color: scheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Line Performance",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Compare production lines by pass rate, risk levels and QC failures.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface.withOpacity(0.65),
          ),
        ),
        const SizedBox(height: 16),

        // ✅ Best / Worst
        Row(
          children: [
            Expanded(
              child: _highlightBadge(
                context,
                title: "Best Line",
                value: widget.bestLine?.lineName ?? "-",
                percent: widget.bestLine?.passRate ?? 0,
                icon: Icons.trending_up_rounded,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _highlightBadge(
                context,
                title: "Worst Line",
                value: widget.worstLine?.lineName ?? "-",
                percent: widget.worstLine?.passRate ?? 0,
                icon: Icons.trending_down_rounded,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // ✅ MAIN CARD
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: scheme.outline.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // ✅ Search + Sort
              Row(
                children: [
                  Expanded(child: _searchField(context)),
                  const SizedBox(width: 10),
                  _sortDropdown(context),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: scheme.outline.withOpacity(0.12)),
              const SizedBox(height: 16),

              // ✅ Chart
              _chartHeader(context, "Top 6"),
              const SizedBox(height: 12),
              _barChart(context, chartLines),

              const SizedBox(height: 16),
              Divider(color: scheme.outline.withOpacity(0.15)),
              const SizedBox(height: 14),

              // ✅ Table
              _tableHeader(context),
              const SizedBox(height: 10),
              Divider(color: scheme.outline.withOpacity(0.12)),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: Column(
                  key: ValueKey("$expanded-$query-$sortMode"),
                  children: visibleRows.map((line) {
                    final isBest =
                        widget.bestLine != null &&
                        line.lineName == widget.bestLine!.lineName;
                    final isWorst =
                        widget.worstLine != null &&
                        line.lineName == widget.worstLine!.lineName;

                    return _lineRow(
                      context,
                      line: line,
                      highlightBest: isBest,
                      highlightWorst: isWorst,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              if (filtered.length > 6)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => setState(() => expanded = !expanded),
                    icon: Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: scheme.primary,
                    ),
                    label: Text(
                      expanded ? "Collapse" : "View All Lines",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ✅ Search Field
  // ============================================================
  Widget _searchField(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      onChanged: (v) => setState(() => query = v),
      style: const TextStyle(fontWeight: FontWeight.w800),
      decoration: InputDecoration(
        hintText: "Search line...",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface.withOpacity(0.45),
        ),
        prefixIcon: Icon(Icons.search_rounded, color: scheme.primary),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withOpacity(0.35),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outline.withOpacity(0.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outline.withOpacity(0.10)),
        ),
      ),
    );
  }

  // ============================================================
  // ✅ Sort Dropdown
  // ============================================================
  Widget _sortDropdown(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LineSortMode>(
          value: sortMode,
          icon: Icon(Icons.filter_list_rounded, color: scheme.primary),
          items: const [
            DropdownMenuItem(
              value: LineSortMode.passRate,
              child: Text("Pass Rate"),
            ),
            DropdownMenuItem(
              value: LineSortMode.failed,
              child: Text("Failures"),
            ),
            DropdownMenuItem(value: LineSortMode.risk, child: Text("Risk")),
            DropdownMenuItem(value: LineSortMode.total, child: Text("Total")),
          ],
          onChanged: (v) => setState(() => sortMode = v!),
        ),
      ),
    );
  }

  // ============================================================
  // ✅ Chart Header
  // ============================================================
  Widget _chartHeader(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.bar_chart_rounded, color: scheme.primary),
        const SizedBox(width: 8),
        Text(
          "Top Lines (Pass Rate)",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: scheme.primary.withOpacity(0.08),
            border: Border.all(color: scheme.primary.withOpacity(0.18)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: scheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ✅ Bar Chart
  // ============================================================
  Widget _barChart(
    BuildContext context,
    List<ReportsLineComparisonEntity> chartLines,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: chartLines.map((line) {
        final percent = (line.passRate.clamp(0, 100)) / 100;

        Color color = scheme.primary;
        if (widget.bestLine != null &&
            line.lineName == widget.bestLine!.lineName) {
          color = Colors.green;
        }
        if (widget.worstLine != null &&
            line.lineName == widget.worstLine!.lineName) {
          color = Colors.redAccent;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 95,
                child: Text(
                  line.lineName,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 12,
                    backgroundColor: scheme.surfaceContainerHighest.withOpacity(
                      0.45,
                    ),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 44,
                child: Text(
                  "${line.passRate.toStringAsFixed(0)}%",
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // ✅ Table Header
  // ============================================================
  Widget _tableHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "Line",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Total",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Pass",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Risk",
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ✅ Line Row
  // ============================================================
  Widget _lineRow(
    BuildContext context, {
    required ReportsLineComparisonEntity line,
    required bool highlightBest,
    required bool highlightWorst,
  }) {
    final scheme = Theme.of(context).colorScheme;

    Color barColor = scheme.primary;
    Color bg = Colors.transparent;
    Color border = Colors.transparent;

    if (highlightBest) {
      barColor = Colors.green;
      bg = Colors.green.withOpacity(0.06);
      border = Colors.green.withOpacity(0.20);
    } else if (highlightWorst) {
      barColor = Colors.redAccent;
      bg = Colors.redAccent.withOpacity(0.06);
      border = Colors.redAccent.withOpacity(0.20);
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                if (highlightBest) _tag("BEST", Colors.green),
                if (highlightWorst) _tag("WORST", Colors.redAccent),
                if (highlightBest || highlightWorst) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    line.lineName,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              line.total.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _miniBar(context, value: line.passRate, color: barColor),
          ),
          Expanded(
            flex: 1,
            child: Text(
              line.highRisk.toString(),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: line.highRisk > 0
                    ? Colors.orange
                    : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBar(
    BuildContext context, {
    required double value,
    required Color color,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final percent = (value.clamp(0, 100)) / 100;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: scheme.surfaceContainerHighest.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "${value.toStringAsFixed(0)}%",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          color: color,
        ),
      ),
    );
  }

  Widget _emptyCard(BuildContext context, String text) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface.withOpacity(0.65),
        ),
      ),
    );
  }
  // ✅ Highlight Badge
  Widget _highlightBadge(
    BuildContext context, {
    required String title,
    required String value,
    required double percent,
    required IconData icon,
    required Color color,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface.withOpacity(0.60),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${percent.toStringAsFixed(1)}%",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
