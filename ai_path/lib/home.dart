import 'dart:convert';
import 'package:ai_path/send%20app%20feedback.dart';
import 'package:ai_path/send_complaint.dart';
import 'package:ai_path/view_applicationstatus.dart';
import 'package:ai_path/view_approvedguide.dart';
import 'package:ai_path/view_company.dart';
import 'package:ai_path/view_guide.dart';
import 'package:ai_path/view_interviewtips.dart';
import 'package:ai_path/view_motivideo.dart';
import 'package:ai_path/view_previousqp.dart';
import 'package:ai_path/viewexam.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import 'jobrecommendation.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> with SingleTickerProviderStateMixin {
  String name = '';
  String email = '';
  String photo = '';
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Enhanced color palette with gradients
  static const Color _primary = Color(0xFFF97316);
  static const Color _primaryDark = Color(0xFFEA580C);
  static const Color _accent = Color(0xFFFB923C);
  static const Color _bg = Color(0xFFF8FAFC);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);
  static const Color _surface = Colors.white;
  static const Color _divider = Color(0xFFE2E8F0);
  static const Color _success = Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final sh = await SharedPreferences.getInstance();
    setState(() {
      name = sh.getString('name') ?? 'User';
      email = sh.getString('email') ?? 'example@mail.com';
      photo = sh.getString('photo') ?? '';
    });
  }

  void _onNavTap(int index) => setState(() => _selectedIndex = index);

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDanger
                ? Colors.red.withOpacity(0.1)
                : _primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDanger ? Colors.red : _primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDanger ? Colors.red : _textPrimary,
            fontSize: 16,
            letterSpacing: -0.3,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: _textSecondary.withOpacity(0.5),
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primary, _accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              "CareerPath",
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _divider.withOpacity(0),
                  _divider,
                  _divider.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: _surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_primary, _accent],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          backgroundImage: photo.isNotEmpty
                              ? NetworkImage(photo)
                              : const AssetImage('assets/user.png') as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildDrawerItem(
              icon: Icons.fact_check_outlined,
              title: "Application Status",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ViewApplicationStatus()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.verified_outlined,
              title: "Approved Guide",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => approvedguidePage(title: 'Approved Guides')),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.assignment_outlined,
              title: "View Exams",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Viewexam()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.chat_bubble_outline,
              title: "Send Complaint",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => complaint()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.star_outline,
              title: "App Feedback",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => feedback()),
                );
              },
            ),
            // _buildDrawerItem(
            //   icon: Icons.password,
            //   title: "change password",
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(builder: (_) => feedback()),
            //     // );
            //   },
            // ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Divider(height: 1, color: _divider),
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              title: "Logout",
              isDanger: true,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primary, _accent],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "Active Member",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              Row(
                children: [
                  const Text(
                    "Quick Access",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: _success, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "6 Available",
                          style: TextStyle(
                            color: _success,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  _quickCard(
                    Icons.business_outlined,
                    "Companies",
                    "Browse opportunities",
                    [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ViewCompany()),
                      );
                    },
                  ),
                  _quickCard(
                    Icons.work_outline,
                    "Jobs",
                    "Find your match",
                    [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ResumeUpload1Page()),
                      );
                    },
                  ),
                  _quickCard(
                    Icons.menu_book_outlined,
                    "Guides",
                    "Learn & grow",
                    [Color(0xFF10B981), Color(0xFF059669)],
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ViewGuides()),
                      );
                    },
                  ),
                  _quickCard(
                    Icons.lightbulb_outline,
                    "Tips",
                    "Expert advice",
                    [Color(0xFFF59E0B), Color(0xFFD97706)],
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ViewGuidestips()),
                      );
                    },
                  ),
                  _quickCard(
                    Icons.play_circle_outline,
                    "Videos",
                    "Stay motivated",
                    [Color(0xFFEC4899), Color(0xFFDB2777)],
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => motivationvideoPage()),
                      );
                    },
                  ),
                  _quickCard(
                    Icons.description_outlined,
                    "Q&A Papers",
                    "Practice tests",
                    [Color(0xFF06B6D4), Color(0xFF0891B2)],
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => previousqpPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
        height: 72,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, Icons.home_outlined, "Home", 0),
            _buildNavItem(Icons.person, Icons.person_outline, "Profile", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          _onNavTap(0);
        } else {
          Navigator.pop(context);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 24 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
            colors: [_primary, _accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? Colors.white : _textSecondary,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _quickCard(
      IconData icon,
      String title,
      String subtitle,
      List<Color> gradientColors,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradientColors[0].withOpacity(0.1),
                      gradientColors[1].withOpacity(0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}