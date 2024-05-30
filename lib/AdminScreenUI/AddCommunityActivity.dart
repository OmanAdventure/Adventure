import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommunityActivitiesScreen(),
    );
  }
}

class CommunityActivitiesScreen extends StatefulWidget {
  @override
  _CommunityActivitiesScreenState createState() => _CommunityActivitiesScreenState();
}

class _CommunityActivitiesScreenState extends State<CommunityActivitiesScreen> {
  final _formKey = GlobalKey<FormState>();
  // Dynamic variables for form fields
  String hostingGroupName = '';
  String phoneNumber = '';
  String startDate1 = '05/05/2024 - 03:00 PM';
  String startDate2 = '05/05/2024 - 06:00 PM';
  bool isFreeAdventure = false;
  String locationName = '';
  bool activityLocationAdded = false;
  bool gatheringLocationAdded = false;



  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime(2025, 1, 1, 00, 00);
  TextEditingController adventureLocationName = TextEditingController();
  TextEditingController gatheringLocationName = TextEditingController();
  TextEditingController adventureLocationLink = TextEditingController();
  TextEditingController gatheringLocationLink = TextEditingController();


  @override
  void initState() {
    super.initState();
    adventureLocationLink.addListener(_printLatestValue);
    gatheringLocationLink.addListener(_printLatestValue);
  }

  @override
  void dispose() {

    adventureLocationLink.dispose();
    gatheringLocationLink.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print('Text changed: ${adventureLocationLink.text}');
    print('Text changed: ${gatheringLocationLink.text}');
  }


