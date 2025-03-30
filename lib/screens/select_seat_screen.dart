import 'package:flutter/material.dart';
import 'package:mylibrary/services/attendance_service.dart';

class SelectSeatScreen extends StatefulWidget {
  final String role;

  SelectSeatScreen({required this.role});

  @override
  _SelectSeatScreenState createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  List<dynamic> seats = [];
  bool isLoading = false;
  bool isCheckingIn = false;
  bool isCheckingOut = false;

  void fetchSeats() async {
    setState(() => isLoading = true);
    seats = await AttendanceService.getAllSeats();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchSeats();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == "super_admin" || widget.role == "admin") {
      return Scaffold(
        appBar: AppBar(
          title: Text("Select Seat"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Text(
            "Admins cannot select seats",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Seat"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Refresh Seats",
            onPressed: fetchSeats,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : seats.isEmpty
                ? Center(
                    child: Text(
                      "No seats found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: seats.length,
                    itemBuilder: (context, index) {
                      final seat = seats[index];
                      final isCheckedInByUser =
                          seat['checked_in_by_user'] == true;
                      final isAvailable = seat['status'] == 'available';

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.event_seat,
                            color: isAvailable ? Colors.blue : Colors.grey,
                          ),
                          title: Text(
                            "Seat No: ${seat['seat_number']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Status: ${seat['status']}",
                            style: TextStyle(
                              color: isAvailable ? Colors.green : Colors.red,
                            ),
                          ),
                          trailing: isCheckedInByUser
                              ? ElevatedButton(
                                  onPressed: isCheckingOut
                                      ? null
                                      : () async {
                                          setState(() => isCheckingOut = true);
                                          final result = await AttendanceService
                                              .checkOut();
                                          setState(() => isCheckingOut = false);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(result['message']),
                                              backgroundColor: result['success']
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          );
                                          if (result['success']) fetchSeats();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: isCheckingOut
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2),
                                        )
                                      : Text("Check Out"),
                                )
                              : ElevatedButton(
                                  onPressed: isAvailable && !isCheckingIn
                                      ? () async {
                                          setState(() => isCheckingIn = true);
                                          final result =
                                              await AttendanceService.checkIn(
                                                  seat['id']);
                                          setState(() => isCheckingIn = false);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(result['message']),
                                              backgroundColor: result['success']
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          );
                                          if (result['success']) fetchSeats();
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isAvailable ? Colors.blue : Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: isCheckingIn
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2),
                                        )
                                      : Text("Check In"),
                                ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
