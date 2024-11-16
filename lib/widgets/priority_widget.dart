import 'package:flutter/material.dart';
import '../app/app_export.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class PriorityDialog extends StatelessWidget {
  final Function(String priority) onPrioritySelected;

  const PriorityDialog({
    Key? key,
    required this.onPrioritySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appTheme.blackA700,
      title: const Center(
        child: Text('Priority', textAlign: TextAlign.center),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _priorityButton(
                context,
                'high',
                appTheme.red500,
                Icons.flag_rounded,
              ),
              
              _priorityButton(
                context,
                'medium',
                appTheme.yellowA900,
                Icons.flag_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _priorityButton(
                context,
                'low',
                appTheme.teal300,
                Icons.flag_rounded,
              ),
              _priorityButton(
                context,
                'default',
                appTheme.indigoA100,
                Icons.flag_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priorityButton(
    BuildContext context,
    String priority,
    Color backgroundColor,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onPrioritySelected(priority);
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: backgroundColor,
              child: Icon(icon, color: appTheme.whiteA700),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            priority.capitalize(),
            style: theme.textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}
