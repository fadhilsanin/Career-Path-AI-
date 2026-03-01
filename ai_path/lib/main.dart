import 'package:ai_path/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -90,
              left: -60,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),

            Positioned(
              top: 120,
              right: -90,
              child: Container(
                height: 260,
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: const [
                        Icon(Icons.star, size: 60, color: Colors.blue),
                        SizedBox(height: 10),
                        Text(
                          "CAREER PATH AI",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// IP TEXT FIELD
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        hintText: "Enter IP Address",
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

                    const SizedBox(height: 20),

                    /// SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          String ip = userController.text.trim();

                          if (_isValidIp(ip)) {
                            final sh = await SharedPreferences.getInstance();
                            sh.setString("url", "http://$ip:8000/myapp/");
                            sh.setString("img", "http://$ip:8000/");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("IP Saved Successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>   LoginScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Invalid IP Address"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "SET IP",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              right: -80,
              child: Container(
                height: 260,
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// IP VALIDATION FUNCTION
  bool _isValidIp(String ip) {
    final ipRegex = RegExp(
      r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipRegex.hasMatch(ip);
  }
}

/// DUMMY HOME PAGE AFTER SAVING IP
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snap) {
            if (!snap.hasData) return CircularProgressIndicator();

            final url = snap.data!.getString("url") ?? "No URL Saved";

            return Text(
              "Saved URL:\n$url",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
    );
  }
}




// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import 'login.dart';
// //
//
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         // This is the theme of your application.
// //         //
// //         // TRY THIS: Try running your application with "flutter run". You'll see
// //         // the application has a purple toolbar. Then, without quitting the app,
// //         // try changing the seedColor in the colorScheme below to Colors.green
// //         // and then invoke "hot reload" (save your changes or press the "hot
// //         // reload" button in a Flutter-supported IDE, or press "r" if you used
// //         // the command line to start the app).
// //         //
// //         // Notice that the counter didn't reset back to zero; the application
// //         // state is not lost during the reload. To reset the state, use hot
// //         // restart instead.
// //         //
// //         // This works for code too, not just values: Most code changes can be
// //         // tested with just a hot reload.
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const ipset(),
// //     );
// //   }
// // }
// //
// //
// //
// // class ipset extends StatefulWidget {
// //   const ipset({super.key});
// //
// //   @override
// //   State<ipset> createState() => _ipsetState();
// // }
// //
// // class _ipsetState extends State<ipset> {
// //   final TextEditingController ipController = TextEditingController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           "CAREER PATH AI",
// //           style: TextStyle(fontWeight: FontWeight.w600),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 20),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //
// //               const Text(
// //                 "Enter Server IP Address",
// //                 style: TextStyle(
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black87,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 20),
// //
// //               TextField(
// //                 controller: ipController,
// //                 decoration: InputDecoration(
// //                   labelText: "IP Address",
// //                   hintText: "e.g. 192.168.1.5",
// //                   prefixIcon: const Icon(Icons.wifi_tethering),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 25),
// //
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 55,
// //                 child: FilledButton.icon(
// //                   onPressed: () async {
// //                     String ip = ipController.text.trim();
// //                     final sh = await SharedPreferences.getInstance();
// //                     sh.setString("url", "http://$ip:5000/");
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (_) => LoginPage()),
// //                     );
// //                   },
// //                   icon: const Icon(Icons.check_circle_outline),
// //                   label: const Text(
// //                     "SAVE & CONTINUE",
// //                     style: TextStyle(fontSize: 17),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     );
//   }
// }
//
// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});
//
//   final TextEditingController userController = TextEditingController();
//   // final TextEditingController passController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//
//             ///  TOP BLUE CURVE BACKGROUND
//             Positioned(
//               top: -90,
//               left: -60,
//               child: Container(
//                 height: 300,
//                 width: 300,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade700,
//                   borderRadius: BorderRadius.circular(180),
//                 ),
//               ),
//             ),
//
//             Positioned(
//               top: 120,
//               right: -90,
//               child: Container(
//                 height: 260,
//                 width: 260,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade500,
//                   borderRadius: BorderRadius.circular(180),
//                 ),
//               ),
//             ),
//
//             /// MAIN CONTENT
//             Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 32),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//
//                     /// LOGO + NAME
//                     Column(
//                       children: const [
//                         Icon(Icons.star, size: 60, color: Colors.blue),
//                         SizedBox(height: 10),
//                         Text(
//                           "CAREER PATH AI",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         )
//                       ],
//                     ),
//
//                     const SizedBox(height: 40),
//
//                     /// USERNAME FIELD
//                     TextField(
//                       controller: userController,
//                       decoration: InputDecoration(
//                         hintText: "IP",
//                         filled: true,
//                         fillColor: Colors.blue.shade100,
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 18, horizontal: 18),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//
//
//
//
//                     const SizedBox(height: 10),
//
//                     /// LOGIN BUTTON
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade700,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onPressed: () async {
//                           print("jjjjjjjjjjjjjjjjjjj");
//                           String ip = userController.text.trim();
//                           if (_isValidIp(ip)) {
//                             final sh = await SharedPreferences.getInstance();
//                             sh.setString("url", "http:/$ip:7000/");
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(builder: (context) => LoginPage()),
//                             );
//                           }
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Text(
//                               "IP SET ",
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             Icon(Icons.arrow_forward),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 25),
//
//
//
//                   ],
//                 ),
//               ),
//             ),
//
//             /// BOTTOM BLUE CIRCLE
//             Positioned(
//               bottom: -100,
//               right: -80,
//               child: Container(
//                 height: 260,
//                 width: 260,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade400,
//                   borderRadius: BorderRadius.circular(180),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool _isValidIp(String ip) {
//     // Basic IP address format validation
//     final ipRegex = RegExp(
//       r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
//     );
//     return ipRegex.hasMatch(ip);
//   }
// }
