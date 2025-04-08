import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylibrary/services/library_admin_service.dart';

class SeatManagementScreen extends StatefulWidget {
  @override
  _SeatManagementScreenState createState() => _SeatManagementScreenState();
}

class _SeatManagementScreenState extends State<SeatManagementScreen> {
  List<dynamic>? seats;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSeats();
  }

  Future<void> _fetchSeats() async {
    try {
      LibraryAdminService libraryService = LibraryAdminService();
      final seatData = await libraryService.fetchSeats();
      setState(() {
        seats = seatData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _addSeat() async {
    final TextEditingController seatNumberController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Seat",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: seatNumberController,
          decoration: InputDecoration(
            labelText: "Seat Number",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (seatNumberController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a seat number")),
                );
                return;
              }
              try {
                LibraryAdminService libraryService = LibraryAdminService();
                await libraryService.createSeat(seatNumberController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Seat added successfully")),
                );
                _fetchSeats(); // Refresh the list
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to add seat: $e")),
                );
              }
            },
            child: Text("Add",
                style: GoogleFonts.poppins(color: Colors.blue[800])),
          ),
        ],
      ),
    );
  }

  Future<void> _editSeat(dynamic seat) async {
    final TextEditingController seatNumberController =
        TextEditingController(text: seat['seat_number']);
    bool isOccupied = seat['is_occupied'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Seat",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: seatNumberController,
              decoration: InputDecoration(
                labelText: "Seat Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Occupied: ", style: GoogleFonts.poppins()),
                Switch(
                  value: isOccupied,
                  onChanged: (value) {
                    setState(() {
                      isOccupied = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (seatNumberController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a seat number")),
                );
                return;
              }
              try {
                LibraryAdminService libraryService = LibraryAdminService();
                await libraryService.updateSeat(
                    seat['id'], seatNumberController.text, isOccupied);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Seat updated successfully")),
                );
                _fetchSeats(); // Refresh the list
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update seat: $e")),
                );
              }
            },
            child: Text("Update",
                style: GoogleFonts.poppins(color: Colors.blue[800])),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSeat(int seatId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Seat",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete this seat?",
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              try {
                LibraryAdminService libraryService = LibraryAdminService();
                await libraryService.deleteSeat(seatId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Seat deleted successfully")),
                );
                _fetchSeats(); // Refresh the list
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to delete seat: $e")),
                );
              }
            },
            child:
                Text("Delete", style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Removed the AppBar
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue[800]))
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red[800], size: 40),
                      SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.red[800]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : seats == null || seats!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_seat_outlined,
                              color: Colors.grey[600], size: 40),
                          SizedBox(height: 16),
                          Text(
                            "No seats found",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _addSeat,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Add a Seat",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchSeats,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: seats!.length,
                        itemBuilder: (context, index) {
                          final seat = seats![index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        seat['is_occupied']
                                            ? Icons.event_seat
                                            : Icons.event_seat_outlined,
                                        color: seat['is_occupied']
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Seat ${seat['seat_number']}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          Text(
                                            seat['is_occupied']
                                                ? "Occupied"
                                                : "Available",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: seat['is_occupied']
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue[800]),
                                        onPressed: () => _editSeat(seat),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _deleteSeat(seat['id']),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSeat,
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.add, color: Colors.white, size: 28),
        tooltip: 'Add Seat',
      ),
    );
  }
}
