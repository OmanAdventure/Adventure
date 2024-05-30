import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/CustomerScreensUI/ManageMyAdventuresUI.dart';
import 'package:untitled/components/CustomAlertUI.dart';
import 'package:untitled/components/buttonsUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ManageBookingScreen(),
    );
  }
}

class ManageBookingScreen extends StatefulWidget {
  const ManageBookingScreen({super.key});

  @override
  _ManageBookingScreenState createState() => _ManageBookingScreenState();
}

class _ManageBookingScreenState extends State<ManageBookingScreen> {
  final String serviceProviderName = "Service Provider Name";
  final String bookingDate = "June 22, 2024";
  final String eventDate = "Friday, December 22, 2024";
  final String eventTime = "03:00 PM - 06:00 PM";
  final String location = "Adventure Box Store";
  final String gender = "Only Females";
  final String activity = "Hiking";
  final String difficulty = "Difficulty Level";
  final double adventurePrice = 15.0;
  final int numberOfTickets = 4;
  final double tax = 0.0;
  final double refundAmount = 60.0;


  void _showCancellationConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_rounded, size: 80, color: Colors.yellow[800]),
              const SizedBox(height: 10),
              Text(
                "Confirmation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "This can not be undone, are you sure about canceling this adventure?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:  [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text('No', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 30,),
                  TextButton(
                    onPressed: () {

                        Navigator.of(context).pop(); // Close the dialog
                        _showCancellationSuccessDialog();

                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text('Yes', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),

        );
      },
    );
  }



  void _showCancellationSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(30.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 80, color: Colors.blue[900]),
              const SizedBox(height: 10),
              Text(
                "Confirmation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "The adventure #1234567 has been canceled successfully ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog



                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Ok', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Booking', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFeaeaea),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Adventure Details'),
              const SizedBox(height: 3),
              _buildAdventureDetailsCard(),
              const SizedBox(height: 16),
              _buildSectionTitle('Price Details'),
              const SizedBox(height: 3),
              _buildPriceDetailsCard(),
              const SizedBox(height: 16),
              _buildSectionTitle('Refund Policy'),
              const SizedBox(height: 3),
              _buildRefundPolicyCard(),
              const SizedBox(height: 16),
              Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
                    child:  SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showCancellationConfirmationDialog();
                          },// Replace with your actual onPressed function
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(fontSize: 16  ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min, // Use min size of Row so that it shrinks to fit children
                            children: [
                              Text('Cancel this booking', style: TextStyle(color: Colors.white)), // Text inside button
                            ],
                          ),
                        )

                    )

                ),


              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAdventureDetailsCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue[900],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    serviceProviderName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.calendar_today, 'Booking Date: $bookingDate'),
            _buildDetailRow(Icons.event, eventDate),
            _buildDetailRow(Icons.access_time, eventTime),
            _buildDetailRow(Icons.location_on, location),
            _buildDetailRow(Icons.people, gender),
            _buildDetailRow(Icons.directions_walk, activity),
            _buildDetailRow(Icons.assessment, difficulty),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetailsCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRow('Adventure Price', '\$$adventurePrice'),
            _buildPriceRow('Number of Tickets Reserved', '$numberOfTickets'),
            _buildPriceRow('Tax', '\$$tax'),
            const Divider(),
            _buildPriceRow('TOTAL', '\$${(adventurePrice * numberOfTickets + tax).toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundPolicyCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Row(
              children: [
              //  Icon(Icons.warning, color: Colors.yellow[800]!),
               // SizedBox(width: 8,),
                Expanded(child: Text(
                  'You will be refunded 50% of the total price of the ticket when canceling within 24 hours\n',
                  style: TextStyle(fontSize: 12),
                ), )
              ],
            ),
              const Row(
              children: [
              //   Icon(Icons.warning, color: Colors.yellow[800]!),
             //   SizedBox(width: 8,),
                Expanded(child:  Text(
                  'No refund will be given when canceling after 24 hours from the booking date',
                  style: TextStyle(fontSize: 12),
                ), ),

              ],
            ),
            const Divider(),
            _buildPriceRow('TOTAL REFUND', '\$$refundAmount', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[900]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detail,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


