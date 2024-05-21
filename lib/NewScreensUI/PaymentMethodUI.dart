import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/components/CustomAlertUI.dart';
import 'package:untitled/components/buttonsUI.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedCardIndex = 0;
  String? _selectedCard;
  bool _acceptTerms = false;
  bool _useAsDefault = false;
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,

        iconTheme: IconThemeData(color: Colors.blue[900]),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select card',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCardOption('assets/images/visa.png', 0),
                  _buildCardOption('assets/images/mastercard.png', 1),
                  _buildCardOption('assets/images/paypal.png', 2),
                ],
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                'Card holder',
                _cardHolderController,
                TextInputType.text,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]"))],
                hintText: 'Your name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildLabeledTextField(
                'Card number',
                _cardNumberController,
                TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _CardNumberFormatter(),
                ],
                hintText: 'XXXX XXXX XXXX XXXX',
                maxLength: 19,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledTextField(
                      'Valid until',
                      _expiryDateController,
                      TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ExpiryDateFormatter(),
                      ],
                      hintText: 'MM/YY',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildLabeledTextField(
                      'CVV',
                      _securityCodeController,
                      TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 3,
                      hintText: '***',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildCheckbox(
                value: _acceptTerms,
                onChanged: (value) => setState(() {
                  _acceptTerms = value!;
                }),
                text: 'Accept the ',
                linkText: 'Term and Conditions',
                onTap: () {},
              ),
              _buildCheckbox(
                value: _useAsDefault,
                onChanged: (value) => setState(() => _useAsDefault = value!),
                text: 'Use as default payment method',
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _acceptTerms
                        ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle form submission

                        // After submission is successful
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: ' ',
                              message: 'Your card has been successfully added!',
                              buttonText: 'OK',
                              onButtonPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue[900], // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ), // Disable the button if terms are not accepted
                    child: const Text('Add card'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardOption(String asset, int index) {
    return GestureDetector(
      onTap: () => setState(() {
        _selectedCardIndex = index;
        _selectedCard = asset;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedCardIndex == index ? Colors.blue[900]! : Colors.grey[200]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: asset,
              groupValue: _selectedCard,
              fillColor: MaterialStateProperty.all(Colors.blue[900]),
              onChanged: (value) => setState(() {
                _selectedCard = value!;
                _selectedCardIndex = index;
              }),
            ),
            Image.asset(
              asset,
              width: 60,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(
      String label,
      TextEditingController controller,
      TextInputType keyboardType, {
        List<TextInputFormatter>? inputFormatters,
        int? maxLength,
        String? hintText,
        String? Function(String?)? validator,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            counterText: '',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
          style: const TextStyle(height: 1.0), // Adjust the text height
        ),
      ],
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required void Function(bool?) onChanged,
    required String text,
    String? linkText,
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: Colors.blue[900],
          onChanged: onChanged,
        ),
        Text(text),
        if (linkText != null && onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              linkText,
              style:   TextStyle(color: Colors.blue[900], decoration: TextDecoration.underline),
            ),
          ),
      ],
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final newText = StringBuffer();
    if (text.length > 2) {
      newText.write(text.substring(0, 2) + '/');
      if (text.length > 4) {
        newText.write(text.substring(2, 4));
      } else {
        newText.write(text.substring(2));
      }
    } else {
      newText.write(text);
    }
    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final newText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i != 0 && i % 4 == 0) {
        newText.write(' ');
      }
      newText.write(text[i]);
    }
    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
