import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
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
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
            title: Text('Payment Method'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50.0),
            alignment: Alignment.center,
            child: Text(
              'Thawani Screen goes here',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),
        ),
        );
      }
    }
