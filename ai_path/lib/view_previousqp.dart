import 'dart:convert';
import 'package:ai_path/view_vaccancy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class previousqp extends StatelessWidget {
  const previousqp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View previous year question pp',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const previousqpPage(),
    );
  }
}

class previousqpPage extends StatefulWidget {
  const previousqpPage({super.key});

  @override
  State<previousqpPage> createState() => _previousqpPageState();
}

class _previousqpPageState extends State<previousqpPage> {
  _previousqpPageState() {
    previousqp();
  }

  List<String> qid_ = [];
  List<String> questionpaper_ = [];
  List<String> answersheet_ = [];
  List<String> year_ = [];
  List<String> exam_ = [];
  List<String> guide_ = [];

  Future<void> previousqp() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();
      String img = pref.getString("img").toString();

      String url = ip + "flut_view_previusqp/";
      var response = await http.post(Uri.parse(url));
      var jsondata = json.decode(response.body);

      var arr = jsondata["data"];

      List<String> qid = [];
      List<String> questionpaper = [];
      List<String> answersheet = [];
      List<String> year = [];
      List<String> exam = [];
      List<String> guide = [];

      for (var item in arr) {
        qid.add((item['qid'] ?? "").toString());
        questionpaper
            .add((img + "media/" + item['qustionpaper'] ?? "").toString());
        answersheet
            .add((img + "media/" + item['answersheet'] ?? "").toString());
        year.add((item['year'] ?? "").toString());
        exam.add((item['exam'] ?? "").toString());
        guide.add((item['guide'] ?? "").toString());
      }

      setState(() {
        qid_ = qid;
        questionpaper_ = questionpaper;
        answersheet_ = answersheet;
        year_ = year;
        exam_ = exam;
        guide_ = guide;
      });
    } catch (e) {
      print("Error loading paper: $e");
    }
  }

  // ----------------------------------------------------------------------
  // UI
  // ----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.library_books, size: 28, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Question Papers",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: questionpaper_.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepOrange,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Loading question papers...",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: questionpaper_.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.orange[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange,
                            Colors.orangeAccent
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.quiz,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exam_[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Year: ${year_[index]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content Section
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Guide Info
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Guide",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        guide_[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Download Buttons Section
                          Text(
                            "Downloads",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 12),

                          // Question Paper Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final Uri _googleUrl =
                                Uri.parse(questionpaper_[index]);
                                launchUrl(
                                  _googleUrl,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              icon: Icon(Icons.download, size: 22),
                              label: Text(
                                "Question Paper",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),

                          SizedBox(height: 12),

                          // Answer Key Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final Uri _googleUrl =
                                Uri.parse(answersheet_[index]);
                                launchUrl(
                                  _googleUrl,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              icon: Icon(Icons.check_circle, size: 22),
                              label: Text(
                                "Answer Key",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
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
}