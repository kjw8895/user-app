import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/terms_model.dart';

class TermsService {
  final ApiClient _apiClient;

  TermsService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<TermsModel>> getSignUpTerms() async {
    try {
      final response = await _apiClient.get(
        '${AppConstants.termsEndpoint}?type=USER_SIGN_UP_TERMS',
      );
      
      if (response['data'] == null) {
        throw AuthFailure(message: 'Invalid server response: missing data');
      }

      final List<dynamic> termsList = response['data'];
      return termsList.map((json) => TermsModel.fromJson(json)).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to get terms: $e');
    }
  }

  Future<String> getTermsContent(String resourceUrl) async {
    try {
      final response = await http.get(Uri.parse(resourceUrl));
      
      if (response.statusCode != 200) {
        throw AuthFailure(message: 'Failed to fetch terms content: ${response.statusCode}');
      }

      return response.body;
    } catch (e) {
      print('Error fetching terms content: $e');
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to get terms content: $e');
    }
  }
} 