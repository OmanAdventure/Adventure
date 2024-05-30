import 'package:flutter/material.dart';
import 'package:untitled/components/buttonsUI.dart';

void main() {
  runApp(TermsAndConditionsApp());
}

class TermsAndConditionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TermsAndConditionsScreenSettings(),
    );
  }
}

class Section {
  final String title;
  final String content;

  Section({required this.title, required this.content});
}

class TermsAndConditionsScreenSettings extends StatefulWidget {
  @override
  _TermsAndConditionsScreenSettingsState createState() => _TermsAndConditionsScreenSettingsState();
}

class _TermsAndConditionsScreenSettingsState extends State<TermsAndConditionsScreenSettings> {


  final List<Section> sections = [
    Section(
      title: '1. Introduction',
      content: 'Ad veniam reprehenderit exercitation aute deserunt minim veniam. Voluptate irure nisi consequat do ad aliquip nisi enim laborum aliqua. Magna reprehenderit.',
    ),
    Section(
      title: '2. Who can use this app?',
      content: 'Ut nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt sit excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt sit excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt sit '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'excepteur nisi r nostrud cupidatat elit est eiusmod voluptate dolore nisi. Eiusmod deserunt '
          'sit excepteur nisi reprehenderit dolor labore magna pariatur nisi. Eilt deserunt cupidatat anim '
          'consequat reprehenderit voluptate. Labore labore non consequat ut voluptate reprehenderit est. '
          'Nostrud dolore et magna tempor co.',
    ),
    // Add more sections as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Terms & Conditions', style: TextStyle(color: Colors.black)),
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
                            Text('Terms & Conditions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text('Update 1/8/2022', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 20, thickness: 1),
                    for (var section in sections)
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
                    CustomButton(onPressed: () { Navigator.pop(context); } , buttonText: "Ok")
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
