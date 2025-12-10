// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:fyp_hub/models/milestone.dart';

// class EditMilestoneDialog extends StatefulWidget {
//   final Milestone milestone;
//   const EditMilestoneDialog({super.key, required this.milestone});

//   @override
//   State<EditMilestoneDialog> createState() => _EditMilestoneDialogState();
// }

// class _EditMilestoneDialogState extends State<EditMilestoneDialog> {
//   late TextEditingController _titleController;
//   late String _status;
//   DateTime? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     // 1. PRE-FILL DATA
//     _titleController = TextEditingController(text: widget.milestone.title);
//     _status = widget.milestone.status;
//     _selectedDate = widget.milestone.deadline.toDate();
//   }

//   void _presentDatePicker() {
//     showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
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
//     if (_titleController.text.isEmpty) return;

//     // Create Updated Object
//     final updatedMilestone = Milestone(
//       milestoneId: widget.milestone.milestoneId, // Keep original ID
//       title: _titleController.text.trim(),
//       deadline: Timestamp.fromDate(_selectedDate!),
//       status: _status, // Use new status
//     );

//     Navigator.of(context).pop(updatedMilestone);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.grey[900],
//       title: const Text("Edit Milestone", style: TextStyle(color: Colors.white)),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title Input
//             TextField(
//               controller: _titleController,
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 labelText: 'Title',
//                 labelStyle: TextStyle(color: Colors.white70),
//                 enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Date Picker
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     _selectedDate == null
//                         ? 'No Date Chosen!'
//                         : 'Deadline: ${DateFormat.yMd().format(_selectedDate!)}',
//                     style: const TextStyle(color: Colors.white70),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: _presentDatePicker,
//                   child: const Text('Change Date'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Status Dropdown
//             const Text("Status:", style: TextStyle(color: Colors.white70, fontSize: 12)),
//             DropdownButton<String>(
//               value: _status,
//               dropdownColor: Colors.grey[800],
//               isExpanded: true,
//               icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
//               underline: Container(height: 1, color: Colors.white30),
//               style: const TextStyle(color: Colors.white),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _status = newValue!;
//                 });
//               },
//               items: <String>['Pending', 'In Progress', 'Approved']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                       color: value == 'Approved' ? Colors.green : Colors.white,
//                       fontWeight: value == 'Approved' ? FontWeight.bold : FontWeight.normal,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
//         ),
//         ElevatedButton(
//           onPressed: _submitData,
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//           child: const Text("Save Changes"),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fyp_hub/models/milestone.dart';

class EditMilestoneDialog extends StatefulWidget {
  final Milestone milestone;
  const EditMilestoneDialog({super.key, required this.milestone});

  @override
  State<EditMilestoneDialog> createState() => _EditMilestoneDialogState();
}

class _EditMilestoneDialogState extends State<EditMilestoneDialog> {
  late TextEditingController _titleController;
  late String _status;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // 1. PRE-FILL DATA
    _titleController = TextEditingController(text: widget.milestone.title);
    _status = widget.milestone.status;
    _selectedDate = widget.milestone.deadline.toDate();
  }

  void _presentDatePicker() {
    // Theme colors
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        // UI Change: Light theme date picker
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: primaryColor, // Header background
              onPrimary: Colors.white, // Header text
              onSurface: primaryColor, // Calendar text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Button text
              ),
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
    if (_titleController.text.isEmpty) return;

    // Create Updated Object
    final updatedMilestone = Milestone(
      milestoneId: widget.milestone.milestoneId, // Keep original ID
      title: _titleController.text.trim(),
      deadline: Timestamp.fromDate(_selectedDate!),
      status: _status, // Use new status
    );

    Navigator.of(context).pop(updatedMilestone);
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
        "Edit Milestone",
        style: TextStyle(
          color: primaryColor, // UI Change: Dark text
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              style: TextStyle(color: primaryColor), // Dark text input
              decoration: InputDecoration(
                labelText: 'Title',
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

            // Date Picker
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
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                  child: const Text(
                    'Change Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Status Dropdown
            Text(
              "Status:",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _status,
              dropdownColor: Colors.white, // UI Change: White dropdown
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: primaryColor),
              underline: Container(height: 1, color: subtitleColor),
              style: TextStyle(color: primaryColor, fontSize: 16), // Dark text
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['Pending', 'In Progress', 'Approved']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          // UI Change: Green for Approved, otherwise Dark
                          color: value == 'Approved'
                              ? Colors.green
                              : primaryColor,
                          fontWeight: value == 'Approved'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel", style: TextStyle(color: subtitleColor)),
        ),

        // Save Button
        ElevatedButton(
          onPressed: _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, // Night Charcoal
            foregroundColor: secondaryColor, // Ice Blue Text
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Save Changes"),
        ),
      ],
    );
  }
}
