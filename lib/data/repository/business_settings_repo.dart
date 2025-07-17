import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class BusinessSettingRepo {
  final ApiClient apiClient;
  BusinessSettingRepo({required this.apiClient});

  Future<Response> getBusinessSettings() async {
    return await apiClient.getData(AppConstants.businessSettingUri);
  }
}
