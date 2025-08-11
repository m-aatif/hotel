import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'http://192.168.1.13:5000';

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      print('Health check error: $e');
      return false;
    }
  }

  /// Updated face recognition for mobile
  Future<Map<String, dynamic>> recognizeFaceFromImage(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/face_recognition_mobile'),
      );
      request.files.add(await http.MultipartFile.fromPath('photo', image.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);

      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (e) {
      print('Face recognition mobile error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message, String guestName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
          'guest_name': guestName,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to get AI response');
    } catch (e) {
      print('Chat error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> recognizeFace() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/face_recognition'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Face recognition failed');
    } catch (e) {
      print('Face recognition error: $e');
      rethrow;
    }
  }

  Future<bool> textToSpeech(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/speak'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Text-to-speech error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getHotelInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/hotel_info'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to get hotel info');
    } catch (e) {
      print('Hotel info error: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getConversationHistory(String guestName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversation_history/$guestName'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['history'] ?? [];
      }
      return [];
    } catch (e) {
      print('Conversation history error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getGuestInfo(String guestName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/guest_info/$guestName'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to get guest info');
    } catch (e) {
      print('Guest info error: $e');
      rethrow;
    }
  }

  Future<bool> updateGuestInfo(String guestName, Map<String, dynamic> info) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_guest_info'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'guest_name': guestName,
          'info': info,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Update guest info error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getGuestPreferences(String guestName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/guest_preferences'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'guest_name': guestName}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      print('Guest preferences error: $e');
      return {};
    }
  }

  Future<bool> uploadProfilePhoto(File image, String guestName) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload_profile_photo'),
      );
      request.fields['guest_name'] = guestName;
      request.files.add(
        await http.MultipartFile.fromPath('photo', image.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      if (response.statusCode == 200 && data['success'] == true) {
        return true;
      }
      print('Upload profile photo error: ${data['error'] ?? 'Unknown error'}');
      return false;
    } catch (e) {
      print('Upload profile photo error: $e');
      return false;
    }
  }
}
