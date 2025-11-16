import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fyp_hub/models/student.dart';
import 'package:fyp_hub/models/supervisor.dart';
import 'package:fyp_hub/services/auth_service.dart';
import 'package:fyp_hub/services/user_service.dart';
import 'package:fyp_hub/widgets/custom_button.dart';
import 'package:fyp_hub/widgets/custom_textfield.dart';

enum UserRole { student, supervisor }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Services
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  // State variables
  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;
  String? _errorMessage;

  void _signUp() async {
    // 1. Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // 2. Create user in Firebase Auth
    final newUser = await _authService.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (newUser == null) {
      setState(() {
        _errorMessage = "Sign up failed. The email may already be in use.";
        _isLoading = false;
      });
      return;
    }

    // 3. Auth was successful, now create profile in Firestore
    try {
      if (_selectedRole == UserRole.student) {
        Student newStudent = Student(
          uid: newUser.uid,
          email: newUser.email ?? '',
          name: _nameController.text.trim(),
          skills: [],
          domain: '',
          teammates: [],
        );
        // Save student to database
        await _userService.createUserProfile(newStudent);
      } else {
        // Create a Supervisor model
        Supervisor newSupervisor = Supervisor(
          uid: newUser.uid,
          email: newUser.email ?? '',
          name: _nameController.text.trim(),
          interests: [], // Empty for now
          availability: '', // Empty for now
        );
        // Save supervisor to database
        await _userService.createUserProfile(newSupervisor);
      }
    } catch (e) {
      // Database profile creation failed
      setState(() {
        _errorMessage = "Error creating profile: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // 1. Logo
                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                // 2. Title
                FadeInDown(
                  delay: const Duration(milliseconds: 400),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 3. Subtitle
                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  child: const Text(
                    'Get started with FYP Hub',
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 30),

                // 4. Role Toggle
                FadeInDown(
                  delay: const Duration(milliseconds: 600),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ToggleButton(
                            text: 'Student',
                            isSelected: _selectedRole == UserRole.student,
                            onTap: () => setState(
                              () => _selectedRole = UserRole.student,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ToggleButton(
                            text: 'Supervisor',
                            isSelected: _selectedRole == UserRole.supervisor,
                            onTap: () => setState(
                              () => _selectedRole = UserRole.supervisor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 5. Form Fields
                FadeInLeft(
                  delay: const Duration(milliseconds: 700),
                  child: CustomTextField(
                    controller: _nameController,
                    hintText: 'Full Name',
                  ),
                ),
                FadeInLeft(
                  delay: const Duration(milliseconds: 800),
                  child: CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                ),
                FadeInLeft(
                  delay: const Duration(milliseconds: 900),
                  child: CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                ),
                FadeInLeft(
                  delay: const Duration(milliseconds: 1000),
                  child: CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 20),

                // 6. Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 10),

                // 7. Sign Up Button
                FadeInUp(
                  delay: const Duration(milliseconds: 1100),
                  child: CustomButton(
                    text: 'SIGN UP',
                    onTap: _signUp,
                    isLoading: _isLoading,
                  ),
                ),
                const SizedBox(height: 25),

                // 8. Sign In Row
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate back to Login
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In',
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

// Helper widget for the toggle button
class ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
