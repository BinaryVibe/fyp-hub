// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:fyp_hub/models/app_user.dart';
// import 'package:fyp_hub/models/student.dart';
// import 'package:fyp_hub/models/supervisor.dart';
// import 'package:fyp_hub/services/user_service.dart';
// import 'package:fyp_hub/widgets/custom_button.dart';
// import 'package:fyp_hub/widgets/custom_textfield.dart';

// class CreateProfileScreen extends StatefulWidget {
//   final AppUser user; // Receives the user from the Wrapper
//   const CreateProfileScreen({super.key, required this.user});

//   @override
//   State<CreateProfileScreen> createState() => _CreateProfileScreenState();
// }

// class _CreateProfileScreenState extends State<CreateProfileScreen> {
//   final UserService _userService = UserService();

//   // Controllers for all possible fields
//   late TextEditingController _nameController;
//   late TextEditingController
//   _field1Controller; // For Student: Domain, For Sup: Availability
//   late TextEditingController
//   _chipInputController; // For adding skills/interests

//   List<String> _chipList = []; // For skills/interests

//   bool _isLoading = false;
//   String? _errorMessage;

//   // UI Labels
//   String _title = 'Complete Your Profile';
//   String _field1Label = '';
//   String _chipListLabel = '';
//   String _chipInputHint = '';

//   @override
//   void initState() {
//     super.initState();

//     // Set up the UI based on the user's role
//     _nameController = TextEditingController(text: widget.user.name);

//     if (widget.user is Student) {
//       _title = 'Complete Student Profile';
//       _field1Label = 'Your Domain';
//       _field1Controller = TextEditingController();
//       _chipListLabel = 'Your Skills';
//       _chipInputHint = 'Add a skill (e.g., Flutter)';
//       _chipList = [];
//     } else if (widget.user is Supervisor) {
//       _title = 'Complete Supervisor Profile';
//       _field1Label = 'Your Availability';
//       _field1Controller = TextEditingController();
//       _chipListLabel = 'Your Research Interests';
//       _chipInputHint = 'Add an interest (e.g., AI)';
//       _chipList = [];
//     }

//     _chipInputController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _field1Controller.dispose();
//     _chipInputController.dispose();
//     super.dispose();
//   }

//   // --- UI Methods ---

//   void _addChip() {
//     final text = _chipInputController.text.trim();
//     if (text.isNotEmpty && !_chipList.contains(text)) {
//       setState(() {
//         _chipList.add(text);
//         _chipInputController.clear();
//       });
//     }
//   }

//   void _removeChip(String chip) {
//     setState(() {
//       _chipList.remove(chip);
//     });
//   }

//   // --- LOGIC ---
//   Future<void> _saveProfile() async {
//     // 1. Reset any previous error messages
//     setState(() {
//       _errorMessage = null;
//     });

//     // --- VALIDATION START ---

//     // 2. Check if Name is empty
//     if (_nameController.text.trim().isEmpty) {
//       setState(() {
//         _errorMessage = "Please enter your full name.";
//       });
//       return; // Stop here
//     }

//     // 3. Check if Domain (Student) or Availability (Supervisor) is empty
//     if (_field1Controller.text.trim().isEmpty) {
//       setState(() {
//         // Show different message based on role
//         _errorMessage = widget.user is Student
//             ? "Please enter your domain."
//             : "Please enter your availability.";
//       });
//       return; // Stop here
//     }

//     // 4. Check if the Chip list (Skills/Interests) is empty
//     if (_chipList.isEmpty) {
//       setState(() {
//         // Show different message based on role
//         _errorMessage = widget.user is Student
//             ? "Please add at least one skill."
//             : "Please add at least one interest.";
//       });
//       return; // Stop here
//     }

//     // --- VALIDATION END ---

//     // If we passed all checks, proceed with saving
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Create a Map of the data we want to update.
//       Map<String, dynamic> dataToUpdate;

//       if (widget.user is Student) {
//         dataToUpdate = {
//           'name': _nameController.text.trim(),
//           'domain': _field1Controller.text.trim(),
//           'skills': _chipList,
//         };
//       } else {
//         // It's a Supervisor
//         dataToUpdate = {
//           'name': _nameController.text.trim(),
//           'availability': _field1Controller.text.trim(),
//           'interests': _chipList,
//         };
//       }

