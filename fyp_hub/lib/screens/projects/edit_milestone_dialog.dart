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
  late DateTime _selectedDate;
  late String _status;

  final List<String> _statusOptions = ['Pending', 'Submitted', 'Approved'];

  @override
  void initState() {
    super.initState();
    // 1. Pre-fill the form with existing data
    _titleController = TextEditingController(text: widget.milestone.title);
    _selectedDate = widget.milestone.deadline.toDate();
    _status = widget.milestone.status;
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;

    // 2. Create updated object
    final updatedMilestone = Milestone(
      milestoneId: widget.milestone.milestoneId, // Keep ID same
      title: _titleController.text.trim(),
      deadline: Timestamp.fromDate(_selectedDate),
      status: _status,
    );

    // 3. Send back
    Navigator.pop(context, updatedMilestone);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text("Edit Milestone", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text("Title", style: TextStyle(color: Colors.grey, fontSize: 12)),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Deadline
          const Text("Deadline", style: TextStyle(color: Colors.grey, fontSize: 12)),
          InkWell(
            onTap: _pickDate,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Status Dropdown
          const Text("Status", style: TextStyle(color: Colors.grey, fontSize: 12)),
          DropdownButton<String>(
            value: _status,
            dropdownColor: Colors.grey[850],
            isExpanded: true,
            underline: Container(height: 1, color: Colors.white54),
            items: _statusOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: value == 'Approved' ? Colors.green : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _status = newValue!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: _save,
          child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}