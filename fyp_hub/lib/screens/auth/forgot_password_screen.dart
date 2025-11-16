import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fyp_hub/services/auth_service.dart';
import 'package:fyp_hub/widgets/custom_button.dart';
import 'package:fyp_hub/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  // Function to send the reset link
  void _sendResetLink() async {
    setState(() {
      _isLoading = true;
      _message = null;
      _isError = false;
    });

    final result = await _authService.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (result == null) {
      // Success
      setState(() {
        _isLoading = false;
        _isError = false;
        _message =
            "Success! A password reset link has been sent to your email.";
      });
    } else {
      // Failure
      setState(() {
        _isLoading = false;
        _isError = true;
        _message = result;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  delay: const Duration(milliseconds: 400),
                  child: const Text(
                    'Reset Password',
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
                    "Enter your email to receive a reset link.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
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
                const SizedBox(height: 20),

                if (_message != null)
                  FadeIn(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        _message!,
                        style: TextStyle(
                          color: _isError ? Colors.redAccent : Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),

                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: CustomButton(
                    text: 'SEND RESET LINK',
                    onTap: _sendResetLink,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
