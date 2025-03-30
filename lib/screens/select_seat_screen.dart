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
          title: Text('Seat Selection'),
          backgroundColor: Colors.blue[800],
          elevation: 0,
        ),
        body: Center(
          child: Text("Admins cannot select seats",
              style: TextStyle(fontSize: 18, color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Seat',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchSeats,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.blue[800]),
                  title: Text("Available Seats",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800])),
                  subtitle:
                      Text("Tap on an available seat to check in or check out"),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Loading seats...",
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : seats.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_seat,
                                  size: 60, color: Colors.grey[400]),
                              SizedBox(height: 16),
                              Text("No seats available",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[600])),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: fetchSeats,
                                child: Text("Refresh"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: seats.length,
                          itemBuilder: (context, index) {
                            final seat = seats[index];
                            final isCheckedInByUser =
                                seat['checked_in_by_user'] == true;
                            final isAvailable = seat['status'] == 'available';

                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isAvailable
                                        ? Colors.blue[50]
                                        : Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.event_seat,
                                      color: isAvailable
                                          ? Colors.blue[800]
                                          : Colors.grey),
                                ),
                                title: Text("Seat No: ${seat['seat_number']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    isCheckedInByUser
                                        ? "Your current seat"
                                        : isAvailable
                                            ? "Available"
                                            : "Occupied",
                                    style: TextStyle(
                                        color: isCheckedInByUser
                                            ? Colors.blue[800]
                                            : isAvailable
                                                ? Colors.green
                                                : Colors.red)),
                                trailing: isCheckedInByUser
                                    ? ElevatedButton(
                                        onPressed: isCheckingOut
                                            ? null
                                            : () async {
                                                setState(
                                                    () => isCheckingOut = true);
                                                final result =
                                                    await AttendanceService
                                                        .checkOut();
                                                setState(() =>
                                                    isCheckingOut = false);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(result['message']),
                                                    backgroundColor:
                                                        result['success']
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                );
                                                if (result['success'])
                                                  fetchSeats();
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[600],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: isCheckingOut
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2))
                                            : Text("Check Out",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255))),
                                      )
                                    : ElevatedButton(
                                        onPressed: isAvailable && !isCheckingIn
                                            ? () async {
                                                setState(
                                                    () => isCheckingIn = true);
                                                final result =
                                                    await AttendanceService
                                                        .checkIn(seat['id']);
                                                setState(
                                                    () => isCheckingIn = false);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(result['message']),
                                                    backgroundColor:
                                                        result['success']
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                );
                                                if (result['success'])
                                                  fetchSeats();
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isAvailable
                                              ? Colors.blue[800]
                                              : Colors.grey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: isCheckingIn
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2))
                                            : Text("Check In",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: const Color.fromARGB(
                                                        255, 253, 253, 253))),
                                      ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
