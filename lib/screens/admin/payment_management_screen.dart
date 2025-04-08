import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylibrary/services/library_admin_service.dart';

class PaymentManagementScreen extends StatefulWidget {
  @override
  _PaymentManagementScreenState createState() =>
      _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {
  List<dynamic>? payments;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    try {
      LibraryAdminService libraryService = LibraryAdminService();
      final paymentData = await libraryService.fetchPayments();
      setState(() {
        payments = paymentData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _updatePaymentStatus(int paymentId, String status) async {
    try {
      LibraryAdminService libraryService = LibraryAdminService();
      await libraryService.updatePaymentStatus(paymentId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment $status successfully")),
      );
      _fetchPayments(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update payment status: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              : payments == null || payments!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment,
                              color: Colors.grey[600], size: 40),
                          SizedBox(height: 16),
                          Text(
                            "No payments found",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchPayments,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: payments!.length,
                        itemBuilder: (context, index) {
                          final payment = payments![index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Student: ${payment['student']['name'] ?? 'N/A'}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                      Text(
                                        payment['status'] ?? 'N/A',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: payment['status'] == 'approved'
                                              ? Colors.green
                                              : payment['status'] == 'rejected'
                                                  ? Colors.red
                                                  : Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      color: Colors.grey[300], thickness: 1),
                                  SizedBox(height: 8),
                                  _buildPaymentInfo("Amount",
                                      payment['amount']?.toString() ?? 'N/A'),
                                  _buildPaymentInfo("Payment Method",
                                      payment['payment_method'] ?? 'N/A'),
                                  _buildPaymentInfo("Payment Date",
                                      payment['payment_date'] ?? 'N/A'),
                                  _buildPaymentInfo("Next Due Date",
                                      payment['next_due_date'] ?? 'N/A'),
                                  _buildPaymentInfo(
                                      "Plan",
                                      payment['membership_plan']?['name'] ??
                                          'N/A'),
                                  if (payment['payment_slip'] != null) ...[
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        // Optionally, open the payment slip in a viewer
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Opening payment slip...")),
                                        );
                                      },
                                      child: Text(
                                        "View Payment Slip",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.blue[800],
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (payment['status'] == 'pending') ...[
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => _updatePaymentStatus(
                                              payment['id'], 'approved'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "Approve",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () => _updatePaymentStatus(
                                              payment['id'], 'rejected'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "Reject",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _buildPaymentInfo(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            value ?? 'N/A', // Fallback to 'N/A' if value is null
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
