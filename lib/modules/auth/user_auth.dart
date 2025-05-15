import 'package:flutter/material.dart';

class UserAuth extends StatelessWidget {
  const UserAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to CreditTrack'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Handle login logic
              },
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                // Handle forgot password
              },
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
