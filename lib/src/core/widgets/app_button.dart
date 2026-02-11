import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 48,
    this.backgroundColor = const Color(0xFF2563EB),
    this.disabledColor = const Color(0xFF93C5FD),
    this.foregroundColor = Colors.white,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final Color backgroundColor;
  final Color disabledColor;
  final Color foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final resolvedOnPressed = isLoading ? null : onPressed;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: resolvedOnPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return disabledColor;
            }
            return backgroundColor;
          }),
          foregroundColor: MaterialStateProperty.all(foregroundColor),
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          elevation: MaterialStateProperty.all(0),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: textStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}
