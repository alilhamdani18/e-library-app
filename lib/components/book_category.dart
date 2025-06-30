import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class BookCategory extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  const BookCategory({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: thirdColor,
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontFamily: 'InterSemiBold',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
