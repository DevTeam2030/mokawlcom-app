import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/shared/widgets/price_offer_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class PriceOffersScreen extends StatelessWidget {
  const PriceOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      separatorBuilder: (context, index) =>
          const CustomDivider(thickness: 0.8, height: 1),
      itemBuilder: (context, index) => PriceOfferItem(theme: theme),
    );
  }
}
