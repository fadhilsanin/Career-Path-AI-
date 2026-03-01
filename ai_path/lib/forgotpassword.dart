import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'login.dart';


void main() {
  runApp(forgot());
}
class forgot extends StatelessWidget {
  const forgot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: forgotpage(),
    );
  }
}
class forgotpage extends StatefulWidget {
  const forgotpage({super.key});

  @override
  State<forgotpage> createState() => _forgotpageState();
}

class _forgotpageState extends State<forgotpage> {
  TextEditingController emailcontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot password?'),backgroundColor: Colors.deepOrangeAccent,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'enter email',border: OutlineInputBorder()),
              controller: emailcontroller,
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailcontroller.text.trim();
                SharedPreferences sh = await SharedPreferences.getInstance();

                String? url = sh.getString('url');
                if (url == null) {
                  Fluttertoast.showToast(msg: 'Base URL not set');
                  return;
                }

                final urls = Uri.parse('$url/forgotpasswordflutter/');

                try {
                  final response = await http.post(urls, body: {'email': email});
                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body);
                    if (data['status'] == 'ok') {
                      Fluttertoast.showToast(msg: 'OTP sent to your email');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpPage(email: email)),
                      );
                    } else {
                      Fluttertoast.showToast(msg: data['message']);
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'Network error');
                  }
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              child: Text('Verify Email'),
            )

          ],
        ),
      ),
    );
  }
}


class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(labelText: "Enter OTP", border: OutlineInputBorder()),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences sh = await SharedPreferences.getInstance();
                String? url = sh.getString('url');
                if (url == null) return;

                final urls = Uri.parse('$url/verifyOtpflutterPost/');
                final response = await http.post(urls, body: {
                  'entered_otp': otpController.text.trim(),
                  'email': widget.email,

                });

                if (response.statusCode == 200) {
                  var data = jsonDecode(response.body);
                  if (data['status'] == 'ok') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPasswordPage(email: widget.email)),
                    );
                  } else {
                    Fluttertoast.showToast(msg: 'Invalid OTP');
                  }
                } else {
                  Fluttertoast.showToast(msg: 'Network Error');
                }
              },
              child: Text("Verify OTP"),
            )
          ],
        ),
      ),
    );
  }
}

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder()),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences sh = await SharedPreferences.getInstance();
                String? url = sh.getString('url');
                if (url == null) return;

                final urls = Uri.parse('$url/changePasswordflutter/');
                final response = await http.post(urls, body: {
                  'newPassword': passController.text.trim(),
                  'confirmPassword': confirmController.text.trim(),
                  'email': widget.email, // pass email explicitly if backend needs
                });

                if (response.statusCode == 200) {
                  var data = jsonDecode(response.body);
                  if (data['status'] == 'ok') {
                    Fluttertoast.showToast(msg: 'Password changed successfully');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  LoginScreen()),
                    );
                  } else {

                    Fluttertoast.showToast(msg:'Password changed successfully');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  LoginScreen()),
                    );
                  }
                }
              },
              child: Text("Change Password"),
            )
          ],
        ),
      ),
    );
  }
}
