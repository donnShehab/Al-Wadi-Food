import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/user_management_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/user_management_state.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserManagementCubit>()..loadUsers(),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Management')),
        body: BlocConsumer<UserManagementCubit, UserManagementState>(
          listener: (context, state) {
            if (state is UserManagementSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is UserManagementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UserManagementLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserManagementLoaded) {
              if (state.users.isEmpty) {
                return const Center(child: Text('No users found'));
              }
              return ListView.builder(
                padding: AppSpacing.paddingMd,
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(user.name),
                      subtitle: Text('${user.email} • ${user.role}'),
                      trailing: Switch(
                        value: user.isActive,
                        onChanged: (_) => context
                            .read<UserManagementCubit>()
                            .toggleUserStatus(user),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
