import 'dart:convert';
import 'package:ai_path/view_vaccancy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewCompany extends StatelessWidget {
  const ViewCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Company',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const ViewCompanyPage(title: 'View Companies'),
    );
  }
}

class ViewCompanyPage extends StatefulWidget {
  final String title;

  const ViewCompanyPage({super.key, required this.title});

  @override
  State<ViewCompanyPage> createState() => _ViewCompanyPageState();
}

class _ViewCompanyPageState extends State<ViewCompanyPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  List<String> cid_ = [];
  List<String> name_ = [];
  List<String> email_ = [];
  List<String> phone_ = [];
  List<String> since_ = [];
  List<String> place_ = [];
  List<String> pincode_ = [];
  List<String> district_ = [];
  List<String> latitude_ = [];
  List<String> longitude_ = [];
  List<String> photo_ = [];
  List<String> proof_ = [];
  List<String> status_ = [];
  List<String> state_ = [];

  static const Color _primary = Color(0xFFF97316);
  static const Color _accent = Color(0xFFFB923C);
  static const Color _bg = Color(0xFFF8FAFC);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);
  static const Color _surface = Colors.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    viewCompany();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> viewCompany() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();
      String img = pref.getString("img").toString();

      String url = ip + "flut_view_company/";
      var response = await http.post(Uri.parse(url));
      var jsondata = json.decode(response.body);

      var arr = jsondata["data"];

      List<String> cid = [];
      List<String> name = [];
      List<String> email = [];
      List<String> phone = [];
      List<String> since = [];
      List<String> place = [];
      List<String> pincode = [];
      List<String> district = [];
      List<String> latitude = [];
      List<String> longitude = [];
      List<String> photo = [];
      List<String> proof = [];
      List<String> status = [];
      List<String> state = [];

      for (var item in arr) {
        cid.add((item['id'] ?? "").toString());
        name.add((item['name'] ?? "").toString());
        email.add((item['email'] ?? "").toString());
        phone.add((item['phone'] ?? "").toString());
        since.add((item['since'] ?? "").toString());
        place.add((item['place'] ?? "").toString());
        pincode.add((item['pincode'] ?? "").toString());
        district.add((item['district'] ?? "").toString());
        latitude.add((item['latitude'] ?? "").toString());
        longitude.add((item['longitude'] ?? "").toString());
        state.add((item['state'] ?? "").toString());
        status.add((item['status'] ?? "").toString());

        photo.add(
          item['photo'] == null || item['photo'] == ""
              ? ""
              : "${img.endsWith('/') ? img : "$img/"}${item['photo']}",
        );

        proof.add(
          item['proof'] == null || item['proof'] == ""
              ? ""
              : "${img.endsWith('/') ? img : "$img/"}${item['proof']}",
        );
      }

      setState(() {
        cid_ = cid;
        name_ = name;
        email_ = email;
        phone_ = phone;
        since_ = since;
        place_ = place;
        pincode_ = pincode;
        district_ = district;
        latitude_ = latitude;
        longitude_ = longitude;
        photo_ = photo;
        proof_ = proof;
        status_ = status;
        state_ = state;
      });

      _animationController.forward();

    } catch (e) {
      print("Error loading companies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primary, _accent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.business, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              "Companies",
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ),

      body: name_.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primary.withOpacity(0.1), _accent.withOpacity(0.1)],
                ),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primary),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Loading companies...",
              style: TextStyle(
                color: _textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : FadeTransition(
        opacity: _animationController,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: name_.length,
          itemBuilder: (context, index) {
            return _buildCompanyCard(context, index);
          },
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header with Gradient Overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  photo_[index],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primary.withOpacity(0.3), _accent.withOpacity(0.3)],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.business, size: 60, color: Colors.white70),
                    ),
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              // Status Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: status_[index].toLowerCase() == "approved"
                        ? const Color(0xFF10B981)
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (status_[index].toLowerCase() == "approved"
                            ? const Color(0xFF10B981)
                            : Colors.orange).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        status_[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Company Name Overlay
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  name_[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Company Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.calendar_today, "Since", since_[index]),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email_outlined, "Email", email_[index]),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone_outlined, "Phone", phone_[index]),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on_outlined, "Location",
                    "${place_[index]}, ${district_[index]}"),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.map_outlined, "State", "${state_[index]} - ${pincode_[index]}"),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        icon: Icons.star_outline,
                        label: "Feedback",
                        gradient: [const Color(0xFFFBBF24), const Color(0xFFF59E0B)],
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('cid', cid_[index].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewFeedbackPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        icon: Icons.work_outline,
                        label: "Vacancies",
                        gradient: [_primary, _accent],
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('cid', cid_[index].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => viewvacancy(title: ''),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: _primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required List<Color> gradient,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================================
// FEEDBACK PAGE
// =======================================================================

class NewFeedbackPage extends StatefulWidget {
  @override
  _NewFeedbackPageState createState() => _NewFeedbackPageState();
}

class _NewFeedbackPageState extends State<NewFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int rating = 0;
  bool _isSubmitting = false;

  static const Color _primary = Color(0xFFF97316);
  static const Color _accent = Color(0xFFFB923C);
  static const Color _bg = Color(0xFFF8FAFC);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);
  static const Color _surface = Colors.white;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Widget buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isSelected = index < rating;
        return GestureDetector(
          onTap: () {
            setState(() {
              rating = index + 1;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            child: Icon(
              isSelected ? Icons.star : Icons.star_outline,
              color: isSelected ? const Color(0xFFFBBF24) : _textSecondary.withOpacity(0.3),
              size: 40,
            ),
          ),
        );
      }),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Write Feedback",
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE2E8F0)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Rating Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Rate Your Experience",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rating == 0
                        ? "Tap a star to rate"
                        : "$rating star${rating > 1 ? 's' : ''} - ${_getRatingText(rating)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildRatingStars(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Feedback Input Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Feedback",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 6,
                    style: const TextStyle(
                      fontSize: 15,
                      color: _textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: "Share your thoughts about this company...",
                      hintStyle: TextStyle(
                        color: _textSecondary.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: _bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _primary, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            GestureDetector(
              onTap: _isSubmitting ? null : _submitFeedback,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primary, _accent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: _isSubmitting
                    ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Submit Feedback",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(int stars) {
    switch (stars) {
      case 1: return "Poor";
      case 2: return "Fair";
      case 3: return "Good";
      case 4: return "Very Good";
      case 5: return "Excellent";
      default: return "";
    }
  }

  Future<void> _submitFeedback() async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.white),
              SizedBox(width: 8),
              Text("Please give a rating!"),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final sh = await SharedPreferences.getInstance();
      String feedback = _feedbackController.text.trim();
      String url = sh.getString("url").toString();
      String lid = sh.getString("lid").toString();
      String cid = sh.getString("cid").toString();

      var data = await http.post(
        Uri.parse(url + "flut_send_c_review/"),
        body: {
          'review': feedback,
          'lid': lid,
          'cid': cid,
          'rating': rating.toString(),
        },
      );

      var jsondata = json.decode(data.body);

      if (jsondata['status'] == "ok") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text("Feedback submitted successfully!"),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception("Failed to submit feedback");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text("Failed to submit feedback"),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}