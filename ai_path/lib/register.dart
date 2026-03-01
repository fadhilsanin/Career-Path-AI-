import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'login.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  File? _image;
  File? _resume;
  final ImagePicker _picker = ImagePicker();
  bool _obscurePassword = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController distController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController sinceController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController resumeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_add_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Join us today!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Personal Information Section
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 15),

                  _buildTextField(
                    controller: nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    hint: 'Enter your full name',
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  _buildDropdownField(
                    controller: genderController,
                    label: 'Gender',
                    icon: Icons.wc_outlined,
                    items: ['Male', 'Female', 'Other'],
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    hint: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  _buildDateField(),

                  const SizedBox(height: 25),

                  // Address Information Section
                  _buildSectionTitle('Address Details'),
                  const SizedBox(height: 15),

                  _buildTextField(
                    controller: placeController,
                    label: 'Place',
                    icon: Icons.location_on_outlined,
                    hint: 'Enter your place',
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: pinController,
                    label: 'Pincode',
                    icon: Icons.pin_outlined,
                    hint: 'Enter pincode',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: distController,
                    label: 'District',
                    icon: Icons.map_outlined,
                    hint: 'Enter your district',
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: stateController,
                    label: 'State',
                    icon: Icons.location_city_outlined,
                    hint: 'Enter your state',
                  ),

                  const SizedBox(height: 25),

                  // Professional Information Section
                  _buildSectionTitle('Professional Details'),
                  const SizedBox(height: 15),

                  _buildTextField(
                    controller: sinceController,
                    label: 'Working Since',
                    icon: Icons.work_outline,
                    hint: 'e.g., 2020',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 25),

                  // Document Upload Section
                  _buildSectionTitle('Upload Documents'),
                  const SizedBox(height: 15),

                  // Photo Upload
                  _buildUploadCard(
                    title: 'Profile Photo',
                    icon: Icons.photo_camera_outlined,
                    file: _image,
                    onTap: () => _pickImage(ImageSource.gallery),
                    isImage: true,
                  ),

                  const SizedBox(height: 16),

                  // Resume Upload
                  _buildUploadCard(
                    title: 'Resume (PDF)',
                    icon: Icons.description_outlined,
                    file: _resume,
                    onTap: _pickResume,
                    isImage: false,
                  ),

                  const SizedBox(height: 25),

                  // Account Information Section
                  _buildSectionTitle('Account Credentials'),
                  const SizedBox(height: 15),

                  _buildTextField(
                    controller: usernameController,
                    label: 'Username',
                    icon: Icons.account_circle_outlined,
                    hint: 'Choose a username',
                  ),

                  const SizedBox(height: 16),

                  _buildPasswordField(),

                  const SizedBox(height: 30),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: sendData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // Standard Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Dropdown Field
  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            controller.text = newValue ?? '';
          });
        },
      ),
    );
  }

  // Date Field
  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: dobController,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          hintText: 'Select your date of birth',
          prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.blue[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.blue[700]!,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.year.toString().padLeft(4, '0')}-"
                "${pickedDate.month.toString().padLeft(2, '0')}-"
                "${pickedDate.day.toString().padLeft(2, '0')}";

            setState(() {
              dobController.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  // Password Field
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter a strong password',
          prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[700]),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Upload Card Widget
  Widget _buildUploadCard({
    required String title,
    required IconData icon,
    required File? file,
    required VoidCallback onTap,
    required bool isImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue[700]),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (file == null)
            Center(
              child: Column(
                children: [
                  Icon(
                    isImage ? Icons.add_photo_alternate_outlined : Icons.upload_file_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isImage ? 'No photo selected' : 'No file selected',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      file.path.split('/').last,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(isImage ? Icons.photo_library : Icons.file_upload),
              label: Text(file == null ? 'Select File' : 'Change File'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue[700],
                side: BorderSide(color: Colors.blue[700]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendData() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String place = placeController.text.trim();
    String pin = pinController.text.trim();
    String gender = genderController.text.trim();
    String since = sinceController.text.trim();
    String photo = photoController.text.trim();
    String resume = resumeController.text.trim();
    String dob = dobController.text.trim();
    String state = stateController.text.trim();
    String dist = distController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();

    if (name.isEmpty || password.isEmpty || place.isEmpty || username.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill out all required fields',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_image == null) {
      Fluttertoast.showToast(
        msg: 'Please upload your photo',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    if (_resume == null) {
      Fluttertoast.showToast(
        msg: 'Please upload your resume',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    final api = Uri.parse('${url}flut_UserRegistration/');

    try {
      final request = await http.MultipartRequest('POST', api);

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['pin'] = pin;
      request.fields['photo'] = photo;
      request.fields['since'] = since;
      request.fields['dob'] = dob;
      request.fields['gender'] = gender;
      request.fields['state'] = state;
      request.fields['resume'] = resume;
      request.fields['district'] = dist;
      request.fields['place'] = place;
      request.fields['username'] = username;
      request.fields['password'] = password;

      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _image!.path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'resume',
        _resume!.path,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: 'Account created successfully!',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Registration failed. Please try again.',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Server error. Please try again later.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _resume = File(result.files.single.path!);
      });
    }
  }
}