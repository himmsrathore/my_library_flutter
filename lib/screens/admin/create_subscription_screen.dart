import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mylibrary/services/library_admin_service.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // For date formatting

class CreateSubscriptionScreen extends StatefulWidget {
  @override
  _CreateSubscriptionScreenState createState() =>
      _CreateSubscriptionScreenState();
}

class _CreateSubscriptionScreenState extends State<CreateSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _subscriptionPeriod;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  File? _paymentSlip;
  bool isLoading = false;
  String? errorMessage;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _subscriptionPeriods = [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year'
  ];

  Future<void> _pickPaymentSlip() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _paymentSlip = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        // Auto-calculate end date based on subscription period
        _calculateEndDate();
      });
    }
  }

  Future<void> _pickEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _calculateEndDate() {
    if (_startDate == null || _subscriptionPeriod == null) return;

    DateTime endDate;
    switch (_subscriptionPeriod) {
      case '1 Month':
        endDate = _startDate!.add(Duration(days: 30));
        break;
      case '3 Months':
        endDate = _startDate!.add(Duration(days: 90));
        break;
      case '6 Months':
        endDate = _startDate!.add(Duration(days: 180));
        break;
      case '1 Year':
        endDate = _startDate!.add(Duration(days: 365));
        break;
      default:
        return;
    }

    setState(() {
      _endDate = endDate;
      _endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
    });
  }

  Future<void> _submitSubscription() async {
    if (!_formKey.currentState!.validate()) return;
    if (_paymentSlip == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload a payment slip")),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select start and end dates")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      LibraryAdminService libraryService = LibraryAdminService();
      final response = await libraryService.createSubscription(
        subscriptionPeriod: _subscriptionPeriod!,
        amount: double.parse(_amountController.text),
        paymentSlip: _paymentSlip!,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
      );

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response['message'] ??
                "Subscription request submitted. Awaiting approval.")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Subscription",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue[800]))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subscription Period Dropdown
                    Text(
                      "Subscription Period",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _subscriptionPeriod,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      hint: Text("Select Period", style: GoogleFonts.poppins()),
                      items: _subscriptionPeriods.map((period) {
                        return DropdownMenuItem<String>(
                          value: period,
                          child: Text(period, style: GoogleFonts.poppins()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _subscriptionPeriod = value;
                          _calculateEndDate(); // Recalculate end date when period changes
                        });
                      },
                      validator: (value) => value == null
                          ? "Please select a subscription period"
                          : null,
                    ),
                    SizedBox(height: 16),
                    // Amount Field
                    Text(
                      "Amount",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Enter amount",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an amount";
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return "Please enter a valid amount greater than 0";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Start Date Field
                    Text(
                      "Start Date",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Select start date",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ),
                      onTap: _pickStartDate,
                      validator: (value) =>
                          value!.isEmpty ? "Please select a start date" : null,
                    ),
                    SizedBox(height: 16),
                    // End Date Field
                    Text(
                      "End Date",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Select end date",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ),
                      onTap: _pickEndDate,
                      validator: (value) =>
                          value!.isEmpty ? "Please select an end date" : null,
                    ),
                    SizedBox(height: 16),
                    // Payment Slip Upload
                    Text(
                      "Payment Slip",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickPaymentSlip,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: Center(
                          child: _paymentSlip == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file,
                                        color: Colors.grey[600], size: 40),
                                    SizedBox(height: 8),
                                    Text(
                                      "Upload Payment Slip\n(JPEG, PNG, JPG, PDF)",
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : Image.file(
                                  _paymentSlip!,
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: double.infinity,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitSubscription,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Submit Subscription",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (errorMessage != null) ...[
                      SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.red[800]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
