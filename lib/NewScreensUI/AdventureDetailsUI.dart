import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/buttonsUI.dart';

void main() {
  runApp(const AdventureBookingApp());
}

class AdventureBookingApp extends StatelessWidget {
  const AdventureBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AdventureBookingScreen(
        serviceProviderName: "Service Provider Name",
        description: "Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description",
        startDate: "2024/02/02",
        startTime: "14:00",
        endDate: "2024/02/02",
        endTime: "18:00",
        totalParticipants: 20,
        pricePerPerson: 10,
      ),
    );
  }
}

class AdventureBookingScreen extends StatefulWidget {
  final String serviceProviderName;
  final String description;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final int totalParticipants;
  final double pricePerPerson;

  const AdventureBookingScreen({super.key,
    required this.serviceProviderName,
    required this.description,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.totalParticipants,
    required this.pricePerPerson,
  });

  @override
  _AdventureBookingScreenState createState() => _AdventureBookingScreenState();
}

class _AdventureBookingScreenState extends State<AdventureBookingScreen> {
  int _ticketCount = 1;

  void _incrementTickets() {
    setState(() {
      _ticketCount++;
    });
  }

  void _decrementTickets() {
    if (_ticketCount > 1) {
      setState(() {
        _ticketCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Adventure Booking', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Icon(Icons.image, size: 100, color: Colors.grey)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.favorite_border, color: Colors.black),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.black, size: 8),
                            Icon(Icons.circle, color: Colors.black, size: 8),
                            Icon(Icons.circle, color: Colors.black, size: 8),
                          ],
                        ),
                        Icon(Icons.share, color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.serviceProviderName,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Column(
                        children: [
                          Icon(Icons.hiking, size: 50 , color: Colors.blue[900]),
                          const SizedBox(height: 5),
                          Text('Hiking', style: TextStyle(color: Colors.blue[900])),
                        ],
                      ),

                      Column(
                      children: [
                        Icon(Icons.speed,  size: 50 ,   color: Colors.blue[900]),
                        const SizedBox(height: 5),
                        Text('Difficulty Level',
                            style: TextStyle(color: Colors.blue[900], )
                        ),
                      ],
                    ),

                      Column(
                        children: [
                          Icon(Icons.group,  size: 50 ,  color: Colors.blue[900]),
                          const SizedBox(height: 5),
                          Text('Only Females', style: TextStyle(color: Colors.blue[900])),
                        ],
                      ),

                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Adventure Description',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),


                  const SizedBox(height: 15),

                  Divider(),

                  const SizedBox(height: 15),

                    // Time and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.blue[900]),
                                const SizedBox(width: 5),
                                Text('Starts on: ${widget.startDate}', style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.blue[900]),
                                const SizedBox(width: 5),
                                Text('End on:     ${widget.endDate}', style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.blue[900]),
                                const SizedBox(width: 5),
                                Text(widget.startTime, style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),

                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.blue[900]),
                                const SizedBox(width: 5),
                                Text(widget.endTime, style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),


                  const SizedBox(height: 15),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [

                          Padding(
                            padding: EdgeInsets.all(5),
                              child: FloatingActionButton(
                                onPressed: () {
                                  // Add onPressed functionality here.
                                },
                                backgroundColor: Colors.blue[100],
                                shape: StadiumBorder(),
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

                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: FloatingActionButton(
                              onPressed: () {
                                // Add onPressed functionality here.
                              },
                              backgroundColor: Colors.blue[100],
                              shape: StadiumBorder(),
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
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Divider(),

                  const SizedBox(height: 15),
                  // Age
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    //  Text( 'Not family adventure', style: TextStyle(color: Colors.grey[700]), ),

                      Icon(Icons.family_restroom_sharp, color: Colors.blue[900]),
                      const SizedBox(width: 5),
                      Text(
                        'Age Group: +12',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                // Number of Participants
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.groups, color: Colors.blue[900]),
                      const SizedBox(width: 5),
                      Text(
                        'Number of Participants: ${widget.totalParticipants}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                 // const SizedBox(height: 10),
                  // Number of tickets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.pause_presentation, color: Colors.blue[900]),
                      const SizedBox(width: 5),
                      Text('Number of Tickets', style: TextStyle(color: Colors.grey[700])),
                     Spacer(),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline, size: 30, color: Colors.blue[900]),
                            onPressed: _decrementTickets,
                          ),
                          Text('$_ticketCount', style: TextStyle(color: Colors.grey[700])),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline, size: 30, color: Colors.blue[900]),
                            onPressed: _incrementTickets,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //Total Price
                  Text(
                    'Total Price \$${(widget.pricePerPerson * _ticketCount).toStringAsFixed(2)} / Per person',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  const SizedBox(height: 10),
                 const Divider(),
                 CustomButton(onPressed: () {}, buttonText: "Book now"),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
