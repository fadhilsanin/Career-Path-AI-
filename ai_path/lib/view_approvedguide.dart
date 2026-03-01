import 'dart:convert';
// import 'package:ai_path/chat_guide.dart';
import 'package:ai_path/view_company.dart';
import 'package:ai_path/view_vaccancy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class approvedguide1 extends StatelessWidget {
  const approvedguide1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guide Requests',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
      ),
      home: const approvedguidePage(title: 'Guide Requests'),
    );
  }
}

class approvedguidePage extends StatefulWidget {
  final String title;

  const approvedguidePage({super.key, required this.title});

  @override
  State<approvedguidePage> createState() => _approvedguidePageState();
}

class _approvedguidePageState extends State<approvedguidePage> with SingleTickerProviderStateMixin {
  List<String> user_ = [];
  List<String> request_ = [];
  List<String> status_ = [];
  List<String> date_ = [];
  List<String> guide_ = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    approvedguide();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> approvedguide() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();

      String url = ip + "flut_view_request_status/";
      var response = await http.post(Uri.parse(url));
      var jsondata = json.decode(response.body);

      var arr = jsondata["data"];

      List<String> request = [];
      List<String> status = [];
      List<String> date = [];
      List<String> user = [];
      List<String> guide = [];

      for (var item in arr) {
        guide.add((item['guide'] ?? "").toString());
        request.add((item['request'] ?? "").toString());
        status.add((item['status'] ?? "").toString());
        date.add((item['date'] ?? "").toString());
        user.add((item['user'] ?? "").toString());
      }

      setState(() {
        user_ = user;
        request_ = request;
        status_ = status;
        date_ = date;
        guide_ = guide;
      });

      _animationController.forward();
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
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
      case "approved":
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
                    request_.clear();
                  });
                  approvedguide();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Guide Requests',
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
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white.withOpacity(0.3),
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          request_.isEmpty
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
                    'Loading guide requests...',
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
                  Color statusColor = _getStatusColor(status_[index]);
                  IconData statusIcon = _getStatusIcon(status_[index]);
                  bool isApproved = status_[index].toLowerCase() == "approved" ||
                      status_[index].toLowerCase() == "accepted";

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
                                        Icons.person_pin_rounded,
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
                                            'Guide',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            guide_[index],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoCard(
                                  Icons.description_rounded,
                                  'Request',
                                  request_[index],
                                  Color(0xFF3B82F6),
                                ),
                                SizedBox(height: 12),
                                _buildInfoCard(
                                  Icons.calendar_today_rounded,
                                  'Date',
                                  date_[index],
                                  Color(0xFF8B5CF6),
                                ),
                                SizedBox(height: 12),
                                _buildInfoCard(
                                  Icons.person_rounded,
                                  'User',
                                  user_[index],
                                  Color(0xFF06B6D4),
                                ),

                                if (isApproved) ...[
                                  SizedBox(height: 20),
                                  Container(
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
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF10B981),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.chat_bubble_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Your request has been approved!\nYou can now chat with your guide.',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF065F46),
                                              fontWeight: FontWeight.w600,
                                              height: 1.4,
                                            ),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NewFeedbackPage(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.chat_rounded, size: 20),
                                          SizedBox(width: 10),
                                          Text(
                                            'Start Chat with Guide',
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
                                          Icons.pending_rounded,
                                          color: Colors.grey[500],
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          status_[index].toLowerCase() == "pending"
                                              ? 'Awaiting approval'
                                              : 'Request not approved',
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
                childCount: request_.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
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
          Expanded(
            child: Column(
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
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