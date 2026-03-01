import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewApplicationStatus extends StatelessWidget {
  const ViewApplicationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Application Status',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const ViewVacancy(title: 'Application Status'),
    );
  }
}

class ViewVacancy extends StatefulWidget {
  final String title;

  const ViewVacancy({super.key, required this.title});

  @override
  State<ViewVacancy> createState() => _ViewVacancyState();
}

class _ViewVacancyState extends State<ViewVacancy> {
  _ViewVacancyState() {
    fetchApplicationStatus();
  }

  List<String> vacancy_ = [];
  List<String> date_ = [];
  List<String> score_ = [];
  List<String> status_ = [];
  List<String> interview_date_ = [];

  Future<void> fetchApplicationStatus() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();

      String url = "$ip/flut_view_application/";
      var response = await http.post(Uri.parse(url), body: {
        'lid': pref.getString("lid").toString()
      });
      var jsondata = json.decode(response.body);

      var arr = jsondata["data"];

      List<String> vacancy = [];
      List<String> date = [];
      List<String> score = [];
      List<String> status = [];
      List<String> interview_date = [];

      for (var item in arr) {
        vacancy.add((item['vacancy'] ?? "").toString());
        date.add((item['date'] ?? "").toString());
        score.add((item['score'] ?? "").toString());
        status.add((item['status'] ?? "").toString());
        interview_date.add((item['interview_date'] ?? "").toString());
      }

      setState(() {
        vacancy_ = vacancy;
        date_ = date;
        score_ = score;
        status_ = status;
        interview_date_ = interview_date;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Icons.check_circle;
      case "pending":
        return Icons.access_time;
      case "rejected":
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Applications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchApplicationStatus,
          ),
        ],
      ),
      body: vacancy_.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.red[700],
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              "Loading applications...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchApplicationStatus,
        color: Colors.red[700],
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: vacancy_.length,
          itemBuilder: (context, index) {
            bool isScheduled = status_[index].toLowerCase() == "scheduled";
            Color statusColor = _getStatusColor(status_[index]);
            IconData statusIcon = _getStatusIcon(status_[index]);

            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with status badge
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[700]!, Colors.red[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
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
                            Icons.work_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            vacancy_[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                status_[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.calendar_today,
                          "Applied On",
                          date_[index],
                          Colors.blue,
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.star_outline,
                          "Score",
                          score_[index],
                          Colors.amber,
                        ),

                        if (isScheduled) ...[
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green[200]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_available,
                                  color: Colors.green[700],
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Interview Scheduled",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        interview_date_[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green[900],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[700],
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.event,
                                          color: Colors.red[700],
                                        ),
                                        SizedBox(width: 8),
                                        Text("Interview Details"),
                                      ],
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Position:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          vacancy_[index],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "Scheduled Date & Time:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          interview_date_[index],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Close",
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                "View Full Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pending_outlined,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "No interview scheduled yet",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}