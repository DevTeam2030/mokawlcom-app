import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/worker_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.services,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 18),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "مقاول",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.secondaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 30,
                runSpacing: 24,
                children: List.generate(9, (index) =>  WorkerItem(
                  onTap: () {
                    context.pushRoute(const JobOffersRoute());
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
