import 'package:flutter/material.dart';
import '/screens/components/home_screen.dart';

class LoginScreen extends StatefulWidget
{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Sign in", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(8)),
                    side: const BorderSide(color: Colors.black12),
                    ),
                  label: const Text("Sign in with Google", style: TextStyle(color: Colors.black)),
                  onPressed: () {},
                  ),
                )
            ],
          ),
      )
    );
  }
}
