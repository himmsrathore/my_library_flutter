import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylibrary/models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendanceSummaryScreen extends StatefulWidget {
  final String role;

  const AttendanceSummaryScreen({required this.role, super.key});

  @override
  _AttendanceSummaryScreenState createState() =>
      _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  List<AttendanceModel> _attendanceRecords = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<AttendanceModel> records = await AttendanceService.getAttendance();
      setState(() {
        _attendanceRecords = records;
        _errorMessage = records.isEmpty ? "No attendance records found." : '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading attendance records.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildAttendanceCard(AttendanceModel attendance) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.event_available, color: Colors.white),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date: ${attendance.dateAttended}",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Check-In: ${attendance.checkIn}",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  Text(
                    "Check-Out: ${attendance.checkOut ?? 'Not Checked Out'}",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: attendance.checkOut == null
                            ? Colors.red
                            : Colors.green),
                  ),
                  Text(
                    "Seat: ${attendance.seatId}",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.teal),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)));
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text(_errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchAttendance,
              child: Text("Retry"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAttendance,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: _attendanceRecords.length,
        itemBuilder: (context, index) {
          return _buildAttendanceCard(_attendanceRecords[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Summary",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.teal[600],
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _fetchAttendance)
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.teal.shade50, Colors.white]),
        ),
        child: _buildBody(),
      ),
    );
  }
}
