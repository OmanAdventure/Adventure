import 'package:flutter/material.dart';

void main() {
  runApp(TermsAndConditionsApp());
}

class TermsAndConditionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TermsAndConditionsScreen(
        title: 'Terms & Conditions',
        updateDate: 'Update 1/8/2022',
        sections: [
          Section(
            title: '1. Introduction',
            content: 'Ad veniam reprehenderit exercitation aute deserunt minim veniam. Voluptate irure nisi consequat do ad aliquip nisi enim laborum aliqua. Magna reprehenderit.',
          ),
          Section(
            title: '2. Who can use this app?',
            content: 'Ut  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt sit excepteur nisi r  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt sit excepteur nisi r   nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt sit '
                'excepteur nisi r  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
                'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
                'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
                'excepteur nisi r  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
                'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
                'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
                'excepteur nisi r  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
                'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
                'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
                'excepteur nisi r  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
                'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
                'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
                'excepteur nisi r  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
                'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
                'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
                'excepteur nisi r  nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
                'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
                'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
                'Nostrud dolore et magna tempor co.',
          ),
          // Add more sections as needed
        ],
      ),
    );
  }
}

class Section {
  final String title;
  final String content;

  Section({required this.title, required this.content});
}

class TermsAndConditionsScreen extends StatefulWidget {
  final String title;
  final String updateDate;
  final List<Section> sections;

  TermsAndConditionsScreen({required this.title, required this.updateDate, required this.sections});

  @override
  _TermsAndConditionsScreenState createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _agreedToTerms = false;

  void _showDeclineAlert() {
    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text('Alert'),
            ],
          ),
          content: Text('Accepting the terms and conditions is a must to login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [


          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description, color: Colors.blue[900], size: 40),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text(widget.updateDate, style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 20, thickness: 1),
                    for (var section in widget.sections)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(section.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(section.content, style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 20),
                        ],
                      ),

                    Divider(height: 20, thickness: 1),

                    Row(
                      children: [
                        Checkbox(
                           activeColor: Colors.blue[900],
                          value: _agreedToTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                        ),
                        Flexible(
                          child: Text('I have read & agree with above T&Cs', style: TextStyle(color: Colors.grey[700])),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: _showDeclineAlert,
                          child: Text('Decline'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[900],
                            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                            side: BorderSide(color: Colors.blue[900]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _agreedToTerms ? () {} : null,
                          child: Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
