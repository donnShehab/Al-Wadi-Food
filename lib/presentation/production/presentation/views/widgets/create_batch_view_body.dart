import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';

class CreateBatchViewBody extends StatelessWidget {
  const CreateBatchViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CreateBatchViewBodyBlocConsumer(theme: theme);
  }
}
