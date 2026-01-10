import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/job_offer/job_offer_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class JobOffersScreen extends StatelessWidget {
  const JobOffersScreen({super.key, required this.classification, required this.service});
final String classification;
final String service;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$classification - $service',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16.0,
          vertical: 13.0,
        ),
        child: ListView.separated(
          itemBuilder: (context, index) => const JobOfferItem(),
          separatorBuilder: (_, _) => const SizedBox(height: 13),
          itemCount: 3,
        ),
      ),
    );
  }
}
