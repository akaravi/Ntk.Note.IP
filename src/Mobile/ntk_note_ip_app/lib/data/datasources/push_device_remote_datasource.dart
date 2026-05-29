import 'package:dio/dio.dart';

import '../../api/generated/clients/ipnote_client.dart';
import '../../api/generated/models/action_register_push_device_command.dart';
import '../../api/generated/models/action_unregister_push_device_command.dart';
import '../../core/network/api_result.dart';

class PushDeviceRemoteDataSource {
  PushDeviceRemoteDataSource(this._client);

  final IpnoteClient _client;

  Future<ApiResult<void>> register({
    required String deviceToken,
    required String platform,
  }) async {
    try {
      await _client.actionRegister(
        body: ActionRegisterPushDeviceCommand(
          deviceToken: deviceToken,
          platform: platform,
        ),
      );
      return ApiResult.ok(null);
    } on DioException catch (error) {
      return ApiResult.fail(error.message ?? 'Register push device failed');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<void>> unregister({required String deviceToken}) async {
    try {
      await _client.actionUnregister(
        body: ActionUnregisterPushDeviceCommand(deviceToken: deviceToken),
      );
      return ApiResult.ok(null);
    } on DioException catch (error) {
      return ApiResult.fail(error.message ?? 'Unregister push device failed');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }
}
