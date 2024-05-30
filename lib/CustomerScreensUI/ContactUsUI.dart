import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/components/CustomAlertUI.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _subjectController.addListener(_onTextChanged);
    _descriptionController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _subjectController.removeListener(_onTextChanged);
    _descriptionController.removeListener(_onTextChanged);
    _subjectController.dispose();
    _descriptionController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _isButtonEnabled.value = _subjectController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _acceptTerms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.ac_unit,color:  Colors.blue[900], ),
                const SizedBox(width: 7,),
                const Text(
                  'We will make sure to get your issue with \n app resolved as soon as possible',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabeledContainer(
              'Subject',
              _subjectController,
              TextInputType.text,
              hintText: 'What is your issue related to?',
            ),
            const SizedBox(height: 10),
            _buildLabeledContainer(
              'Description',
              _descriptionController,
              TextInputType.multiline,
              maxLines: 10,
              hintText: 'Describe the issue that you are facing..',
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  activeColor: Colors.blue[900],
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value!;
                      _onTextChanged();
                    });
                  },
                ),
                const Text('Accept the '),
                GestureDetector(
                  onTap: () {},
                  child:   Text(
                    'Term and Conditions',
                    style: TextStyle(color:  Colors.blue[900],),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isEnabled
                          ? () {
                        // Handle form submission

                        // After submission is successful
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: ' ',
                              message: 'Your request has been sent successfully!',
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
                      child: const Text('Send'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledContainer(
      String label,
      TextEditingController controller,
      TextInputType keyboardType, {
        int? maxLines = 1,
        String? hintText,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[900]!, width: 1.5),
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
