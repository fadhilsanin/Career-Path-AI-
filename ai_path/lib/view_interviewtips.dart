import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewGuidestips extends StatefulWidget {
  const ViewGuidestips({super.key});

  @override
  State<ViewGuidestips> createState() => _ViewGuidestipsState();
}

class _ViewGuidestipsState extends State<ViewGuidestips> {
  List guides = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGuides();
  }

  // -------------------------------------------------------------------
  // FETCH GUIDE DETAILS FROM SERVER
  // -------------------------------------------------------------------
  Future<void> fetchGuides() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();
      String url = "$ip/flut_view_interviewtips/";

      var response = await http.post(Uri.parse(url));
      var jsondata = jsonDecode(response.body);

      if (jsondata["status"] == "ok") {
        setState(() {
          guides = jsondata["data"];
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // -------------------------------------------------------------------
  // SHOW REQUEST MESSAGE DIALOG
  // -------------------------------------------------------------------
  // void showRequestDialog(String guideId) {
  //   TextEditingController msgController = TextEditingController();
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         title: Row(
  //           children: [
  //             Icon(Icons.send, color: Colors.deepPurple),
  //             SizedBox(width: 10),
  //             // Text(
  //             //   "Send ",
  //             //   style: TextStyle(
  //             //     fontSize: 20,
  //             //     fontWeight: FontWeight.bold,
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //         content: TextField(
  //           controller: msgController,
  //           maxLines: 4,
  //           decoration: InputDecoration(
  //             hintText: "Enter your message...",
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             filled: true,
  //             fillColor: Colors.grey[50],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Send request logic here
  //               Navigator.pop(context);
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.deepPurple,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //             child: Text("Send"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // -------------------------------------------------------------------
  // UI
  // -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 28),
            SizedBox(width: 10),
            Text(
              "Interview Tips",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchGuides();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Loading tips...",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
            : guides.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              SizedBox(height: 20),
              Text(
                "No tips available",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: guides.length,
          itemBuilder: (context, index) {
            var g = guides[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.purple[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    // Header with gradient
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.purpleAccent
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              g["guide"] ?? "Guide",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tips Section
                          _buildInfoRow(
                            icon: Icons.tips_and_updates,
                            label: "Tips",
                            value: g['tips'] ?? "N/A",
                            color: Colors.orange,
                          ),
                          SizedBox(height: 12),

                          // Description Section
                          _buildInfoRow(
                            icon: Icons.description,
                            label: "Description",
                            value: g['discriptio'] ?? "N/A",
                            color: Colors.blue,
                          ),
                          SizedBox(height: 12),

                          // Date Section
                          _buildInfoRow(
                            icon: Icons.calendar_today,
                            label: "Date",
                            value: g['date'] ?? "N/A",
                            color: Colors.green,
                          ),
                          SizedBox(height: 16),

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            // child: ElevatedButton.icon(
                            //   onPressed: () {
                            //     showRequestDialog(g["id"].toString());
                            //   },
                            //   icon: Icon(Icons.send),
                            //   label: Text(
                            //     "Send Request",
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.deepPurple,
                            //     foregroundColor: Colors.white,
                            //     padding: EdgeInsets.symmetric(
                            //       vertical: 14,
                            //     ),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius:
                            //       BorderRadius.circular(12),
                            //     ),
                            //     elevation: 3,
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper widget for info rows
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}