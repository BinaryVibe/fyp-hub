import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp
import 'package:intl/intl.dart'; // For formatting the date text
import 'package:fyp_hub/models/milestone.dart';

class AddMilestoneDialog extends StatefulWidget {
  const AddMilestoneDialog({super.key});

  @override
  State<AddMilestoneDialog> createState() => _AddMilestoneDialogState();
}

class _AddMilestoneDialogState extends State<AddMilestoneDialog> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  // Function to show the Date Picker
  void _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)), // Default to tomorrow
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)), // 1 year from now
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to "Submit" the form
  void _submit() {
    if (_titleController.text.trim().isEmpty || _selectedDate == null) {
      return; // Validation: Do nothing if empty
    }

    // Create a new Milestone object
    final newMilestone = Milestone(
      milestoneId: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      title: _titleController.text.trim(),
      deadline: Timestamp.fromDate(_selectedDate!),
      status: 'Pending',
    );

    // Return it to the Dashboard
    Navigator.pop(context, newMilestone);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text("Add New Milestone", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. TITLE INPUT
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "e.g., Submit Chapter 1",
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            ),
          ),
          const SizedBox(height: 20),

          // 2. DATE PICKER ROW
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
              const SizedBox(width: 10),
              Text(
                _selectedDate == null
                    ? "Select Deadline"
                    : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              TextButton(
                onPressed: _pickDate,
                child: const Text("Pick Date"),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: _submit,
          child: const Text("Add Task", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}