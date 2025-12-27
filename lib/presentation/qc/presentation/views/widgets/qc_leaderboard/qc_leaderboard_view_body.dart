import 'package:flutter/material.dart';
import 'qc_leaderboard_view_body_bloc_consumer.dart';

class QCLeaderboardViewBody extends StatelessWidget {
  const QCLeaderboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return QCLeaderboardViewBodyBlocConsumer(theme: Theme.of(context));
  }
}
