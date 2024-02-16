import 'dart:convert';
import 'package:regradocorte_app/shared/constants/routes.dart';
import 'package:http/http.dart' as http;

class LoginService {
  login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(Routes().signIn()),
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );
     // Check if the response has a successful status code (e.g., 200)
    if (response.statusCode == 200) {
      print("Login successful");
      return true;
    } else {
      // Print error details if the login fails
      print("Login failed. Status code: ${response.statusCode}, Body: ${response.body}");
      return false;
    }
  }
}