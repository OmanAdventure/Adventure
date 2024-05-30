import 'package:flutter/material.dart';
import 'package:untitled/components/buttonsUI.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  CustomDialog({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          Icon(Icons.check_circle, size: 80, color: Colors.blue[900]),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 60),
          CustomButton(
            onPressed: onButtonPressed,
            buttonText: buttonText,
          ),
        ],
      ),
    );
  }
}


/*
the reusable part

   showDialog(
                     context: context,
                     barrierDismissible : false,
                     builder: (BuildContext context) {
                       return CustomDialog(
                         title: 'Password Reset',
                         message: 'Your password reset link has been sent. Please check your email ',
                         buttonText: 'OK',
                         onButtonPressed: () {
                           Navigator.of(context).pop();
                         },
                       );
                     },
                   );


 */