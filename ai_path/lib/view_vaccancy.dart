import 'dart:convert';
import 'package:ai_path/upload_ressume.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewCompany extends StatelessWidget {
  const ViewCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Company',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const viewvacancy(title: 'View Companies'),
    );
  }
}

class viewvacancy extends StatefulWidget {
  final String title;

  const viewvacancy({super.key, required this.title});

  @override
  State<viewvacancy> createState() => _viewvacancyState();
}

class _viewvacancyState extends State<viewvacancy> {

  _viewvacancyState() {
    viewCompany();
  }

  List<String> cid_ = [];
  List<String> vaccancy_ = [];
  List<String> details_ = [];
  List<String> salary_ = [];
  List<String> experience_ = [];
  List<String> qualification_ = [];
  List<String> requirement_ = [];
  List<String> date_ = [];
  List<String> no_of_vaccancy_ = [];
  // ----------------------------------------------------------------------
  // FETCH COMPANIES
  // ----------------------------------------------------------------------
  Future<void> viewCompany() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();
      String img = pref.getString("img").toString();

      String url = ip + "flut_view_vaccancies/";
      var response = await http.post(Uri.parse(url),body: {
        "cid":pref.getString("cid").toString(),
      });
      var jsondata = json.decode(response.body);

      var arr = jsondata["data"];

      List<String> cid = [];
      List<String> vaccancy = [];
      List<String> details = [];
      List<String> salary = [];
      List<String> experience = [];
      List<String> qualification = [];
      List<String> requirement = [];
      List<String> date = [];
      List<String> no_of_vaccancy = [];

      for (var item in arr) {
        cid.add((item['id'] ?? "").toString());
        vaccancy.add((item['vaccancy'] ?? "").toString());
        details.add((item['details'] ?? "").toString());
        salary.add((item['salary'] ?? "").toString());
        experience.add((item['experience'] ?? "").toString());
        qualification.add((item['qualification'] ?? "").toString());
        requirement.add((item['requirement'] ?? "").toString());
        date.add((item['date'] ?? "").toString());
        no_of_vaccancy.add((item['no_of_vaccancy'] ?? "").toString());

      }

      setState(() {
        cid_ = cid;
        vaccancy_ = vaccancy;
        details_ = details;
        salary_ = salary;
        experience_ = experience;
        qualification_ = qualification;
        requirement_ = requirement;
        date_ = date;
        no_of_vaccancy_ = no_of_vaccancy;

      });

    } catch (e) {
      print("Error loading companies: $e");
    }
  }


  // ----------------------------------------------------------------------
  // UI
  // ----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View All Companies", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: vaccancy_.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: vaccancy_.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Center(
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: Image.network(
                  //       photo_[index],
                  //       height: 180,
                  //       width: double.infinity,
                  //       fit: BoxFit.cover,
                  //       errorBuilder: (c, e, s) =>
                  //           Icon(Icons.broken_image, size: 100, color: Colors.red),
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 15),

                  Text("Vaccancy: ${vaccancy_[index]}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Details: ${details_[index]}"),
                  Text("Salary: ${salary_[index]}"),
                  Text("Experience: ${experience_[index]}"),
                  Text("Qualification: ${qualification_[index]}"),
                  Text("Requirement: ${requirement_[index]}"),
                  Text("Date: ${date_[index]}"),
                  Text("No Of Vaccancy: ${no_of_vaccancy_[index]}"),


                  SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('vid', cid_[index].toString());

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ResumeUploadPage()),
                        );
                      },
                      child: Text('send request'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


