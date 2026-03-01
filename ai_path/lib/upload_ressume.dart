import 'dart:convert';

import 'package:ai_path/view_vaccancy.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ResumeUploadPage extends StatefulWidget {
  const ResumeUploadPage({Key? key}) : super(key: key);

  @override
  State<ResumeUploadPage> createState() => _ResumeUploadPageState();
}

class _ResumeUploadPageState extends State<ResumeUploadPage> {
  PlatformFile? _selectedFile;
  bool _uploading = false;

  Future<void> _pickResume() async {
    print("jjjjjjjjj");
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true, // IMPORTANT
    );


    if (result != null) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  Future<void> _uploadResume() async {

    if (_selectedFile == null) return;

    setState(() => _uploading = true);

    // try {
      // 1. Get server IP from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final serverIp = prefs.getString('url').toString();
      final vid = prefs.getString('vid').toString();
      final lid = prefs.getString('lid').toString();

      if (serverIp == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server IP not found in SharedPreferences')),
        );
        setState(() => _uploading = false);
        return;
      }

      final url = Uri.parse(serverIp +'flut_send_application/');

      // 2. Create multipart request
      final request = http.MultipartRequest("POST", url);

      request.files.add(
        http.MultipartFile.fromBytes(
          'fileName',                               // field name
          _selectedFile!.bytes!,
          filename: _selectedFile!.name,
        ),
      );

      // Optional fields
      request.fields["vid"] = vid;
      request.fields["lid"] = lid;

      // 3. Send request
      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final json = jsonDecode(body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploaded successfully')),

        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>viewvacancy(title: '',)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed (${response.statusCode})')),
        );
      }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error: $e')),
    //   );
    // }

    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Resume')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            OutlinedButton(
              onPressed: _pickResume,
              child: const Text('Choose Resume'),
            ),
            const SizedBox(height: 10),
            if (_selectedFile != null) Text("Selected: ${_selectedFile!.name}"),
            const Spacer(),
            ElevatedButton(
              onPressed: _uploading ? null : _uploadResume,
              child: _uploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload Resume'),
            ),
          ],
        ),
      ),
    );
  }
}
