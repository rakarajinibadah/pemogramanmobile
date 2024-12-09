import 'package:flutter/material.dart';
import 'package:mountain/app/constants/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final bool isLoading; 

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = AppTheme.primaryColor,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.fontSize = 16.0,
    this.isLoading = false, // Default nilai isLoading false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          isLoading ? null : onPressed, 
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 5,
        textStyle: TextStyle(fontSize: fontSize),
      ),
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  strokeWidth: 2.0,
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(color: textColor),
            ),
    );
  }
}
