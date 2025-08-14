import '../../models/banner/promo_slider_model.dart';
import '../../models/company/company_location.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';

class PromoSliderRepo {
  final ApiClient apiClient;

  PromoSliderRepo({required this.apiClient});

  Future<List<PromoSliderModel>> getSliders() async {
    final response = await apiClient.getData(
      AppConstants.slidersUrl,
    ); // Add this to constants
    final List<dynamic> data = response.body['data'] ?? [];
    return data.map((e) => PromoSliderModel.fromJson(e)).toList();
  }

  // Add this method to PromoSliderRepo
  Future<CompanyLocation?> getStudioById(int studioId) async {
    final response = await apiClient.getData(
      '${AppConstants.baseUrl}/studios/$studioId',
    );

    if (response.statusCode == 200 && response.body['data'] != null) {
      return CompanyLocation.fromJson(response.body['data']);
    }
    return null;
  }
}
