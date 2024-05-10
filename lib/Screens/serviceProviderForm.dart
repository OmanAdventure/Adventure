import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ServiceProviderRegistrationScreen extends StatefulWidget {
  @override
  _ServiceProviderRegistrationScreenState createState() =>
      _ServiceProviderRegistrationScreenState();
}

class _ServiceProviderRegistrationScreenState
    extends State<ServiceProviderRegistrationScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : Color(0xFF700464);

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Registration', style: TextStyle(color: Colors.white),),
       // backgroundColor: Color(0xFF700464),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _fbKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildFormField(
                  name: 'fullName',
                  label: 'Full Name',
                ),
                _buildFormField(
                  name: 'contactInformation',
                  label: 'Contact Information',
                ),
                _buildFormField(
                  name: 'dateOfBirth',
                  label: 'Date of Birth',
                ),
                _buildFormField(
                  name: 'address',
                  label: 'Address',
                ),
                _buildCheckboxGroup(
                  name: 'adventure Types',
                  label: 'Types of Adventures Provided',
                  options: [
                    FormBuilderFieldOption(value: 'Hiking'),
                    FormBuilderFieldOption(value: 'Horse Riding'),
                    FormBuilderFieldOption(value: 'Beach Adventures'),
                    FormBuilderFieldOption(value: 'Cycling'),
                  ],
                ),
                _buildFormField(
                  name: 'experience',
                  label: 'Years of Experience in Each Type',
                ),
                _buildFormField(
                  name: 'certifications',
                  label: 'Certification or Training in Adventure Services',
                ),
                _buildFormField(
                  name: 'business Name',
                  label: 'Company/Organization Name (if applicable)',
                ),
                _buildFormField(
                  name: 'business Registration Number',
                  label: 'Business Registration Number (if applicable)',
                ),
                _buildFormField(
                  name: 'website',
                  label: 'Website/Social Media Links',
                ),
                _buildFormField(
                  name: 'areas Covered',
                  label: 'Areas or Regions Covered',
                ),
                _buildFormField(
                  name: 'meeting Points',
                  label: 'Meeting Point(s) for Adventures',
                ),
                _buildFormField(
                  name: 'safety Measures',
                  label: 'Description of Safety Measures',
                  //  maxLines: 3,
                ),
                _buildFormField(
                  name: 'equipment And Gear',
                  label: 'List of Equipment and Gear Provided',
                  //    maxLines: 3,
                ),
                _buildFormField(
                  name: 'equipment Condition',
                  label: 'Condition and Maintenance of Equipment',
                ),
                _buildFormField(
                  name: 'customer Reviews',
                  label: 'Customer Reviews/Testimonials',
                  //  maxLines: 3,
                ),
                _buildFormField(
                  name: 'insurance',
                  label: 'Information on Liability Insurance Coverage',
                ),
                _buildFormField(
                  name: 'compliance',
                  label: 'Confirmation of Compliance with Local Regulations',
                ),
                _buildFormField(
                  name: 'availability',
                  label: 'Days and Times Available',
                ),
                _buildFormField(
                  name: 'cancellation Policy',
                  label: 'Cancellation Policy',
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    if (_fbKey.currentState?.saveAndValidate() ?? false) {
                      Map<String, dynamic> formData =
                          _fbKey.currentState?.value ?? {};
                      _showConfirmationDialog(formData);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text('Submit',  style: TextStyle(color: Colors.white, fontSize: 25),),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF700464),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String name,
    required String label,

  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF700464)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: TextStyle(color: Color(0xFF700464)), // Set hint text color to teal
        ),
        maxLines: null, // Set maxLines to null for auto-expansion
      ),
    );
  }



  Widget _buildCheckboxGroup({
    required String name,
    required String label,
    List<FormBuilderFieldOption<String>> options = const [],
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FormBuilderCheckboxGroup(
        name: name,
        options: options,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF700464)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF700464)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: TextStyle(color: Color(0xFF700464)),
          labelStyle: TextStyle(color: Color(0xFF700464)),
        ),
        activeColor: Color(0xFF700464), // Set the checkbox color when checked to teal
      ),
    );
  }


  void _showConfirmationDialog(Map<String, dynamic> formData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation', textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Color(0xFF700464)), // Teal border for the AlertDialog
          ),
          content: Container(
            padding: EdgeInsets.all(8.0), // Add padding of 8.0
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF700464)), // Teal border around the entire content
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (MapEntry<String, dynamic> entry in formData.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('${entry.key}: ${entry.value}'),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text('Submit'),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF700464),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10,),
            // Cancel
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text('Cancel'),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void main() {
  runApp(MaterialApp(
    home: ServiceProviderRegistrationScreen(),
    theme: ThemeData(
      primaryColor: Color(0xFF700464),
    ),
  ));
}
}