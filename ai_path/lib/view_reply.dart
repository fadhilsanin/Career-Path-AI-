// import 'dart:convert';
// import 'package:ai_path/upload_ressume.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class ResumeUpload1Page extends StatefulWidget {
//   const ResumeUpload1Page({Key? key}) : super(key: key);
//
//   @override
//   State<ResumeUpload1Page> createState() => _ResumeUploadPage1State();
// }
//
// class _ResumeUploadPage1State extends State<ResumeUpload1Page> {
//   PlatformFile? _selectedFile;
//   bool _uploading = false;
//
//   Future<void> _pickResume() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//       withData: true,
//     );
//
//     if (result != null) {
//       setState(() => _selectedFile = result.files.first);
//     }
//   }
//
//   Future<void> _uploadResume() async {
//     if (_selectedFile == null) return;
//
//     setState(() => _uploading = true);
//
//     final prefs = await SharedPreferences.getInstance();
//     final serverIp = prefs.getString('url') ?? "";
//
//     if (serverIp.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Server IP not found')),
//       );
//       setState(() => _uploading = false);
//       return;
//     }
//
//     final url = Uri.parse("$serverIp/flut_upload_resume/");
//     final request = http.MultipartRequest("POST", url);
//
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'resume',
//         _selectedFile!.bytes!,
//         filename: _selectedFile!.name,
//       ),
//     );
//
//     request.fields["fileName"] = _selectedFile!.name;
//
//     final response = await request.send();
//
//     if (response.statusCode == 200) {
//       final body = await response.stream.bytesToString();
//       final jsonData = jsonDecode(body);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               ResumeResultPage(results: jsonData['data']),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload failed (${response.statusCode})')),
//       );
//     }
//
//     setState(() => _uploading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 2,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Upload Resume',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//
//             // Upload Box
//             GestureDetector(
//               onTap: _pickResume,
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(
//                     color: Colors.blueAccent.withOpacity(0.4),
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     const Icon(
//                       Icons.upload_file,
//                       color: Colors.blueAccent,
//                       size: 50,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       _selectedFile == null
//                           ? "Tap to upload PDF resume"
//                           : _selectedFile!.name,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Only PDF files are allowed",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const Spacer(),
//
//             // Upload Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _uploading ? null : _uploadResume,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _uploading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                   "Upload Resume",
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