  // Check if all fields are filled
  bool get isFormValid {
    return hostingGroupName.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        locationName.isNotEmpty &&
        (activityLocationAdded || gatheringLocationAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: const Text('Community Activities', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Hosting Group Name Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Hosting Group Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      hostingGroupName = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Phone Number Field
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Start Date Fields
                 Column(
                   children: [
                     // Starts Date
                     Padding(
                       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                       child: Column(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.blue[900],
                               elevation: 4.0,
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(40.0)
                               ),
                             ),
                             onPressed: () {
                               pickDateTimeStart();
                             },

                             child: Container (
                               alignment: Alignment.center,
                               height: 50.0,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Row(
                                     children: <Widget>[
                                       Row(
                                         children: <Widget>[
                                           const Icon(
                                             Icons.calendar_month_sharp,
                                             // size: 18.0,
                                             color: Colors.white,
                                           ),
                                           Text(' Start Date:  $startDate  - $startTime ', style: const TextStyle(color: Colors.white)),

                                         ],
                                       )
                                     ],
                                   ),

                                   const Icon(
                                     Icons.edit,
                                     // size: 18.0,
                                     color: Colors.white,
                                   ),
                                 ],
                               ),
                             ),
                           )
                         ],
                       ),
                     ),
                     // End Date
                     Padding(
                       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                       child: Column(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.blue[900],
                               elevation: 4.0,
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(40.0)
                               ),
                             ),
                             onPressed: () {
                               pickDateTimeEnd();
                             },

                             child: Container(
                               alignment: Alignment.center,
                               height: 50.0,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Row(
                                     children: <Widget>[
                                       Row(
                                         children: <Widget>[
                                           const Icon(
                                             Icons.calendar_month_sharp,
                                             // size: 18.0,
                                             color: Colors.white,
                                           ),
                                           Text(' End Date:  $endDate   -   $endTime ', style: const TextStyle(color: Colors.white)),

                                         ],
                                       )
                                     ],
                                   ),
                                   const Icon(
                                     Icons.edit,
                                     // size: 18.0,
                                     color: Colors.white,
                                   ),
                                 ],
                               ),
                             ),
                           )
                         ],
                       ),
                     ),
                   ],
                 ),
                const SizedBox(height: 16),
                // Is Free Adventure Toggle
                Row(
                  children: [
                    const Text('Is free Adventure?'),
                    const Spacer(),
                    Switch(
                      activeColor: Colors.blue[900],
                      value: isFreeAdventure,
                      onChanged: (value) {
                        setState(() {
                          isFreeAdventure = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),


                // Adventure Location Name
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[900]!, width: 0.5),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: adventureLocationName,
                      maxLines: 1,
                      decoration:    InputDecoration(
                        hintText:  "  Enter Adventure Location Name",
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
                  ),
                ),
                // Gathering Location Name
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[900]!, width: 0.5),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: gatheringLocationName,
                      maxLines: 1,
                      decoration:    InputDecoration(
                        hintText:  "  Enter Gathering Location Name",
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
                  ),
                ),
                // Adventure Location Link
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[900]!, width: 0.5),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: adventureLocationLink,
                      maxLines: 2,
                      decoration:    InputDecoration(
                        hintText:  "  Enter Adventure Location Link",
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
                  ),
                ),
                // Gathering Location Link
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[900]!, width: 0.5),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller:  gatheringLocationLink   ,
                      maxLines: 2,
                      decoration:    InputDecoration(
                        hintText:  "  Enter Gathering Location Link",
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: FloatingActionButton(
                              onPressed: () {
                                // Add onPressed functionality here.
                              },
                              backgroundColor: Colors.blue[100],
                              shape: const StadiumBorder(),
                              child: Icon(
                                Icons.map_outlined,
                                size: 50,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                'Adventure Location',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                ),
                              ),
                              // Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              adventureLocationLink.text.isEmpty
                                  ? const Icon(Icons.cancel, color: Colors.red)
                                  : const Icon(Icons.check_circle, color: Colors.green),
                              Text(
                                adventureLocationLink.text.isEmpty ? 'add location ' : 'added ',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                ),
                              ),
                              //    Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: FloatingActionButton(
                              onPressed: () {
                                // Add onPressed functionality here.
                              },
                              backgroundColor: Colors.blue[100],
                              shape: const StadiumBorder(),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 50,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                'Gathering Location',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                ),
                              ),
                              //    Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              gatheringLocationLink.text.isEmpty
                                  ? const Icon(Icons.cancel, color: Colors.red)
                                  : const Icon(Icons.check_circle, color: Colors.green),
                              Text(
                                gatheringLocationLink.text.isEmpty ? 'add location ' : 'added ',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                ),
                              ),
                              //    Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),



                const SizedBox(height: 32),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isFormValid ? () {
                      // Handle form submission
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    child: const Text('Submit', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  /// ---------------------- Time Picker Section -------------------------

  late  String   startDate = _dateTimeStart != null
      ? '${_dateTimeStart.year}/${_dateTimeStart.month}/${_dateTimeStart.day}'
      : "Not set";
  late  String    endDate = _dateTimeEnd != null
      ? '${_dateTimeEnd.year}/${_dateTimeEnd.month}/${_dateTimeEnd.day}'
      : "Not set";

  late String startTime = _dateTimeStart != null
      ? '${_dateTimeStart.hour.toString().padLeft(2, '0')}:${_dateTimeStart.minute.toString().padLeft(2, '0')}'
      : "Not set";

  late String endTime = _dateTimeEnd != null
      ? '${_dateTimeEnd.hour.toString().padLeft(2, '0')}:${_dateTimeEnd.minute.toString().padLeft(2, '0')}'
      : "Not set";


  Future pickDateTimeStart() async {
    DateTime? dateStart = await pickDate();
    if (dateStart == null) return; // Cancel button.
    TimeOfDay? timeStart = await pickTimeStart();
    if (timeStart == null) return;

    final dateTimeStart = DateTime(
      dateStart.year,
      dateStart.month,
      dateStart.day,
      timeStart.hour,
      timeStart.minute,
    );

    setState(() {
      _dateTimeStart = dateTimeStart;
      startDate = '${dateTimeStart.year}/${dateTimeStart.month}/${dateTimeStart.day}';
      startTime = '${dateTimeStart.hour.toString().padLeft(2, '0')}:${dateTimeStart.minute.toString().padLeft(2, '0')}';
    });
  }

  Future pickDateTimeEnd() async {
    DateTime? dateEnd = await pickDate();
    if (dateEnd == null) return; // Cancel button.
    TimeOfDay? timeEnd = await pickTimeEnd();
    if (timeEnd == null) return;

    final dateTimeEnd = DateTime(
      dateEnd.year,
      dateEnd.month,
      dateEnd.day,
      timeEnd.hour,
      timeEnd.minute,
    );

    setState(() {
      _dateTimeEnd = dateTimeEnd;
      endDate = '${dateTimeEnd.year}/${dateTimeEnd.month}/${dateTimeEnd.day}';
      endTime = '${dateTimeEnd.hour.toString().padLeft(2, '0')}:${dateTimeEnd.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<DateTime?> pickDate() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2060),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[900], // Change this to the desired teal color
            hintColor: Colors.blue[900], // Change this to the desired teal color
            colorScheme:   ColorScheme.light(primary: Colors.blue[900]!), // Change this to the desired teal color
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[900], // Change this to the desired teal color
            hintColor: Colors.blue[900], // Change this to the desired teal color for time picker
            colorScheme:   ColorScheme.light(primary: Colors.blue[900]!), // Change this to the desired teal color
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> pickTimeStart() async {
    return pickTime();
  }

  Future<TimeOfDay?> pickTimeEnd() async {
    return pickTime();
  }











  // -----------------------------------
}
