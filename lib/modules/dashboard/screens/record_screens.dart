import 'package:flutter/material.dart';

class RecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.blue),
            title: Text("Shopping"),
            trailing: Text("-64", style: TextStyle(color: Colors.red)),
          ),
          ListTile(
            leading: Icon(Icons.directions_bus, color: Colors.green),
            title: Text("Transportation"),
            trailing: Text("-6", style: TextStyle(color: Colors.red)),
          ),
          ListTile(
            leading: Icon(Icons.fastfood, color: Colors.orange),
            title: Text("Food"),
            trailing: Text("-1,000", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
