import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransactionsHistoryScreen(),
    );
  }
}

class TransactionsHistoryScreen extends StatefulWidget {
  @override
  _TransactionsHistoryScreenState createState() => _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState extends State<TransactionsHistoryScreen> {
  // Dynamic list of transactions
  final List<Map<String, dynamic>> transactions = [
    {
      'date': 'JAN 25, 2022',
      'entries': [
        {'name': 'Salim', 'status': 'Paid', 'time': '5:30 PM', 'amount': 60, 'aid': '3322442'},
        {'name': 'Ahmed', 'status': 'Paid', 'time': '1:30 PM', 'amount': 40, 'aid': '3322442'},
      ]
    },
    {
      'date': 'JAN 20, 2022',
      'entries': [
        {'name': 'Said', 'status': 'Paid', 'time': '1:30 PM', 'amount': 40, 'aid': '3322442'},
        {'name': 'Hamed', 'status': 'Paid', 'time': '1:30 PM', 'amount': 70, 'aid': '3322442'},
        {'name': 'Awab', 'status': 'Paid', 'time': '11:00 AM', 'amount': 90, 'aid': '3322442'},
      ]
    },
    {
      'date': 'JAN 10, 2022',
      'entries': [
        {'name': 'Khalid', 'status': 'Paid', 'time': '5:30 PM', 'amount': 60, 'aid': '3322442'},
        {'name': 'Hilal', 'status': 'Paid', 'time': '1:30 PM', 'amount': 600, 'aid': '3322442'},
        {'name': 'Said', 'status': 'Paid', 'time': '5:30 PM', 'amount': 50, 'aid': '3322442'},
      ]
    },
  ];

  List<Map<String, dynamic>> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    filteredTransactions = transactions; // Initialize with all transactions
  }

  void filterTransactions(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      filteredTransactions = transactions.where((transaction) {
        return transaction['entries'].any((entry) {
          final nameLower = entry['name'].toLowerCase();
          return nameLower.contains(lowerCaseQuery);
        });
      }).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text('Transactions History', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Field
              TextField(
                onChanged: filterTransactions,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.blue[900]),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),
              // Transactions List
              ...filteredTransactions.map((transaction) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction['date'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ...transaction['entries'].map<Widget>((entry) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: Text(entry['status'], style: TextStyle(color: Colors.green)),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(entry['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(entry['time']),
                                  Text('AID: ${entry['aid']}'),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Amount', style: TextStyle(fontSize: 12)),
                                  Text('\$${entry['amount']}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
