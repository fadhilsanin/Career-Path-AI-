import 'dart:convert';
import 'package:ai_path/upload_ressume.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ResumeUpload1Page extends StatefulWidget {
  const ResumeUpload1Page({Key? key}) : super(key: key);

  @override
  State<ResumeUpload1Page> createState() => _ResumeUploadPage1State();
}

class _ResumeUploadPage1State extends State<ResumeUpload1Page> {
  PlatformFile? _selectedFile;
  bool _uploading = false;

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  Future<void> _uploadResume() async {
    if (_selectedFile == null) return;

    setState(() => _uploading = true);

    final prefs = await SharedPreferences.getInstance();
    final serverIp = prefs.getString('url').toString();

    if (serverIp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server IP not found in SharedPreferences')),
      );
      setState(() => _uploading = false);
      return;
    }

    final url = Uri.parse(serverIp + 'flut_upload_resume/');
    final request = http.MultipartRequest("POST", url);

    request.files.add(
      http.MultipartFile.fromBytes(
        'resume',
        _selectedFile!.bytes!,
        filename: _selectedFile!.name,
      ),
    );

    request.fields["fileName"] = _selectedFile!.name;

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final jsonData = jsonDecode(body);
      final List results = jsonData['data'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResumeResultPage(results: results),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed (${response.statusCode})')),
      );
    }

    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          'Upload Resume',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Header Section
              const Text(
                'Analyze Your Resume',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your resume to match with relevant categories',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Upload Area
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _uploading ? null : _pickResume,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedFile != null
                              ? Colors.green.shade300
                              : Colors.blue.shade200,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _selectedFile != null
                                  ? Colors.green.shade50
                                  : Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _selectedFile != null
                                  ? Icons.check_circle_outline
                                  : Icons.upload_file_rounded,
                              size: 64,
                              color: _selectedFile != null
                                  ? Colors.green.shade600
                                  : Colors.blue.shade600,
                            ),
                          ),

                          const SizedBox(height: 24),

                          if (_selectedFile != null) ...[
                            Text(
                              _selectedFile!.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: _uploading ? null : _pickResume,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Choose Different File'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue.shade700,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Drop your resume here',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'or click to browse',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'PDF files only',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Upload Button
              ElevatedButton(
                onPressed: (_uploading || _selectedFile == null) ? null : _uploadResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: _uploading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Analyze Resume',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////
// RESULTS PAGE
////////////////////////////////////////////////////////////////////////////

class ResumeResultPage extends StatelessWidget {
  final List results;

  const ResumeResultPage({Key? key, required this.results}) : super(key: key);

  Color _getColor(double value) {
    if (value >= 0.04) return Colors.green.shade600;
    if (value >= 0.02) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color _getBackgroundColor(double value) {
    if (value >= 0.04) return Colors.green.shade50;
    if (value >= 0.02) return Colors.orange.shade50;
    return Colors.red.shade50;
  }

  String _getMatchLabel(double value) {
    if (value >= 0.04) return 'High Match';
    if (value >= 0.02) return 'Medium Match';
    return 'Low Match';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          "Match Results",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category Matches',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${results.length} categories analyzed',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                final score = double.tryParse(item["sim"]) ?? 0.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item["cat"].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getBackgroundColor(score),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getMatchLabel(score),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getColor(score),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Similarity Score',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${(score * 100).toStringAsFixed(2)}%",
                              style: TextStyle(
                                fontSize: 18,
                                color: _getColor(score),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: score),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: value,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _getColor(score),
                                          _getColor(score).withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getColor(score).withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}