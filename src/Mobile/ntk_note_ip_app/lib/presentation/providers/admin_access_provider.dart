import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/admin_remote_datasource.dart';
import '../../domain/entities/admin_models.dart';
import 'app_providers.dart';
import 'auth_controller.dart';

final adminRemoteDataSourceProvider = Provider<AdminRemoteDataSource>((ref) {
  return AdminRemoteDataSource(ref.watch(apiClientProvider).dio);
});

final adminAccessProvider = FutureProvider<AdminAccess?>((ref) async {
  final auth = ref.watch(authControllerProvider);
  if (!auth.isAuthenticated) {
    return null;
  }

  final result = await ref.read(adminRemoteDataSourceProvider).getAccess();
  return result.isSuccess ? result.data : null;
});
