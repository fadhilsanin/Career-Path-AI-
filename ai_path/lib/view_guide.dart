
import 'dart:convert';
import 'package:ai_path/send_view_guiderating.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewGuides extends StatefulWidget {
  const ViewGuides({super.key});

  @override
  State<ViewGuides> createState() => _ViewGuidesState();
}

class _ViewGuidesState extends State<ViewGuides> {
  List<dynamic> guides = [];

  _ViewGuidesState() {
    fetchGuides();
  }

  // -------------------------------------------------------------------
  // FETCH GUIDE DETAILS FROM SERVER
  // -------------------------------------------------------------------
  Future<void> fetchGuides() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString(); // stored IP

      String url = "$ip/flut_view_guide/";
      var response = await http.post(Uri.parse(url));

      var jsondata = jsonDecode(response.body);

      if (jsondata["status"] == "ok") {
        setState(() {
          guides = jsondata["data"];
        });
      }
    } catch (e) {
      print("ERROR : $e");
    }
  }

  // -------------------------------------------------------------------
  // SHOW REQUEST MESSAGE DIALOG
  // -------------------------------------------------------------------
  void showRequestDialog(String guideId) {
    TextEditingController msgController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Send Request"),
          content: TextField(
            controller: msgController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter your request message",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (msgController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a message")),
                  );
                  return;
                }

                Navigator.pop(context);
                sendGuideRequest(guideId, msgController.text);
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }
 void showRequestDialog_feedback(String guideId) {
    TextEditingController msgController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Send Feedback"),
          content: TextField(
            controller: msgController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter your Feedback",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (msgController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a message")),
                  );
                  return;
                }

                Navigator.pop(context);
                sendGuideRequest(guideId, msgController.text);
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------------
  // SEND REQUEST TO SERVER
  // -------------------------------------------------------------------
  Future<void> sendGuideRequest(String guideId, String message) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();
      String lid = pref.getString("lid").toString();

      String url = "$ip/flut_send_request/";

      var response = await http.post(Uri.parse(url), body: {
        "guide_id": guideId,
        "lid": lid,
        "request_message": message,
      });

      var jsondata = jsonDecode(response.body);

      if (jsondata["status"] == "ok") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request Sent Successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send request")),
        );
      }
    } catch (e) {
      print("REQUEST ERROR: $e");
    }
  }

  // -------------------------------------------------------------------
  // UI
  // -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Guides"),
        backgroundColor: Colors.red,
      ),

      body: guides.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: guides.length,
        itemBuilder: (context, index) {
          var g = guides[index];

          return Card(
            elevation: 5,
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    g["name"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 5),

                  Text("Gender: ${g['gender']}"),
                  Text("Email: ${g['email']}"),
                  Text("Phone: ${g['phone']}"),
                  Text("Date Of Brith: ${g['place']}"),
                  Text("Qualification: ${g['qualifiication']}"),
                  Text("Experience: ${g['experience']} years"),

                  SizedBox(height: 15),

                  Center(
                    child:
                        Row(children: [

                          SizedBox(width: 10,),
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            showRequestDialog(g["id"].toString());
                          },
                          child: Text(
                            "Send Request",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('gid', g["id"].toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => NewFeedbackPage1()),
                            );
                          },
                          child: Text(
                            "Send Rating",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        ],)


                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
///////////////////////////////////////////////////////feedback/////////////////////////////////////////////////////

class NewFeedbackPage extends StatefulWidget {
  @override
  _NewFeedbackPageState createState() => _NewFeedbackPageState();
}

class _NewFeedbackPageState extends State<NewFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int rating = 0;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Widget buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              rating = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Write a New Feedback"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Rate guide",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            buildRatingStars(),
            SizedBox(height: 20),

            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter your feedback...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final sh = await SharedPreferences.getInstance();

                String feedback = _feedbackController.text.trim();
                String url = sh.getString("url").toString();
                String gid = sh.getString("gid").toString();
                String uid = sh.getString("uid").toString();
                String date = sh.getString("date").toString();

                if (rating == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please give a rating!")));
                  return;
                }

                var data = await http.post(
                  Uri.parse(url + "flut_send_g_rating/"),
                  body: {
                    'review': feedback,
                    'gid': gid,
                    'uid': uid,
                    'date': date,
                    'rating': rating.toString(),
                  },
                );

                var jsondata = json.decode(data.body);

                if (jsondata['status'] == "ok") {
                  Navigator.pop(context);
                } else {
                  print("Error sending feedback");
                }
              },
              child: Text("Submit Feedback"),
            ),


          ],
        ),
      ),
    );
  }
}


