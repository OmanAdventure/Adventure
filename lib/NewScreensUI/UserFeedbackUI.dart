import 'package:flutter/material.dart';
import 'package:untitled/NewScreensUI/SettingsScreenUI.dart';
import 'package:untitled/components/CustomAlertUI.dart';
import 'package:untitled/components/buttonsUI.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _feedbackController.removeListener(_onTextChanged);
    _feedbackController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _isButtonEnabled.value = _feedbackController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Your Feedback',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo
            Icon(
              Icons.ac_unit,
              size: 100,
              color: Colors.blue[900],
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Outdoor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Subtitle
            const Text(
              'We care about our customers. please share any feedback or thought',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Feedback TextField
            _buildFeedbackField(),
            const SizedBox(height: 50),
            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackField() {
    return TextField(
      controller: _feedbackController,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: 'Type your feedback...',
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[400]),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }



  Widget _buildSubmitButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isButtonEnabled,
      builder: (context, isEnabled, child) {
        return SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
              // Handle submit action
              showDialog(
                context: context,
                barrierDismissible : false,
                builder: (BuildContext context) {
                  return CustomDialog(
                    title: '',
                    message: 'Thanks for providing your feedback. We will take it into consideration.',
                    buttonText: 'OK',
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );

            }
                : null, // Disable the button when not enabled
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue[900], // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Submit'),
          ),
        );
      },
    );
  }
}

