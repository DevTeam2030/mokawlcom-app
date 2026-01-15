import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/available_deals/available_deals_item.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/my_services/my_service_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class AvailableDealsScreen extends StatelessWidget {
  const AvailableDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.availableDeals,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.router.push(const SendOfferToContractorsRoute());
              },
              child: Text(
                LocaleKeys.addNewOffer,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) =>
                    AvailableDealsItem(theme: theme),
                separatorBuilder: (_, _) => const SizedBox(height: 20),
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
