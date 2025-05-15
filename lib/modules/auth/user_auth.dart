import 'package:flutter/material.dart';

class UserAuth extends StatelessWidget {
  const UserAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Foreground content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),
                              // Center(
                              //   child: Image.asset(
                              //     'assets/images/logo.png',
                              //     height: 60,
                              //   ),
                              // ),
                              const SizedBox(height: 40),
                              const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sign in to continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: Colors.black.withOpacity(0.1),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      // Email Input
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Email Address',
                                          labelStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(
                                            0.85,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 16,
                                              ),
                                          prefixIcon: const Icon(
                                            Icons.email_outlined,
                                            size: 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      // Password Input
                                      TextFormField(
                                        obscureText: true,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(
                                            0.85,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 16,
                                              ),
                                          prefixIcon: const Icon(
                                            Icons.lock_outlined,
                                            size: 20,
                                            color: Colors.black54,
                                          ),
                                          suffixIcon: TextButton(
                                            onPressed: () {
                                              // Handle forgot password
                                            },
                                            child: const Text(
                                              'Forgot?',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle login logic
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue[700],
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 18,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      const Row(
                                        children: [
                                          Expanded(child: Divider()),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                            child: Text(
                                              'OR',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Divider()),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/images/google.png',
                                              width: 24,
                                            ),
                                            onPressed: () {},
                                          ),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/images/google.png',
                                              width: 24,
                                            ),
                                            onPressed: () {},
                                          ),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/images/google.png',
                                              width: 24,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle sign up
                                          },
                                          child: const Text(
                                            'Register',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            children: [
                              const Text(
                                'Biometric authentication',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 12),
                              IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.withOpacity(0.1),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.fingerprint,
                                    size: 48,
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () async {
                                  // Handle biometric authentication
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
