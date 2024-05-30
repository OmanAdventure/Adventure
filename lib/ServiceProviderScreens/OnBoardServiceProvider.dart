import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/CustomAlertUI.dart';
import 'ServiceProviderDashboardUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OnboardServiceProviderScreen(),
    );
  }
}

class OnboardServiceProviderScreen extends StatefulWidget {
  const OnboardServiceProviderScreen({super.key});

  @override
  _OnboardServiceProviderScreenState createState() =>
      _OnboardServiceProviderScreenState();
}

class _OnboardServiceProviderScreenState
    extends State<OnboardServiceProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonDisabled = true;
  bool _isChecked = false;

  // Controllers for the text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController safetyController = TextEditingController();
  TextEditingController webController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // State for checkboxes
  Map<String, bool> services = {
    'Horse Riding': false,
    'Hiking': false,
    'Beach Adventures': false,
    'Cycling': false,
  };

  Map<String, bool> availability = {
    'January': false,
    'February': false,
    'March': false,
    'April': false,
    'May': false,
    'June': false,
    'July': false,
    'August': false,
    'September': false,
    'October': false,
    'November': false,
    'December': false,
  };

  // Check if all fields are filled
  void _checkForm() {
    if (_formKey.currentState!.validate() && _isChecked) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }




// CheckBox Validator
  void serviceCheckBoxValidator() {
    showDialog(
    context: context,
    builder: (BuildContext context) {

      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.blue[900]),
            const SizedBox(width: 8),
            const Text('Alert'),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[

              Text(
                  'Services: ${services.entries.where((entry) => entry.value).map((entry) => entry.key).join(', ')}'),

            ],
          ),
        ),
        actions: <Widget>[


          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // Add your submission logic here
            },
            child: const Text('oK', style: TextStyle(color: Colors.white),),
          ),
        ],
      );


        },
    );
  }

  // CheckBox Validator
  void  availabilityCheckBoxValidator() {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue[900]),
              const SizedBox(width: 8),
              const Text('Alert'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                Text(
                    'Availability: ${availability.entries.where((entry) => entry.value).map((entry) => entry.key).join(', ')}'),

              ],
            ),
          ),
          actions: <Widget>[


            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Add your submission logic here
              },
              child: const Text('oK', style: TextStyle(color: Colors.white),),
            ),
          ],
        );


      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange, size: 35,),
              SizedBox(width: 10),
              Text('Are you sure that \nyou want to confirm?', style: TextStyle(fontSize: 20),),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email: ${emailController.text}'),
                Text('Name: ${nameController.text}'),
                Text('Company: ${companyController.text}'),
                Text('Location: ${locationController.text}'),
                Text('Phone: ${phoneController.text}'),
                Text('Safety Protocols: ${safetyController.text}'),
                Text('Website: ${webController.text}'),
                Text('Password: ${passwordController.text}'),
                Text(
                    'Services: ${services.entries.where((entry) => entry.value).map((entry) => entry.key).join(', ')}'),
                Text(
                    'Availability: ${availability.entries.where((entry) => entry.value).map((entry) => entry.key).join(', ')}'),
              ],
            ),
          ),
          actions: <Widget>[

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Add your submission logic here
              },
              child: const Text('Edit', style: TextStyle(color: Colors.white),),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Add your submission logic here

                showDialog(
                  context: context,
                  barrierDismissible : false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CustomDialog(
                        title: '\n\nThe Service Provider\nOnboard Successfully!',
                        message: ' ',
                        buttonText: 'OK',
                        onButtonPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );



              },
              child: const Text('Submit', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Onboard a Service Provider'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: _checkForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue[900],
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Service Provider Email',
                icon: Icons.email,
                controller: emailController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter an email' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Service Provider First and Last Name',
                icon: Icons.person,
                controller: nameController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Company Name or Business Name',
                icon: Icons.business,
                controller: companyController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a company name' : null,
              ),
              const SizedBox(height: 10),
              const Text('Provided Services'),
              Wrap(
                children: services.keys.map((String key) {
                  return _buildCheckbox(
                    title: key,
                    value: services[key]!,
                    onChanged: (bool? value) {
                      setState(() {
                        services[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Location',
                icon: Icons.location_on,
                controller: locationController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a location' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Phone Number',
                icon: Icons.phone,
                controller: phoneController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a phone number' : null,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 10),
              const Text('Availability'),
              Wrap(
                children: availability.keys.map((String key) {
                  return _buildCheckbox(
                    title: key,
                    value: availability[key]!,
                    onChanged: (bool? value) {
                      setState(() {
                        availability[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'What are the Safety Protocols follows?',
                icon: Icons.description,
                controller: safetyController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter safety protocols' : null,
                maxLines: 8,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Business website or social media page (URL)',
                icon: Icons.link,
                controller: webController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a URL' : null,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Set a Password for the candidate to login',
                icon: Icons.lock,
                controller: passwordController,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a password' : null,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    activeColor: Colors.blue[900],
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                        _checkForm();


                        // service CheckBox Validator
                        if (!services.values.any((value) => value)) {
                          serviceCheckBoxValidator();
                        }
                           // availability CheckBox Validator
                        if (!availability.values.any((value) => value)) {
                          availabilityCheckBoxValidator();
                        }

                      });
                    },
                  ),
                  const Text('I agree with '),
                  GestureDetector(
                    onTap: () {
                      // Open terms and conditions
                    },
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isButtonDisabled ? null : _showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[900]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
    );
  }

  Widget _buildCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue[900],
        ),
        Text(title),
      ],
    );
  }





}
