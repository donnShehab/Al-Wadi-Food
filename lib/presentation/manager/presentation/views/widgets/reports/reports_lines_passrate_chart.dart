import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';

enum PassRateSortType { passRate, highRisk, total }

class ReportsLinesPassRateChart extends StatefulWidget {
  final List<ReportsLineComparisonEntity> lines;

  const ReportsLinesPassRateChart({super.key, required this.lines});

  @override
  State<ReportsLinesPassRateChart> createState() =>
      _ReportsLinesPassRateChartState();
}

class _ReportsLinesPassRateChartState extends State<ReportsLinesPassRateChart> {
  PassRateSortType sortType = PassRateSortType.passRate;
  String query = "";
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.lines.isEmpty) return const SizedBox();

    final scheme = Theme.of(context).colorScheme;

    // ✅ Filter by search query
    final filtered = widget.lines
        .where((l) => l.lineName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // ✅ Sort logic
    filtered.sort((a, b) {
      switch (sortType) {
        case PassRateSortType.passRate:
          return b.passRate.compareTo(a.passRate);
        case PassRateSortType.highRisk:
          return b.highRisk.compareTo(a.highRisk);
        case PassRateSortType.total:
          return b.total.compareTo(a.total);
      }
    });

    if (filtered.isEmpty) {
      return _emptyState(context);
    }

    final best = filtered.first;
    final worst = filtered.last;

    // ✅ default show top 8 unless expanded
    final visible = expanded ? filtered : filtered.take(8).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ HEADER
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: scheme.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Line Pass Rate Dashboard",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),

              // ✅ Sort dropdown
              _sortDropdown(context),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Corporate ranking overview for production line performance.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.65),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          // ✅ SEARCH BAR
          _searchBar(context),

          const SizedBox(height: 16),

          // ✅ LIST VIEW (Virtualized)
          SizedBox(
            height: expanded ? 520 : 420, // ✅ controlled height
            child: ListView.builder(
              itemCount: visible.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final l = visible[index];
                final rank = index + 1;

                final isBest = l.lineName == best.lineName;
                final isWorst = l.lineName == worst.lineName;

                final percent = (l.passRate.clamp(0, 100)) / 100;

                final barColor = _smartColor(
                  scheme,
                  l.passRate,
                  isBest: isBest,
                  isWorst: isWorst,
                );

                return _lineCard(
                  context,
                  line: l,
                  rank: rank,
                  isBest: isBest,
                  isWorst: isWorst,
                  percent: percent,
                  barColor: barColor,
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // ✅ Expand / Collapse Button
          if (filtered.length > 8)
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

          const SizedBox(height: 10),

          // ✅ Footer insight
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: scheme.primary.withOpacity(0.06),
              border: Border.all(color: scheme.primary.withOpacity(0.16)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: scheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Tip: Improve the WORST line first — it raises overall factory performance quickly.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Sort Dropdown
  // ============================================================
  Widget _sortDropdown(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.surfaceContainerHighest.withOpacity(0.35),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PassRateSortType>(
          value: sortType,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: scheme.primary),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
          onChanged: (v) => setState(() => sortType = v!),
          items: const [
            DropdownMenuItem(
              value: PassRateSortType.passRate,
              child: Text("Pass Rate"),
            ),
            DropdownMenuItem(
              value: PassRateSortType.highRisk,
              child: Text("High Risk"),
            ),
            DropdownMenuItem(
              value: PassRateSortType.total,
              child: Text("Total"),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ✅ Search Bar
  // ============================================================
  Widget _searchBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      onChanged: (v) => setState(() => query = v),
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
      decoration: InputDecoration(
        hintText: "Search line...",
        hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.5)),
        prefixIcon: Icon(Icons.search_rounded, color: scheme.primary),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withOpacity(0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outline.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outline.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.35)),
        ),
      ),
    );
  }

  // ============================================================
  // ✅ Line Card
  // ============================================================
  Widget _lineCard(
    BuildContext context, {
    required ReportsLineComparisonEntity line,
    required int rank,
    required bool isBest,
    required bool isWorst,
    required double percent,
    required Color barColor,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isBest
            ? Colors.green.withOpacity(0.06)
            : isWorst
            ? Colors.redAccent.withOpacity(0.05)
            : scheme.surface,
        border: Border.all(
          color: barColor.withOpacity(isBest || isWorst ? 0.22 : 0.12),
        ),
      ),
      child: Column(
        children: [
          // ✅ Title Row
          Row(
            children: [
              _rankBadge(rank, scheme),
              const SizedBox(width: 8),

              if (isBest) _tag("BEST", Colors.green),
              if (isWorst) _tag("WORST", Colors.redAccent),
              if (line.highRisk >= 5 && !isBest && !isWorst)
                _tag("RISK", Colors.orange),
              if (isBest || isWorst || line.highRisk >= 5)
                const SizedBox(width: 8),

              Expanded(
                child: Text(
                  line.lineName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "${line.passRate.toStringAsFixed(1)}%",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: barColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ✅ Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: scheme.surfaceContainerHighest.withOpacity(0.45),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),

          const SizedBox(height: 10),

          // ✅ Stats row
          Row(
            children: [
              _miniInfo(
                context,
                label: "Total",
                value: "${line.total}",
                icon: Icons.fact_check_rounded,
              ),
              const SizedBox(width: 10),
              _miniInfo(
                context,
                label: "High Risk",
                value: "${line.highRisk}",
                icon: Icons.warning_amber_rounded,
                color: line.highRisk > 0 ? Colors.orange : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Rank Badge
  // ============================================================
  Widget _rankBadge(int rank, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.primary.withOpacity(0.10),
        border: Border.all(color: scheme.primary.withOpacity(0.18)),
      ),
      child: Text(
        "#$rank",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: scheme.primary,
        ),
      ),
    );
  }

  // ============================================================
  // ✅ Smart Color Mapping
  // ============================================================
  Color _smartColor(
    ColorScheme scheme,
    double passRate, {
    required bool isBest,
    required bool isWorst,
  }) {
    if (isBest) return Colors.green;
    if (isWorst) return Colors.redAccent;

    if (passRate >= 90) return Colors.green;
    if (passRate >= 70) return scheme.secondary;
    return Colors.redAccent;
  }

  // ============================================================
  // ✅ Tag
  // ============================================================
  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.12),
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

  // ============================================================
  // ✅ Mini Info Row
  // ============================================================
  Widget _miniInfo(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.onSurface.withOpacity(0.75);

    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: c),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withOpacity(0.65),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: c,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Empty state
  // ============================================================
  Widget _emptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_off_rounded, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "No lines match your search.",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
