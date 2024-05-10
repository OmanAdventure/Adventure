import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

// Thawani UTA Testing
Future<void> fetchCheckoutSessions() async {
  final apiKey = 'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et';
  final apiUrl = 'https://uatcheckout.thawani.om/api/v1/checkout/session?limit=10&skip=0';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'thawani-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final sessions = jsonResponse['data'];

      for (final session in sessions) {
        // Extract relevant information from the session
        final paymentStatus = session['payment_status'];
        final successUrl = session['success_url'];
        final cancelUrl = session['cancel_url'];

        // Display information to the user or perform other actions based on payment status

        // Redirect users based on payment status
        if (paymentStatus == 'paid') {
          // Navigate to success page or show a success message
          // Example: Navigator.pushNamed(context, '/success');
          print('Payment Successful');
          print('Success URL: $successUrl');
        } else {
          // Navigate to cancel page or show a cancellation message
          // Example: Navigator.pushNamed(context, '/cancel');
          print('Payment Canceled');
          print('Cancel URL: $cancelUrl');
        }
      }
    } else {
      print('Error: ${response.statusCode}');
      // Handle the error based on the response status code
    }
  } catch (error) {
    print('Error: $error');
    // Handle other errors such as network issues
  }
}

// Rest of your code...


Future<void> createCheckoutSession() async {
  final apiKey = 'rRQ26GcsZzoEhbrP2HZvLYDbn9C9et';
  final apiUrl = 'https://uatcheckout.thawani.om/api/v1/checkout/session';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'thawani-api-key': apiKey,
      },
      body: jsonEncode({
        'limit': 10,
        'skip': 0,
        // Add other required parameters based on Thawani's documentation
      }),
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      // Parse the JSON or handle the data accordingly
    } else {
      print('Error: ${response.statusCode}');
      // Handle the error based on the response status code
    }
  } catch (error) {
    print('Error: $error');
    // Handle other errors such as network issues
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;
  bool _isCameraInitialized = false;
  String _extractedData = '';

  late TextEditingController _cardNumberController;
  late TextEditingController _expiryController;
  late TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _expiryController = TextEditingController();
    _cvvController = TextEditingController();

    // Initialize the camera controller
    _initializeCameraController();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _initializeCameraController() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );
    await _cameraController?.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

      @override
      Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final appBarColor = themeProvider.darkMode
            ? themeProvider.darkTheme.primaryColor
            : Color(0xFF700464);

        return Scaffold(
            appBar: AppBar(
            //  backgroundColor: Color(0xFF700464),
              backgroundColor: appBarColor,
            title: Text('Payment Method'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50.0),
            alignment: Alignment.center,
            child:  Center(
              child: ElevatedButton(
              onPressed: () {
                   fetchCheckoutSessions();
                  },
                 child: Text('Fetch Checkout Sessions'),
            ),
          ),
          )
         ),
        );
      }
    }
