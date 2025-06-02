import 'package:flutter/material.dart';
import 'package:e_library/utils/colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? childColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.childColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 236, 248, 239),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: childColor ?? textGreyColor),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: childColor,
                    fontFamily: 'InterSemiBold',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
