import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;


  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child:  SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                 onPressed, // Replace with your actual onPressed function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  textStyle: const TextStyle(fontSize: 16  ),
               ),
                 child: Row(
                   mainAxisSize: MainAxisSize.min, // Use min size of Row so that it shrinks to fit children
                   children: [
                    Text(buttonText, style: TextStyle(color: Colors.white)), // Text inside button
                  ],
                ),
              )

            )

            );
          }
        }