import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.1.5:9000';

  // Public getter for base URL
  static String get baseUrl => _baseUrl;
  
  // Helper to get auth headers
  static Map<String, String> _getAuthHeaders({Map<String, String>? extra}) {
    final prefs = SharedPreferencesService.instance;
    String? token = prefs.getString('auth_token');
    final headers = <String, String>{
      if (token != null) 'Authorization': 'Bearer $token',
      if (extra != null) ...extra,
    };
    return headers;
  }

  // Generate quiz from PDF
  static Future<Map<String, dynamic>> generateQuiz({
    required File pdfFile,
    required String quizName,
    required int numQuestions,
    required String topic,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/generate-quiz'),
      );

      // Add PDF file
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfFile.path,
        contentType: MediaType('application', 'pdf'),
      ));

      // Add form fields
      request.fields['quiz_name'] = quizName;
      request.fields['topic'] = topic;
      request.fields['num_response_questions'] = numQuestions.toString();

      // Add auth header
      final prefs = SharedPreferencesService.instance;
      String? token = prefs.getString('auth_token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final response = await request.send().timeout(Duration(minutes: 30));
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to generate quiz: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  // Get quiz by name
  static Future<Map<String, dynamic>> getQuiz(String quizName) async {
    final headers = _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/get-quiz/$quizName'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load quiz');
    }
  }

  static Future<void> uploadPdf({
  required File pdfFile,
  required String filename,
}) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/pdfs/'),
    );

    // Add PDF file
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      pdfFile.path,
      contentType: MediaType('application', 'pdf'),
    ));

    // Add filename field
    request.fields['filename'] = filename;

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload PDF: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('API Error: $e');
  }
}


static Future<List<Map<String, dynamic>>> getUploadedPdfs() async {
  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/pdfs/'),
      headers: {'Accept-Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> pdfList = json.decode(responseBody);
      return pdfList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load PDFs: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('API Error: $e');
  }
}

static Future<List<Map<String, dynamic>>> getUploadedQuizzes() async {
  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/get-quizzes/'),
      headers: {'Accept-Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> quizList = json.decode(responseBody);
      return quizList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load Quizzes: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('API Error: $e');
  }
}

/// Fetch statistics (average, highest, lowest scores, etc.) for a quiz
static Future<Map<String, dynamic>> getQuizStatistics(String quizName) async {
  final headers = _getAuthHeaders();
  final response = await http.get(
    Uri.parse('$_baseUrl/quiz-attempts/statistics/$quizName'),
    headers: headers,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load quiz statistics');
  }
}

/// Fetch student names and their best scores for a quiz
static Future<List<Map<String, dynamic>>> getQuizScores(String quizName) async {
  final headers = _getAuthHeaders();
  final response = await http.get(
    Uri.parse('$_baseUrl/quiz-attempts/quiz-scores/$quizName'),
    headers: headers,
  );
  if (response.statusCode == 200) {
    final List<dynamic> scores = json.decode(response.body);
    return scores.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load quiz scores');
  }
}

/// Fetch the student's quiz attempts
static Future<List<Map<String, dynamic>>> getQuizAttempts() async {
  final headers = _getAuthHeaders();
  final response = await http.get(
    Uri.parse('$_baseUrl/quiz-attempts/my-attempts'),
    headers: headers,
  );
  if (response.statusCode == 200) {
    final List<dynamic> attempts = json.decode(response.body);
    return attempts.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load quiz attempts: \\${response.statusCode}');
  }
}

// Add these methods to your ApiService class
static Future<http.Response> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(responseData['message'] ?? 'Login failed');
    }
  } catch (e) {
    throw Exception('Login Error: $e');
  }
}

static Future<http.Response> signup({
  required String email,
  required String password,
  required String name, 
  required String role,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception(responseData['message'] ?? 'Signup failed');
    }
  } catch (e) {
    throw Exception('Signup Error: $e');
  }
}

static Future<List<dynamic>> faissSearch(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/faiss-search'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, dynamic>{
          'query': query,
          // 'top_k': 5, // A default value for top_k
        }),
      );

      if (response.statusCode == 200) {
        // Decode the response using utf8 before json decoding
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to perform search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

static Future<bool> deleteQuiz(String quizName) async {
  final headers = _getAuthHeaders();
  try {
    final response = await http.delete(
      Uri.parse('$_baseUrl/delete-quiz/$quizName'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw Exception('Quiz not found');
    } else {
      throw Exception('Failed to delete quiz: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('API Error: $e');
  }
}

static Future<bool> deletePdf(String pdfName) async {
  try {
    final response = await http.delete(
      Uri.parse('$_baseUrl/pdfs/$pdfName'),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw Exception('PDF not found');
    } else {
      throw Exception('Failed to delete PDF: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('API Error: $e');
  }
}

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final prefs = SharedPreferencesService.instance;
      final token = prefs.getString('auth_token');
      if (token == null) throw Exception("No auth token found");

      final response = await http.get(
        Uri.parse('$_baseUrl/profile/me'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': token,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Profile fetch error: $e');
    }
  }
  static Future<bool> updateProfile({
    required String name,
    required String password,
  }) async {
    try {
      final prefs = SharedPreferencesService.instance;
      final token = prefs.getString('auth_token');
      if (token == null) throw Exception("No auth token found");

      final Map<String, dynamic> body = {
        'name': name,
        if (password.isNotEmpty) 'password': password,
      };

      final response = await http.put(
        Uri.parse('$_baseUrl/profile/me'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': token,
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Profile update error: $e');
    }
  }

  static Future<void> logout() async {
    final prefs = SharedPreferencesService.instance;
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.setBool('loggedIn', false);
  }

  static Future<Map<String, dynamic>> search(String query) async {
    final headers = _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/search?query=$query'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to perform search');
    }
  }

  static Future<Map<String, dynamic>> submitQuiz({
    required String quizName,
    required List<Map<String, dynamic>> answers,
  }) async {
    final headers = _getAuthHeaders(extra: {'Content-Type': 'application/json'});
    final body = json.encode({'answers': answers});

    final response = await http.post(
      Uri.parse('$_baseUrl/submit-quiz/$quizName'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit quiz');
    }
  }
}
