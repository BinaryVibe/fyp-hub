import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fyp_hub/services/auth_service.dart';
import 'package:fyp_hub/widgets/custom_button.dart';
import 'package:fyp_hub/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Your services
  final AuthService _authService = AuthService();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;

  // Sign in function
  void _signIn() async {
    setState(() {
      _isLoading = true; // Show loading spinner on button
      _errorMessage = null; // Clear old errors
    });

    // Run the sign-in logic from your service
    final user = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // Check if sign-in was successful
    if (user == null) {
      // If it failed, show an error
      setState(() {
        _errorMessage = "Login failed. Please check your email and password.";
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  // Don't forget to dispose controllers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Kept your background change
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // 2. WRAP YOUR WIDGETS
                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                FadeInDown(
                  delay: const Duration(milliseconds: 400),
                  child: const Text(
                    'FYP Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  child: const Text(
                    'Welcome Back.',
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 50),

                FadeInLeft(
                  delay: const Duration(milliseconds: 600),
                  child: CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                ),

                FadeInLeft(
                  delay: const Duration(milliseconds: 700),
                  child: CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 20),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                const SizedBox(height: 10),

                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: CustomButton(
                    text: 'LOGIN',
                    onTap: _signIn,
                    isLoading: _isLoading,
                  ),
                ),
                const SizedBox(height: 25),

                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      GestureDetector(
                        onTap: () {
                          // We will add navigation to SignUpScreen here
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
