// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // void main(){
// //   runApp(Myapp());
// // }
// //
// // class Myapp extends StatelessWidget {
// //   const Myapp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Login(),
// //     );
// //   }
// // }
// //
// //
// //
// // class Login extends StatefulWidget {
// //   const Login({super.key});
// //
// //   @override
// //   State<Login> createState() => _LoginState();
// // }
// //
// // class _LoginState extends State<Login> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Login"),
// //       ),
// //       body: Center(
// //         child: Text("Login"),
// //       ),
// //     );
// //   }
// // }
// // import 'dart:convert';
// // import 'package:deep_fake/new.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:http/http.dart' as http;
// //
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import 'home.dart';
// //
// //
// // // Import the UserHome page
// //
// // class  LoginScreen extends StatefulWidget {
// //   const  LoginScreen({super.key});
// //
// //   @override
// //   _ LoginScreenState createState() => _ LoginScreenState();
// // }
// //
// // class _ LoginScreenState extends State< LoginScreen> {
// //   final TextEditingController usernameController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //
// //   // Function to show an alert dialog
// //   void _showAlertDialog(String message) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Login Failed'),
// //           content: Text(message),
// //           actions: <Widget>[
// //             TextButton(
// //               child: const Text('OK'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [
// //               Colors.pink,
// //               Colors.pink,
// //             ],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //         ),
// //         child: SingleChildScrollView(
// //           child: Center(
// //             child: ConstrainedBox(
// //               constraints: BoxConstraints(
// //                 maxWidth: 400,
// //               ),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: <Widget>[
// //                   const SizedBox(height: 20),
// //                   const SizedBox(height: 200),
// //                   Text(
// //                     'Welcome Back!',
// //                     style: TextStyle(
// //                       fontSize: 24,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 40),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: TextField(
// //                       controller: usernameController,
// //                       decoration: InputDecoration(
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(10.0),
// //                           borderSide: BorderSide(color: Colors.white),
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(10.0),
// //                           borderSide: BorderSide(color: Colors.white),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(10.0),
// //                           borderSide: BorderSide(color: Colors.blue),
// //                         ),
// //                         labelText: 'Username',
// //                         hintText: 'Enter your username',
// //                         prefixIcon: Icon(Icons.person, color: Colors.white),
// //                         labelStyle: TextStyle(color: Colors.white),
// //                         hintStyle: TextStyle(color: Colors.white54),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: TextField(
// //                       controller: passwordController,
// //                       obscureText: true,
// //                       decoration: InputDecoration(
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(10.0),
// //                           borderSide: BorderSide(color: Colors.white),
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(10.0),
// //                           borderSide: BorderSide(color: Colors.white),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(10.0),
// //                           borderSide: BorderSide(color: Colors.blue),
// //                         ),
// //                         labelText: 'Password',
// //                         hintText: 'Enter your password',
// //                         prefixIcon: Icon(Icons.lock, color: Colors.white),
// //                         labelStyle: TextStyle(color: Colors.white),
// //                         hintStyle: TextStyle(color: Colors.white54),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Padding(
// //                     padding: const EdgeInsets.all(16.0),
// //                     child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         foregroundColor: Colors.white,
// //                         backgroundColor: Colors.pink,
// //                         padding: EdgeInsets.symmetric(
// //                             horizontal: 20.0, vertical: 15.0),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10.0),
// //                         ),
// //                         elevation: 5,
// //                       ),
// //                       onPressed: () async {
// //                         final sh = await SharedPreferences.getInstance();
// //                         try {
// //
// //                           String Uname = usernameController.text.toString();
// //                           String Passwd = passwordController.text.toString();
// //                           String url = sh.getString("url").toString();
// //
// //                           var data = await http.post(
// //                             Uri.parse(url + "logincode"),
// //                             body: {
// //                               'username': Uname,
// //                               'password': Passwd,
// //                             },
// //                           );
// //                           var jasondata = json.decode(data.body);
// //                           String status = jasondata['task'].toString();
// //                           String type = jasondata['type'].toString();
// //
// //                           if (status == "valid") {
// //                             String lid = jasondata['lid'].toString();
// //                             sh.setString("lid", lid);
// //
// //                             if (type == 'user') {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => HomePage(),
// //                                 ),
// //                               );
// //                             }
// //
// //
// //                           } else {
// //                             _showAlertDialog(
// //                                 "Username or password does not exist.");
// //                           }
// //                         }
// //                         catch(e){
// //                           // print(e.toString());
// //                           Fluttertoast.showToast(msg: "--------------"+e.toString());
// //                         }
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => HomePage(),
// //                           ),
// //                         );
// //                       },
// //                       child: const Text("Login"),
// //                     ),
// //                   ),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       const Text("Don't have an account? ",
// //                           style: TextStyle(color: Colors.white)),
// //                       TextButton(
// //                         onPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => SignUpForm(),
// //                             ),
// //                           );
// //                         },
// //                         child: const Text(
// //                           'Register',
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:ai_path/register.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'home.dart';
//
//
//
// // Import the UserHome page
//
// class  LoginScreen extends StatefulWidget {
//   const  LoginScreen({super.key});
//
//   @override
//   _ LoginScreenState createState() => _ LoginScreenState();
// }
//
// class _ LoginScreenState extends State< LoginScreen> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   // Function to show an alert dialog
//   void _showAlertDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Login Failed'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.pink,
//               Colors.pink,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Center(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: 400,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const SizedBox(height: 20),
//                   const SizedBox(height: 200),
//                   Text(
//                     'Welcome Back!',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: TextField(
//                       controller: usernameController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                         labelText: 'Username',
//                         hintText: 'Enter your username',
//                         prefixIcon: Icon(Icons.person, color: Colors.white),
//                         labelStyle: TextStyle(color: Colors.white),
//                         hintStyle: TextStyle(color: Colors.white54),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: TextField(
//                       controller: passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                         labelText: 'Password',
//                         hintText: 'Enter your password',
//                         prefixIcon: Icon(Icons.lock, color: Colors.white),
//                         labelStyle: TextStyle(color: Colors.white),
//                         hintStyle: TextStyle(color: Colors.white54),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: Colors.pink,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 15.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         elevation: 5,
//                       ),
//                       onPressed: () async {
//                         final sh = await SharedPreferences.getInstance();
//                         try {
//
//                           String Uname = usernameController.text.toString();
//                           String Passwd = passwordController.text.toString();
//                           String url = sh.getString("url").toString();
//
//                           print(url);
//                           print('================');
//
//                           var data = await http.post(
//                             Uri.parse(url + "and_logincode"),
//                             body: {
//                               'username': Uname,
//                               'password': Passwd,
//                             },
//                           );
//                           var jasondata = json.decode(data.body);
//                           String status = jasondata['task'].toString();
//                           String type = jasondata['type'].toString();
//
//
//
//                           if (status == "valid") {
//                             String lid = jasondata['lid'].toString();
//                             sh.setString("lid", lid);
//
//                             if (type == 'user') {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => HomePage(),
//                                 ),
//                               );
//                             }
//
//
//                           } else {
//                             _showAlertDialog(
//                                 "Username or password does not exist.");
//                           }
//                         }
//                         catch(e){
//                           // print(e.toString());
//                           Fluttertoast.showToast(msg: ""+e.toString());
//                           print(e);
//                         }
//                       },
//                       child: const Text("Login"),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't have an account? ",
//                           style: TextStyle(color: Colors.white)),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Registration(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           'Register',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_path/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'forgotpassword.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoginScreen(),
    );
  }
}

