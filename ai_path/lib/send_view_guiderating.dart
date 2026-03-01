import 'dart:convert';
import 'package:ai_path/view_vaccancy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewFeedbackPage1 extends StatefulWidget {
  @override
  _NewFeedbackPage1State createState() => _NewFeedbackPage1State();
}

class _NewFeedbackPage1State extends State<NewFeedbackPage1> {
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
            Text("Rate Guide",
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
                String uid = sh.getString("lid").toString();
                // String rating = sh.getString("rating").toString();

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
