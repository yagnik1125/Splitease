// import 'dart:convert';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class LoginApi extends StatefulWidget {
  const LoginApi({super.key});
  @override
  State<LoginApi> createState() => _LoginApiState();
}

class _LoginApiState extends State<LoginApi> {
  // postdata() async {
  //   var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  //   var body = {
  //     "id": 11.toString(),
  //     "name": "Yagnik",
  //     "email": "yagnik111@gmail.com"
  //   };
  //   var response = await http.post(url, body: body);
  //   print(response.body);
  // }

  postApi() async {
    const String apiUrl = "http://192.168.137.1:8000/login";
    const String email = "example@example.com"; // Replace with your email
    const String password = "your_password"; // Replace with your password

    // // Create a map containing the data
    // Map<String, dynamic> body = {
    //   "email": email,
    //   "password": password,
    // };

    // // Convert the map to JSON
    // String jsonData = jsonEncode(data);

    try {
      // Make the POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": email,
          "password": password,
        }),
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Request was successful, handle the response data
        print("Response: ${response.body}");
      } else {
        // Request failed, handle the error
        print("-->Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any exception that occurred during the request
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Post"),
          onPressed: () {
            postApi();
            // postdata();
            print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
          },
        ),
      ),
    );
  }
}
