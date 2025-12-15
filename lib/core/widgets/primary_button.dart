import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  final VoidCallback onPressed;
  final String text;
  final Icon? icon;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48.0,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child:
            isLoading
                ? const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                  duration: Duration(milliseconds: 900),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon ?? const SizedBox.shrink(),
                    const SizedBox(width: 10.0),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
