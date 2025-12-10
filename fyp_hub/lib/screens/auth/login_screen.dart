// import 'package:flutter/material.dart';
// import 'package:fyp_hub/screens/auth/signup_screen.dart';
// import 'package:fyp_hub/screens/auth/forgot_password_screen.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:fyp_hub/services/auth_service.dart';
// import 'package:fyp_hub/widgets/custom_button.dart';
// import 'package:fyp_hub/widgets/custom_textfield.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   // Text controllers
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   // Your services
//   final AuthService _authService = AuthService();

//   // State variables
//   bool _isLoading = false;
//   String? _errorMessage;

//   // Sign in function
//   void _signIn() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     final user = await _authService.signInWithEmail(
//       _emailController.text.trim(),
//       _passwordController.text.trim(),
//     );

//     if (user == null) {
//       setState(() {
//         _errorMessage = "Login failed. Please check your email and password.";
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 50),

//                 // 2. WRAP YOUR WIDGETS
//                 FadeInDown(
//                   delay: const Duration(milliseconds: 300),
//                   child: const Icon(
//                     Icons.shield_outlined,
//                     size: 100,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 FadeInDown(
//                   delay: const Duration(milliseconds: 400),
//                   child: const Text(
//                     'FYP Hub',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 FadeInDown(
//                   delay: const Duration(milliseconds: 500),
//                   child: const Text(
//                     'Welcome Back.',
//                     style: TextStyle(color: Colors.white70, fontSize: 20),
//                   ),
//                 ),
//                 const SizedBox(height: 50),

//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 600),
//                   child: CustomTextField(
//                     controller: _emailController,
//                     hintText: 'Email',
//                   ),
//                 ),
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 700),
//                   child: CustomTextField(
//                     controller: _passwordController,
//                     hintText: 'Password',
//                     isPassword: true,
//                   ),
//                 ),

//                 const SizedBox(height: 10),
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 750),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const ForgotPasswordScreen(),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             'Forgot Password?',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 if (_errorMessage != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: Text(
//                       _errorMessage!,
//                       style: const TextStyle(color: Colors.redAccent),
//                     ),
//                   ),
//                 const SizedBox(height: 10),

//                 FadeInUp(
//                   delay: const Duration(milliseconds: 800),
//                   child: CustomButton(
//                     text: 'LOGIN',
//                     onTap: _signIn,
//                     isLoading: _isLoading,
//                   ),
//                 ),
//                 const SizedBox(height: 25),

//                 FadeInUp(
//                   delay: const Duration(milliseconds: 900),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't have an account? ",
//                         style: TextStyle(color: Colors.grey[400]),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const SignupScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fyp_hub/screens/auth/signup_screen.dart';
import 'package:fyp_hub/screens/auth/forgot_password_screen.dart';
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

  // 1. ADD THIS VARIABLE TO TRACK VISIBILITY
  bool _isObscured = true;

  // Sign in function
  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user == null) {
      if (mounted) {
        setState(() {
          _errorMessage = "Login failed. Please check your email and password.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access current theme colors
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;
    final scaffoldColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.shield_outlined,
                    size: 100,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),

                FadeInDown(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    'FYP Hub',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    'Welcome Back.',
                    style: TextStyle(color: subtitleColor, fontSize: 20),
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

                // 2. UPDATE THE PASSWORD FIELD
                FadeInLeft(
                  delay: const Duration(milliseconds: 700),
                  child: CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    // Bind the obscure state here
                    isPassword: _isObscured,
                    // Add the Eye Icon button
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                FadeInLeft(
                  delay: const Duration(milliseconds: 750),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
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
                        style: TextStyle(color: subtitleColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: theme.colorScheme.secondary,
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
