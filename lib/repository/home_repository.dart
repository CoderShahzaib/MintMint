import 'package:mindmint/data/network/base_api_services.dart';
import 'package:mindmint/data/network/network_api_services.dart';
import 'package:mindmint/model/general_knowledge.dart';
import 'package:riverpod/riverpod.dart';

class HomeRepository {
  final BaseApiServices _apiServices = NetworkApiServices();
  Future<GeneralKnowledge> fetchGeneralKnowledge(String url) async {
    try {
      dynamic response = await _apiServices.getApiResponse(url);
      return GeneralKnowledge.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}

final homeRepositoryProvider = Provider((ref) => HomeRepository());
final generalKnowledgeProvider =
    FutureProvider.family<GeneralKnowledge, String>((ref, categoryUrl) async {
      final repo = ref.watch(homeRepositoryProvider);
      return repo.fetchGeneralKnowledge(categoryUrl);
    });
