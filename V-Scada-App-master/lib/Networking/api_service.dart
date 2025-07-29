import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:v_scada/models/ProductModel.dart';
import 'package:v_scada/models/UserProfileModel.dart';
import '../models/AlertModel.dart';
import '../models/BorwellModel.dart';
import '../models/DashboardDataModel.dart';
import '../models/LiveDataModel.dart';
import '../models/PumpResponse.dart';
import '../models/ReportData.dart';
import '../screens/BorewellScreen.dart';
import 'api_client.dart';

class ApiService {
  final ApiClient apiClient;

  ApiService({required this.apiClient});

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = apiClient.getUri('client-login');

    final response = await apiClient.httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getPumpData(String userId) async {
    final url = apiClient.getUri('data?user_id=$userId');

    final response = await apiClient.httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get pump data: ${response.statusCode}');
    }
  }

  // Future<Map<String, dynamic>> fetchBorwellData(String userId) async {
  //   final url = apiClient.getUri('pumps?user_id=$userId');
  //   final response = await apiClient.httpClient.get(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to get pump data: ${response.statusCode}');
  //   }
  // }

  Future<List<BorwellModel>> fetchBorewellData(String userId) async {
    final url = apiClient.getUri('pumps?user_id=$userId');

    final response = await apiClient.httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final company = jsonData['company'] ?? '';
      final profilePic = jsonData['profile_pic'] ?? '';
      final data = jsonData['data'] as List<dynamic>;

      return data.map((item) => BorwellModel.fromJson(item, company, profilePic)).toList();
    } else {
      throw Exception('Failed to load borewell data');
    }
  }




  Future<PumpResponse> viewBorwelldata(String userId, String pumpId) async {
    final url = apiClient.getUri('pumpdata?user_id=$userId&pump_id=$pumpId');

    final response = await apiClient.httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return PumpResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load borewell data');
    }
  }




  Future<UserProfileModel> getUserprofileData(String userId) async {
    final url = apiClient.getUri('account?user_id=$userId');

    final response = await apiClient.httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

     // final userProfile = UserProfileModel.fromJson(jsonDecode(response.body));


      return UserProfileModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load borewell data');
    }
  }


  Future<DashboardDataModel> fetchDashboardStats(String userId) async {
    final url = apiClient.getUri('dashboard?user_id=$userId');

    final response = await apiClient.httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'}, // or remove if not required
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DashboardDataModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch dashboard stats: ${response.statusCode}');
    }
  }



  Future<AlertModel> AlertApi(String userId) async {
    final url = apiClient.getUri('alert'); // Remove query parameters from URL

    final response = await apiClient.httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return AlertModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch alerts: ${response.statusCode}');
    }
  }


  Future<ProductModel> ProductAPi(String userId) async {
    final url = apiClient.getUri('product'); // Remove query parameters from URL

    final response = await apiClient.httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ProductModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch alerts: ${response.statusCode}');
    }
  }


  Future<PumpReport?> fetchPumpReport(String userId, String month, String pumpid) async {
    final url = apiClient.getUri('report'); // no query params in URL

    final body = jsonEncode({
      "user_id": userId,
      "month": month,
      "pump_id": pumpid,
    });

    final headers = {
      "Content-Type": "application/json",
    };

    print('POST URL: $url');
    print('Headers: $headers');
    print('Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return PumpReport.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }


  Future<bool> updateUserProfileData(
      String userId,
      Map<String, String> updateData,
      File? imageFile,
      ) async {
    final uri = Uri.parse('http://visioncgwa.com/api/accountUpdate?id=$userId');

    var request = http.MultipartRequest('POST', uri);

    // Add text fields
    updateData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add image file if selected
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_pic', imageFile.path));
    }

    // Add headers if required
    request.headers.addAll({
      'Accept': 'application/json',
      // Add more headers if needed
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      print('Response: $respStr');
      final jsonResponse = jsonDecode(respStr);
      return jsonResponse['status'] == true;
    } else {
      print('Failed to update. Status code: ${response.statusCode}');
      return false;
    }
  }


// Future<bool> updateUserProfileData(String userId, Map<String, String> updateData) async {
  //   final url = Uri.parse("http://visioncgwa.com/api/accountUpdate?id=$userId");
  //
  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json", // helps prevent 302 redirection
  //   };
  //
  //   final body = jsonEncode(updateData);
  //
  //   print('POST URL: $url');
  //   print('Headers: $headers');
  //   print('Body: $body');
  //
  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       return jsonResponse['status'] == true; // Adjust based on actual API
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Exception during update: $e');
  //     return false;
  //   }
  // }



  // Future<ReportData> fetchReportData(String userId, String month,pumpid) async {
  //   final url = apiClient.getUri('getReport'); // no query params in URL
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'user_id': userId,
  //       'month': month,
  //       'pump_id': pumpid,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     return ReportData.fromJson(json);
  //   } else {
  //     throw Exception('Failed to load report data');
  //   }
  // }

}





