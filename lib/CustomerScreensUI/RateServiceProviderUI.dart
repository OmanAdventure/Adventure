import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
/// Firebase Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:untitled/components/buttonsUI.dart';



/// Initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp(

  ));
}

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RatingScreen(),
    );
  }
}

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
   RatingScreenState createState() => RatingScreenState();
}

class  RatingScreenState extends State<RatingScreen> {
  int _rating = 0;

  // Function to return text based on rating
  String getRatingText() {
    switch (_rating) {
      case 1:
        return 'Poor Service';        // Consistent negative descriptor
      case 2:
        return 'Fair Service';        // Consistent moderate negative descriptor
      case 3:
        return 'Good Service';        // Neutral positive descriptor
      case 4:
        return 'Very Good Service';   // Consistent positive descriptor
      case 5:
        return 'Excellent Service';   // Highest positive descriptor
      default:
        return 'No Rating';           // Default case when no rating is provided
    }
  }

  final List<String> _selectedReviews = [];

  // To store the uploaded image
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;


  final List<File> _selectedImages = []; // List to store selected images


  // Function to select image from gallery
  void _selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (_selectedImages.length < 3) {
          _selectedImages.add(File(pickedFile.path));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),

      appBar: AppBar(
        title: const Text('Rating'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(16.0),
              child:  Container(
                decoration: BoxDecoration(
                color: Colors.white, // Set background color to white
                borderRadius: BorderRadius.circular(20), // Set rounded edges
                ),
                padding: const EdgeInsets.all(16.0),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                      Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[900],
                        radius: 50,
                        child: const Icon(Icons.person_outline, size: 40, color: Colors.white),
                      ),
                    ),
                    const Text(
                      'Adventure Box Team',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Text(
                        'Share your experience with this adventure provider!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const Divider(),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            size: 40,
                            Icons.star,
                            color: _rating > index ? Colors.blue[900] : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    Text(
                      getRatingText(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                ]
              )

              ),
            ),


              const Padding(
                padding: EdgeInsets.only(left: 30),
                child:  Align(
                       alignment: Alignment.bottomLeft,
                      child: Text(
                        "Other Reviews",
                        style: TextStyle(fontSize: 16,  ),
                      ),
                    ),
              ),

            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Wrap(
                  spacing: 5,
                  children: ['Friendly', 'Timeliness', 'Professionalism', 'Organized']
                      .map((review) => ChoiceChip(
                    checkmarkColor: Colors.white,
                    label: Text(review),
                    selected: _selectedReviews.contains(review),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedReviews.add(review);
                          if (_selectedReviews.length > 3) {
                            _selectedReviews.removeAt(0);
                          }
                        } else {
                          _selectedReviews.remove(review);
                        }
                      });
                    },
                    selectedColor: Colors.blue[900],
                    labelStyle: TextStyle(color: _selectedReviews.contains(review) ? Colors.white : Colors.black),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // This controls the roundness of the edges
                    ),
                  ))
                      .toList(),
                ),
              ),
            ),



            const Padding(
              padding: EdgeInsets.only(left: 30),
              child:  Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Comments",
                  style: TextStyle(fontSize: 16,  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Type your feedback here...',
                  filled: true, // Set filled to true
                  fillColor: Colors.white, // Set fillColor to white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.grey), // Set borderSide color to white
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                maxLines: 3,
              ),
            ),




            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color to white
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: _selectedImages.length < 3 ? _selectImageFromGallery : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900], // Set button background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Add Photos",
                                style: TextStyle(color: Colors.white), // Set text color to white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Add some spacing between button and image
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _selectedImages.map((image) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: FileImage(image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _selectedImages.remove(image);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            CustomButton (onPressed: () {
              showCustomDialog(context);
              }, buttonText: "Submit",
            )

          ],
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: SizedBox(
          width: double.infinity,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Icon(Icons.check_circle_outline, size: 100, color: Colors.blue[900],),
              const SizedBox(height: 20),
              const Text('Thanks for Rating the Service Provider',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 150),
              SizedBox(
                height: 50,
                width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Back to Notification', style: TextStyle(color: Colors.white) ),
              ),



              )

            ],
          ),
        ),
      );
    },
  );
}
