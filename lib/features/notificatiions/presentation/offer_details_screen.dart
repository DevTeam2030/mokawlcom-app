import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/widgets/offer_details.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class OfferDetailsScreen extends StatelessWidget {
  const OfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.offerDetails,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OfferDetails(theme: theme, isOffer: true),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 14),
            child: Text(
              LocaleKeys.replys,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: ColorsManager.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => OfferDetails(theme: theme),
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
