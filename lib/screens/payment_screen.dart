// payment_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/payment_service.dart';
import '../models/payment_model.dart';

class PaymentScreen extends StatefulWidget {
  final String role;

  const PaymentScreen({required this.role, super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  List<PaymentModel> _payments = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Credit Card';

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchPayments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Clear previous error
    });
    try {
      List<PaymentModel> payments = await _paymentService.fetchPayments();
      setState(() {
        _payments = payments;
        _isLoading = false;
        _errorMessage = '';
        print("DEBUG: Payments loaded: $_payments");
      });
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = "Session expired. Please log in again.";
        Future.delayed(Duration(seconds: 2), () {
          // Navigate to login screen
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        errorMessage = "Unable to load payments. Please try again.";
      }
      setState(() {
        _errorMessage = errorMessage;
        _isLoading = false;
        _payments = []; // Clear payments on error
        print("DEBUG: Error in fetchPayments: $e");
      });
    }
  }

  void _showPaymentDialog() {
    _amountController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Make Payment',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                  prefixIcon: Icon(Icons.credit_card, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ['Credit Card', 'PayPal', 'Bank Transfer']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () async {
              double? amount = double.tryParse(_amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please enter a valid amount"),
                    backgroundColor: Colors.red[400],
                  ),
                );
                return;
              }

              Navigator.pop(context);

              _processPayment(amount, _selectedPaymentMethod);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(double amount, String method) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text("Processing payment..."),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );

    try {
      bool success = await _paymentService.makePayment(
        amount: amount,
        paymentMethod: method,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Payment successful!"),
            backgroundColor: Colors.green,
          ),
        );
        _fetchPayments();
      } else {
        throw Exception("Payment failed.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
    }
  }

  Widget _buildStatusChip(PaymentStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case PaymentStatus.pending:
        color = Colors.orange;
        icon = Icons.hourglass_top;
        break;
      case PaymentStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case PaymentStatus.failed:
        color = Colors.red;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            status.displayName,
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(PaymentModel payment) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt,
                    color: Colors.blue[700],
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${payment.amount.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Payment Date: ${payment.date}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(payment.status),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey[300]),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Method: ${payment.paymentMethod}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Next Due: ${payment.nextDueDate ?? 'N/A'}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: payment.verify == 'approved'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: payment.verify == 'approved'
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    payment.verify.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: payment.verify == 'approved'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role.contains('admin')) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Payments",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blue[600],
        ),
        body: Center(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.all(24),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 48,
                    color: Colors.blue[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Administrator Access",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Payment options are not available for admin users",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payments",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchPayments,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading payment history...",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              )
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Oops! Something went wrong",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            _errorMessage,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _errorMessage.contains('log in')
                                ? () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  }
                                : _fetchPayments,
                            icon: Icon(_errorMessage.contains('log in')
                                ? Icons.login
                                : Icons.refresh),
                            label: Text(
                              _errorMessage.contains('log in')
                                  ? 'Log In'
                                  : 'Retry',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    key: _refreshKey,
                    onRefresh: _fetchPayments,
                    color: Colors.blue[600],
                    child: Column(
                      children: [
                        Expanded(
                          child: _payments.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.receipt_long,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "No payment history yet",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Make your first payment to see it here",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        onPressed: _showPaymentDialog,
                                        icon: Icon(Icons.add),
                                        label: Text("Make First Payment"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(16),
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: _payments.length,
                                  itemBuilder: (context, index) {
                                    final payment = _payments[index];
                                    return _buildPaymentCard(payment);
                                  },
                                ),
                        ),
                        if (_payments.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, -3),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _showPaymentDialog,
                              icon: Icon(Icons.add),
                              label: Text(
                                "Make New Payment",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 56),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: _payments.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _showPaymentDialog,
              backgroundColor: Colors.blue,
              child: Icon(Icons.payment, color: Colors.white),
            ),
    );
  }
}
