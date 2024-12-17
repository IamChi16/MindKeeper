import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:reminder_app/app/app_export.dart';

import '../models/category_model.dart';

class CategoryDialog extends StatefulWidget {
  final Category? category;
  final Function(Category)
      onSave;

  const CategoryDialog({
    super.key,
    this.category,
    required this.onSave,
  });

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category?.name ?? '';
    _selectedColor = widget.category?.color ?? Colors.white;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appTheme.blackA700,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),  
            decoration: const InputDecoration(
                hintText: 'Home',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.color_lens, color: _selectedColor),
                onPressed: () async {
                  Color? pickedColor;
                  await showDialog(
                    context: context,
                    builder: (context) {
                      Color tempColor = _selectedColor;
                      return AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: _selectedColor,
                            onColorChanged: (color) {
                              tempColor = color;
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Select'),
                            onPressed: () {
                              pickedColor = tempColor;
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (pickedColor != null) {
                    setState(() {
                      _selectedColor = pickedColor!;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.indigoA100,
            foregroundColor: appTheme.whiteA700,
          ),
          onPressed: () {
            final newCategory = Category(
              id: widget.category?.id ?? '',
              name: _nameController.text,
              color: _selectedColor,
            );
            widget.onSave(newCategory);
            Navigator.of(context).pop();
          },
          child: Text(widget.category == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
