import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text("Add Transaction"),
      ),
    );
  }
}
