import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_reports_view_body_bloc_consumer.dart';

class QCReportsViewBody extends StatelessWidget {
  const QCReportsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return QCReportsViewBodyBlocConsumer(theme: Theme.of(context));
  }
}
