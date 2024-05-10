import 'package:flutter/material.dart';
//import '.../adventure_booking_cart.dart';


class AdventureBookingCartScreen extends StatelessWidget {
  // Replace this with your actual AdventureBookingCart data
  final List<AdventureBookingCart> cartItems;

  const AdventureBookingCartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adventure Booking Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(
             child: Text('Your adventure cart is empty.'),
      )
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return ListTile(
            title: Text('Adventure ID: ${cartItem.adventureID}'),
            subtitle: Text('Quantity: ${cartItem.quantity}'),
            trailing: Text('Total Price: \$${cartItem.totalPrice.toStringAsFixed(2)}'),
            // Add additional information as needed
          );
        },
      ),
      // Add checkout button or further actions as needed
    );
  }
}

// Replace this with your actual AdventureBookingCart class
class AdventureBookingCart {
  final int cartID;
  final int userID;
  final int adventureID;
  final int quantity;
  final double totalPrice;
  final String status;

  AdventureBookingCart({
    required this.cartID,
    required this.userID,
    required this.adventureID,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });
}

void main() {
  // Replace this with your actual list of AdventureBookingCart items
  List<AdventureBookingCart> cartItems = [
    AdventureBookingCart(
      cartID: 1,
      userID: 123,
      adventureID: 456,
      quantity: 2,
      totalPrice: 100.0,
      status: 'active',
    ),
    // Add more cart items as needed
  ];

  runApp(MaterialApp(
    home: AdventureBookingCartScreen(cartItems: cartItems),
  ));
}
