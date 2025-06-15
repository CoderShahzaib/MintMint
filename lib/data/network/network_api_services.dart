import 'dart:convert';
import 'package:http/http.dart';
import 'package:mindmint/data/network/base_api_services.dart';
import 'package:mindmint/data/response/exception.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getApiResponse(String url) async {
    try {
      final Response response = await get(Uri.parse(url));
      return returnResponse(response);
    } catch (e) {
      throw e.toString();
    }
  }
}

dynamic returnResponse(Response response) {
  switch (response.statusCode) {
    case 200:
      var data = utf8.decode(response.bodyBytes);
      var responseJson = jsonDecode(data);
      return responseJson;
    default:
      throw FetchDataException(
        "Error occured while communicating with server with status code ${response.statusCode}",
      );
  }
}
