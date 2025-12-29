import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class GoogleAndAppleSignInWidgets extends StatelessWidget {
  const GoogleAndAppleSignInWidgets({super.key, required this.onGoogleTap});
  final void Function() onGoogleTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onGoogleTap,
          child: Container(
            height: 48.0,
            decoration: BoxDecoration(
              border: Border.all(color: ColorsManager.secondaryColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign in with Google",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 24.0),
                const Image(image: AssetImage(AssetsManager.googleIcon)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          height: 48.0,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign in with Apple",
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 24.0),
              const Image(image: AssetImage(AssetsManager.appleIcon)),
            ],
          ),
        ),
      ],
    );
  }
}