class  LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [

            ///  TOP BLUE CURVE BACKGROUND
            Positioned(
              top: -160,
              left: -60,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),

            Positioned(
              top: 120,
              right: -90,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),

            /// MAIN CONTENT
            ///
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    /// LOGO + NAME
                    Column(
                      children: const [
                        SizedBox(height: 10),
                        Text(
                          "Career Path",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// USERNAME FIELD
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        hintText: "UserName",
                        filled: true,
                        fillColor: Colors.blue.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// PASSWORD FIELD
                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.blue.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// SIGNUP LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>signup()));
                          },
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: ()async {
                          final sh = await SharedPreferences.getInstance();
                          String Uname=userController.text.toString();
                          String Passwd=passController.text.toString();
                          String url = sh.getString("url").toString();
                          String img = sh.getString("img").toString();
                          print("okkkkkkkkkkkkkkkkk");
                          var data = await http.post(
                              Uri.parse(url+"and_login/"),
                              body: {'username':Uname,
                                "password":Passwd,
                              });
                          var jasondata = json.decode(data.body);
                          String status=jasondata['status'].toString();
                          String type=jasondata['type'].toString();
                          if(status=="ok") {
                            if (type == 'User') {
                              String lid = jasondata['lid'].toString();
                              String photo = img + jasondata['photo'].toString();
                              String name = jasondata['name'].toString();
                              String email = jasondata['email'].toString();
                              sh.setString("lid", lid);
                              sh.setString("photo", photo);
                              sh.setString("name", name);
                              sh.setString("email", email);
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => UserHomepage()));
                            }

                            else{
                              print("error");

                            }
                          }
                          else{
                            print("error");

                          }

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Login  ",
                              style: TextStyle(fontSize: 18),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),

                    // const SizedBox(height: 25),
                    //
                    // /// SOCIAL LOGIN
                    // const Text("or continue with"),
                    //
                    //
                    // const SizedBox(height: 10),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: const [
                    //     Icon(Icons.facebook, size: 32, color: Colors.blue),
                    //     SizedBox(width: 20),
                    //     Icon(Icons.g_mobiledata, size: 40, color: Colors.redAccent),
                    //     SizedBox(width: 20),
                    //     Icon(Icons.apple, size: 32, color: Colors.black),
                    //   ],
                    // ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>forgotpage()));
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),

            /// BOTTOM BLUE CIRCLE
            Positioned(
              bottom: -140,
              right: -90,
              child: Container(
                height: 260,
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