//       // Send the data to the user service
//       await _userService.updateUserProfile(widget.user.uid, dataToUpdate);

//       // Wrapper handles navigation automatically when stream updates
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = "Failed to save profile. Please try again.";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: Text(
//           _title,
//           style: const TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         centerTitle: true,
//         // No back button, to force profile completion
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 30),
//                 // Profile Picture
//                 FadeInDown(
//                   child: Center(
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[900],
//                       child: const Icon(
//                         Icons.person,
//                         size: 60,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // --- DYNAMIC FORM ---

//                 // Full Name
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 300),
//                   child: Text(
//                     'Full Name',
//                     style: TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 400),
//                   child: CustomTextField(
//                     controller: _nameController,
//                     hintText: 'Your full name',
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Field 1 (Domain or Availability)
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 500),
//                   child: Text(
//                     _field1Label,
//                     style: TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 600),
//                   child: CustomTextField(
//                     controller: _field1Controller,
//                     hintText: _field1Label,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Chip Input (Skills or Interests)
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 700),
//                   child: Text(
//                     _chipListLabel,
//                     style: TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 FadeInLeft(
//                   delay: const Duration(milliseconds: 800),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           controller: _chipInputController,
//                           hintText: _chipInputHint,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(Icons.add, color: Colors.white),
//                           onPressed: _addChip,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 15),

//                 // Chip Wrap
//                 FadeIn(
//                   delay: const Duration(milliseconds: 900),
//                   child: Wrap(
//                     spacing: 8.0,
//                     runSpacing: 8.0,
//                     children: _chipList.map((chip) {
//                       return Chip(
//                         label: Text(
//                           chip,
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         backgroundColor: Colors.grey[800],
//                         deleteIcon: const Icon(
//                           Icons.close,
//                           size: 18,
//                           color: Colors.white70,
//                         ),
//                         onDeleted: () => _removeChip(chip),
//                       );
//                     }).toList(),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // Error Message
//                 if (_errorMessage != null)
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         _errorMessage!,
//                         style: const TextStyle(color: Colors.redAccent),
//                       ),
//                     ),
//                   ),

//                 // Save Button
//                 FadeInUp(
//                   delay: const Duration(milliseconds: 1000),
//                   child: CustomButton(
//                     text: 'SAVE PROFILE',
//                     onTap: _saveProfile,
//                     isLoading: _isLoading,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fyp_hub/models/app_user.dart';
import 'package:fyp_hub/models/student.dart';
import 'package:fyp_hub/models/supervisor.dart';
import 'package:fyp_hub/services/user_service.dart';
import 'package:fyp_hub/widgets/custom_button.dart';
import 'package:fyp_hub/widgets/custom_textfield.dart';

class CreateProfileScreen extends StatefulWidget {
  final AppUser user; // Receives the user from the Wrapper
  const CreateProfileScreen({super.key, required this.user});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final UserService _userService = UserService();

  // Controllers for all possible fields
  late TextEditingController _nameController;
  late TextEditingController
  _field1Controller; // For Student: Domain, For Sup: Availability
  late TextEditingController
  _chipInputController; // For adding skills/interests

  List<String> _chipList = []; // For skills/interests

  bool _isLoading = false;
  String? _errorMessage;

  // UI Labels
  String _title = 'Complete Your Profile';
  String _field1Label = '';
  String _chipListLabel = '';
  String _chipInputHint = '';

  @override
  void initState() {
    super.initState();

    // Set up the UI based on the user's role
    _nameController = TextEditingController(text: widget.user.name);

    if (widget.user is Student) {
      _title = 'Complete Student Profile';
      _field1Label = 'Your Domain';
      _field1Controller = TextEditingController();
      _chipListLabel = 'Your Skills';
      _chipInputHint = 'Add a skill (e.g., Flutter)';
      _chipList = [];
    } else if (widget.user is Supervisor) {
      _title = 'Complete Supervisor Profile';
      _field1Label = 'Your Availability';
      _field1Controller = TextEditingController();
      _chipListLabel = 'Your Research Interests';
      _chipInputHint = 'Add an interest (e.g., AI)';
      _chipList = [];
    }

    _chipInputController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _field1Controller.dispose();
    _chipInputController.dispose();
    super.dispose();
  }

  // --- UI Methods ---

  void _addChip() {
    final text = _chipInputController.text.trim();
    if (text.isNotEmpty && !_chipList.contains(text)) {
      setState(() {
        _chipList.add(text);
        _chipInputController.clear();
      });
    }
  }

