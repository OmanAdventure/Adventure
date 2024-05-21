import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/buttonsUI.dart';

void main() {
  runApp(ReviewAndConfirmApp());
}

class ReviewAndConfirmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReviewAndConfirmScreen(
        serviceProviderName: "Service Provider Name",
        date: "Friday, December 22, 2024",
        time: "03:00 PM - 06:00 PM",
        location: "Adventure Box Store",
        price: 15,
        tickets: 4,
        tax: 0,
      ),
    );
  }
}

class ReviewAndConfirmScreen extends StatefulWidget {
  final String serviceProviderName;
  final String date;
  final String time;
  final String location;
  final double price;
  final int tickets;
  final double tax;

  ReviewAndConfirmScreen({
    required this.serviceProviderName,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.tickets,
    required this.tax,
  });

  @override
  _ReviewAndConfirmScreenState createState() => _ReviewAndConfirmScreenState();
}

class _ReviewAndConfirmScreenState extends State<ReviewAndConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.price * widget.tickets + widget.tax;

    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text('Review and Confirm', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adventure Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue[900],
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.serviceProviderName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue[900]),
                      const SizedBox(width: 10),
                      Text(widget.date),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue[900]),
                      const SizedBox(width: 10),
                      Text(widget.time),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue[900]),
                      const SizedBox(width: 10),
                      Text(widget.location),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.group, color: Colors.blue[900]),
                      const SizedBox(width: 10),
                      const Text('Only Females'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.hiking, color: Colors.blue[900]),
                      const SizedBox(width: 10),
                      const Text('Hiking'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.speed, color: Colors.blue[900]),
                      const SizedBox(width: 10),
                      const Text('Difficulty Level'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () { if (kDebugMode) {
                  print("Edit Card details");
                }}, icon: Icon(Icons.edit,  size: 20, color: Colors.blue[900]), )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.credit_card_rounded,  color: Colors.blue[900]),
                  GestureDetector(
                    onTap: () {
                      // Add onTap functionality for the first Chip here.
                    },
                    child: Chip(
                      label: const Text('DIGITAL WALLET', style: TextStyle(fontSize: 12),),
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(side: BorderSide(color: Colors.blue[900]!)),
                      labelPadding: EdgeInsets.zero, // Minimize padding between text and chip border
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add onTap functionality for the second Chip here.
                    },
                    child: Chip(
                      label: const Text('VISA' , style: TextStyle(fontSize: 12),),
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(side: BorderSide(color: Colors.blue[900]!)),
                      labelPadding: EdgeInsets.zero, // Minimize padding between text and chip border
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add onTap functionality for the third Chip here.
                    },
                    child: Chip(
                      label: const Text('MASTER CARD', style: TextStyle(fontSize: 12),),
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(side: BorderSide(color: Colors.blue[900]!)),
                      labelPadding: EdgeInsets.zero, // Minimize padding between text and chip border
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Price Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Adventure Price'),
                      Text('\$${widget.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Number of Tickets Reserved'),
                      Text('${widget.tickets}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tax'),
                      Text('\$${widget.tax.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                     [
                      Icon(Icons.price_change_outlined,  color: Colors.blue[900]),
                       SizedBox(width: 5,),
                       const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'To protect your payment, please never transfer money or communicate with the service provider outside of this app.',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomButton(
                onPressed: () {},
                buttonText: 'Confirm',

              )
            ),
          ],
        ),
      ),
    );
  }
}
