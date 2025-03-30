import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

class StudentScreen extends StatefulWidget {
  final String token; // Pass the API token

  StudentScreen({required this.token});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  StudentModel? student;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStudent();
  }

  Future<void> fetchStudent() async {
    try {
      StudentService studentService = StudentService();
      StudentModel data =
          await studentService.fetchStudentDetails(widget.token);

      setState(() {
        student = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Library Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child:
                      Text(errorMessage!, style: TextStyle(color: Colors.red)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${student?.name ?? 'User'}",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      if (student?.profilePhoto != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(student!.profilePhoto!),
                          radius: 40,
                        ),
                      SizedBox(height: 10),
                      Text("Date of Birth: ${student?.dob ?? 'N/A'}"),
                      Text("Gender: ${student?.gender ?? 'N/A'}"),
                      Text("Study For: ${student?.studyFor ?? 'N/A'}"),
                      Text("Membership: ${student?.membershipPlan ?? 'N/A'}"),
                      Text("Expiring: ${student?.expiringDate ?? 'N/A'}"),
                      if (student?.seat != null)
                        Text("Seat Number: ${student!.seat!.number}"),
                      SizedBox(height: 10),

                      // Payments
                      Text(
                        "Payments",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...student!.payments.map((payment) {
                        return ListTile(
                          leading: Icon(Icons.payment),
                          title: Text("Amount: ₹${payment.amount}"),
                          subtitle: Text("Status: ${payment.status}"),
                          trailing: Text(payment.date),
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}
