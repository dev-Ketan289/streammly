import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class QuoteRepo {
  final ApiClient apiClient;
  QuoteRepo({required this.apiClient});

  Future<Response> submitQuote(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.submitQuoteUrl, body);
  }
}