  void _removeChip(String chip) {
    setState(() {
      _chipList.remove(chip);
    });
  }

  // --- LOGIC ---
  Future<void> _saveProfile() async {
    // 1. Reset any previous error messages
    setState(() {
      _errorMessage = null;
    });

    // --- VALIDATION START ---

    // 2. Check if Name is empty
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Please enter your full name.";
      });
      return; // Stop here
    }

    // 3. Check if Domain (Student) or Availability (Supervisor) is empty
    if (_field1Controller.text.trim().isEmpty) {
      setState(() {
        // Show different message based on role
        _errorMessage = widget.user is Student
            ? "Please enter your domain."
            : "Please enter your availability.";
      });
      return; // Stop here
    }

    // 4. Check if the Chip list (Skills/Interests) is empty
    if (_chipList.isEmpty) {
      setState(() {
        // Show different message based on role
        _errorMessage = widget.user is Student
            ? "Please add at least one skill."
            : "Please add at least one interest.";
      });
      return; // Stop here
    }

    // --- VALIDATION END ---

    // If we passed all checks, proceed with saving
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a Map of the data we want to update.
      Map<String, dynamic> dataToUpdate;

      if (widget.user is Student) {
        dataToUpdate = {
          'name': _nameController.text.trim(),
          'domain': _field1Controller.text.trim(),
          'skills': _chipList,
        };
      } else {
        // It's a Supervisor
        dataToUpdate = {
          'name': _nameController.text.trim(),
          'availability': _field1Controller.text.trim(),
          'interests': _chipList,
        };
      }

      // Send the data to the user service
      await _userService.updateUserProfile(widget.user.uid, dataToUpdate);

      // Wrapper handles navigation automatically when stream updates
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to save profile. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- THEME COLORS ---
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; // Night Charcoal
    final secondaryColor = theme.colorScheme.secondary; // Ice Blue
    final scaffoldColor = theme.scaffoldBackgroundColor; // Snow White
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldColor, // UI Change: Snow White
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Cleaner look
        elevation: 0,
        title: Text(
          _title,
          style: TextStyle(
            color: primaryColor, // UI Change: Dark text
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // No back button, to force profile completion
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                // Profile Picture
                FadeInDown(
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      // UI Change: Dark background for avatar
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        // UI Change: Ice Blue Icon
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // --- DYNAMIC FORM ---

                // Full Name
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Full Name',
                    // UI Change: Slate Grey label
                    style: TextStyle(color: subtitleColor, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: CustomTextField(
                    controller: _nameController,
                    hintText: 'Your full name',
                  ),
                ),
                const SizedBox(height: 20),

                // Field 1 (Domain or Availability)
                FadeInLeft(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    _field1Label,
                    style: TextStyle(color: subtitleColor, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInLeft(
                  delay: const Duration(milliseconds: 600),
                  child: CustomTextField(
                    controller: _field1Controller,
                    hintText: _field1Label,
                  ),
                ),
                const SizedBox(height: 20),

                // Chip Input (Skills or Interests)
                FadeInLeft(
                  delay: const Duration(milliseconds: 700),
                  child: Text(
                    _chipListLabel,
                    style: TextStyle(color: subtitleColor, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInLeft(
                  delay: const Duration(milliseconds: 800),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _chipInputController,
                          hintText: _chipInputHint,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          // UI Change: Night Charcoal Button
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          // UI Change: Ice Blue Icon
                          icon: Icon(Icons.add, color: secondaryColor),
                          onPressed: _addChip,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Chip Wrap
                FadeIn(
                  delay: const Duration(milliseconds: 900),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _chipList.map((chip) {
                      return Chip(
                        label: Text(
                          chip,
                          // UI Change: Dark text on light chip
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // UI Change: Ice Blue tint background
                        backgroundColor: secondaryColor.withOpacity(0.3),
                        deleteIcon: Icon(
                          Icons.close,
                          size: 18,
                          color: primaryColor,
                        ),
                        side: BorderSide.none, // Cleaner look
                        onDeleted: () => _removeChip(chip),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 40),

                // Error Message
                if (_errorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ),

                // Save Button
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  child: CustomButton(
                    text: 'SAVE PROFILE',
                    onTap: _saveProfile,
                    isLoading: _isLoading,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
