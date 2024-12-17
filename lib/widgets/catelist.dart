import 'package:flutter/material.dart';

import '../models/category_model.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

   @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Category'),
      content: categories.isEmpty
          ? const Text('None of categories', style: TextStyle(color: Colors.grey))
          : SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category.color,
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      onCategorySelected(category);
                    },
                  );
                },
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
