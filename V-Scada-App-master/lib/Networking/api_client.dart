// import 'package:http/http.dart' as http;
//
// class ApiClient {
//   static const String baseUrl = "http://visioncgwa.com/api/";
//   final http.Client httpClient;
//
//   ApiClient({http.Client? client}) : httpClient = client ?? http.Client();
//
//   Uri getUri(String endpoint) {
//     return Uri.parse(baseUrl + endpoint);
//   }
// }
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static const String baseUrl = "http://visioncgwa.com/api/";
  final http.Client httpClient;

  ApiClient({http.Client? client}) : httpClient = client ?? LoggingHttpClient();

  Uri getUri(String endpoint) {
    return Uri.parse(baseUrl + endpoint);
  }
}

// Custom logging client that wraps http.Client
class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    print('➡️ [${request.method}] ${request.url}');
    if (request is http.Request && request.body.isNotEmpty) {
      print('📦 Body: ${request.body}');
    }

    final response = await _inner.send(request);
    final responseBody = await http.Response.fromStream(response);

    print('⬅️ [${response.statusCode}] ${response.request?.url}');
    print('📝 Response: ${responseBody.body}');

    // Reconstruct the response so it can be returned again
    return http.StreamedResponse(
      Stream.value(utf8.encode(responseBody.body)),
      response.statusCode,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
      request: request,
    );
  }
}


