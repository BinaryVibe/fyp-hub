// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:fyp_hub/models/milestone.dart';

// class AddMilestoneDialog extends StatefulWidget {
//   const AddMilestoneDialog({super.key});

//   @override
//   State<AddMilestoneDialog> createState() => _AddMilestoneDialogState();
// }

// class _AddMilestoneDialogState extends State<AddMilestoneDialog> {
//   final _titleController = TextEditingController();
//   DateTime? _selectedDate;

//   void _presentDatePicker() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 7)), // Default next week
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.dark().copyWith(
//             colorScheme: const ColorScheme.dark(
//               primary: Colors.blue,
//               onPrimary: Colors.white,
//               surface: Colors.grey,
//               onSurface: Colors.white,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     ).then((pickedDate) {
//       if (pickedDate == null) return;
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     });
//   }

//   void _submitData() {
//     final enteredTitle = _titleController.text.trim();

//     // 🛡️ VALIDATION
//     if (enteredTitle.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('⚠️ Please enter a milestone title.')),
//       );
//       return;
//     }
//     if (_selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('⚠️ Please select a deadline.')),
//       );
//       return;
//     }

//     // Create the Milestone Object
//     final newMilestone = Milestone(
//       milestoneId: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: enteredTitle,
//       deadline: Timestamp.fromDate(_selectedDate!),
//       status: 'Pending',
//     );

//     // Return it to the Dashboard
//     Navigator.of(context).pop(newMilestone);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.grey[900],
//       title: const Text("Add New Milestone", style: TextStyle(color: Colors.white)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _titleController,
//             style: const TextStyle(color: Colors.white),
//             decoration: const InputDecoration(
//               labelText: 'Milestone Title',
//               labelStyle: TextStyle(color: Colors.white70),
//               enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   _selectedDate == null
//                       ? 'No Date Chosen!'
//                       : 'Deadline: ${DateFormat.yMd().format(_selectedDate!)}',
//                   style: const TextStyle(color: Colors.white70),
//                 ),
//               ),
//               TextButton(
//                 onPressed: _presentDatePicker,
//                 child: const Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
//         ),
//         ElevatedButton(
//           onPressed: _submitData,
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//           child: const Text("Add Task"),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fyp_hub/models/milestone.dart';

class AddMilestoneDialog extends StatefulWidget {
  const AddMilestoneDialog({super.key});

  @override
  State<AddMilestoneDialog> createState() => _AddMilestoneDialogState();
}

class _AddMilestoneDialogState extends State<AddMilestoneDialog> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  void _presentDatePicker() {
    // Theme colors for the picker
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 7),
      ), // Default next week
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        // UI Change: Customize DatePicker to match app theme
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: primaryColor, // Header background (Night Charcoal)
              onPrimary: Colors.white, // Header text
              onSurface: primaryColor, // Calendar text
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    final enteredTitle = _titleController.text.trim();

    // 🛡️ VALIDATION
    if (enteredTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please enter a milestone title.')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please select a deadline.')),
      );
      return;
    }

    // Create the Milestone Object
    final newMilestone = Milestone(
      milestoneId: DateTime.now().millisecondsSinceEpoch.toString(),
      title: enteredTitle,
      deadline: Timestamp.fromDate(_selectedDate!),
      status: 'Pending',
    );

    // Return it to the Dashboard
    Navigator.of(context).pop(newMilestone);
  }

  @override
  Widget build(BuildContext context) {
    // --- THEME COLORS ---
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; // Night Charcoal
    final secondaryColor = theme.colorScheme.secondary; // Ice Blue
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return AlertDialog(
      backgroundColor: Colors.white, // UI Change: Snow White
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Add New Milestone",
        style: TextStyle(
          color: primaryColor, // UI Change: Dark text
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Input
          TextField(
            controller: _titleController,
            style: TextStyle(color: primaryColor), // Dark text input
            decoration: InputDecoration(
              labelText: 'Milestone Title',
              labelStyle: TextStyle(color: subtitleColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: subtitleColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Date Selection Row
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Deadline: ${DateFormat.yMd().format(_selectedDate!)}',
                  style: TextStyle(color: subtitleColor),
                ),
              ),
              TextButton(
                onPressed: _presentDatePicker,
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor, // Dark text button
                ),
                child: const Text(
                  'Choose Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel", style: TextStyle(color: subtitleColor)),
        ),

        // Add Button
        ElevatedButton(
          onPressed: _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, // Night Charcoal
            foregroundColor: secondaryColor, // Ice Blue Text
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Add Task"),
        ),
      ],
    );
  }
}
