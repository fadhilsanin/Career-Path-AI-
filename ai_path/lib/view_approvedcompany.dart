// import 'dart:convert';
// import 'package:ai_path/upload_ressume.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class viewapplication_status extends StatelessWidget {
//   const viewapplication_status({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'View Company',
//       theme: ThemeData(primarySwatch: Colors.red),
//       home: const viewvacancy(title: 'View Companies'),
//     );
//   }
// }
//
// class viewvacancy extends StatefulWidget {
//   final String title;
//
//   const viewvacancy({super.key, required this.title});
//
//   @override
//   State<viewvacancy> createState() => _viewvacancyState();
// }
//
// class _viewvacancyState extends State<viewvacancy> {
//
//   _viewvacancyState() {
//     viewapplication_status();
//   }
//
//
//   List<String> vacancy_ = [];
//   List<String> date_ = [];
//   List<String> score_ = [];
//   List<String> status_ = [];
//   List<String> interview_date_ = [];
//   // ----------------------------------------------------------------------
//   // FETCH COMPANIES
//   // ----------------------------------------------------------------------
//   Future<void> viewapplication_status() async {
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String ip = pref.getString("url").toString();
//       String img = pref.getString("img").toString();
//
//       String url = ip + "flut_view_application/";
//       var response = await http.post(Uri.parse(url));
//       var jsondata = json.decode(response.body);
//
//       var arr = jsondata["data"];
//
//       List<String> vacancy = [];
//       List<String> date = [];
//       List<String> score = [];
//       List<String> status = [];
//       List<String> interview_date = [];
//
//
//       for (var item in arr) {
//         date.add((item['date'] ?? "").toString());
//         vacancy .add((item['vacancy'] ?? "").toString());
//         score.add((item['score'] ?? "").toString());
//         status.add((item['status'] ?? "").toString());
//         interview_date.add((item['interview_date'] ?? "").toString());
//
//       }
//         setState(() {
//           date_ = date;
//           vacancy_ = vacancy;
//           score_ = score;
//           score_ = score;
//           status_ = status;
//           interview_date_ = interview_date;
//
//
//       });
//
//     } catch (e) {
//       print("Error loading companies: $e");
//     }
//   }
//
//
//   // ----------------------------------------------------------------------
//   // UI
//   // ----------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("View All Companies", style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//
//       body: vacancy_.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: vacancy_.length,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 5,
//             margin: EdgeInsets.all(12),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   // Center(
//                   //   child: ClipRRect(
//                   //     borderRadius: BorderRadius.circular(10),
//                   //     child: Image.network(
//                   //       photo_[index],
//                   //       height: 180,
//                   //       width: double.infinity,
//                   //       fit: BoxFit.cover,
//                   //       errorBuilder: (c, e, s) =>
//                   //           Icon(Icons.broken_image, size: 100, color: Colors.red),
//                   //     ),
//                   //   ),
//                   // ),
//
//                   SizedBox(height: 15),
//
//                   Text("Vaccancy: ${vacancy_[index]}",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Text("Date: ${date_[index]}"),
//                   Text("Score: ${score_[index]}"),
//                   Text("Status: ${status_[index]}"),
//                   // Text("Interview Date: ${v[index]}"),
//
//
//                   // SizedBox(height: 20),
//                   //
//                   // Center(
//                   //   child: ElevatedButton(
//                   //     onPressed: () async {
//                   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//                   //       prefs.setString('date',date[index].toString());
//                   //
//                   //       Navigator.push(
//                   //         context,
//                   //         MaterialPageRoute(builder: (context) => ResumeUploadPage()),
//                   //       );
//                   //     },
//                   //     child: Text('send request'),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
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

class _ViewVacancyState extends State<ViewVacancy> with SingleTickerProviderStateMixin {
  List<String> vacancy_ = [];
  List<String> date_ = [];
  List<String> score_ = [];
  List<String> status_ = [];
  List<String> interview_date_ = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    fetchApplicationStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchApplicationStatus() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();

      String url = "$ip/flut_view_application/";
      var response = await http.post(Uri.parse(url));
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

      _animationController.forward();
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Color(0xFF10B981);
      case "pending":
        return Color(0xFFF59E0B);
      case "rejected":
        return Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Icons.check_circle_rounded;
      case "pending":
        return Icons.schedule_rounded;
      case "rejected":
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.red[700],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: () {
                  setState(() {
                    vacancy_.clear();
                  });
                  fetchApplicationStatus();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Applications',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.red[700]!,
                      Colors.red[500]!,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 16),
                    child: Row(
                      children: [
                        Icon(Icons.description_rounded,
                            color: Colors.white.withOpacity(0.3),
                            size: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          vacancy_.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]!),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Loading applications...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
              : SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  bool isAccepted = status_[index].toLowerCase() == "accepted";
                  Color statusColor = _getStatusColor(status_[index]);
                  IconData statusIcon = _getStatusIcon(status_[index]);

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red[700]!,
                                  Colors.red[500]!,
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.work_outline_rounded,
                                        color: Colors.white,
                                        size: 24,
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
                                  ],
                                ),
                                SizedBox(height: 12),
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
                                      SizedBox(width: 6),
                                      Text(
                                        status_[index].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
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
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  Icons.calendar_today_rounded,
                                  'Applied On',
                                  date_[index],
                                  Color(0xFF3B82F6),
                                ),
                                SizedBox(height: 16),
                                _buildDetailRow(
                                  Icons.star_rounded,
                                  'Score',
                                  score_[index],
                                  Color(0xFFF59E0B),
                                ),

                                if (isAccepted) ...[
                                  SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF10B981).withOpacity(0.1),
                                          Color(0xFF10B981).withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Color(0xFF10B981).withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF10B981),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.event_available_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Interview Scheduled',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF10B981),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                interview_date_[index],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF065F46),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[700],
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(24),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red[50],
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.event_note_rounded,
                                                      color: Colors.red[700],
                                                      size: 40,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Text(
                                                    'Interview Details',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  SizedBox(height: 24),
                                                  Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[50],
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Position',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[600],
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          vacancy_[index],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[800],
                                                          ),
                                                        ),
                                                        SizedBox(height: 16),
                                                        Text(
                                                          'Scheduled Date & Time',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[600],
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.access_time_rounded,
                                                              color: Color(0xFF10B981),
                                                              size: 20,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Expanded(
                                                              child: Text(
                                                                interview_date_[index],
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color(0xFF10B981),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 24),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: TextButton(
                                                      style: TextButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(vertical: 14),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                          color: Colors.red[700],
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.visibility_rounded, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'View Full Details',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.event_busy_rounded,
                                          color: Colors.grey[500],
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'No interview scheduled yet',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
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
                    ),
                  );
                },
                childCount: vacancy_.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}