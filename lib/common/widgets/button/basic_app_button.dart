import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double ? height;

  final EdgeInsetsGeometry padding;
  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    super.key
  });
  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 80),
      ),
      child: Text(
        title
      )
    );
  }
}