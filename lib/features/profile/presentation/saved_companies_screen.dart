import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/saved_company_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class SavedCompaniesScreen extends StatelessWidget {
  const SavedCompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.savedCompanies,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => SavedCompanyItem(theme: theme),
      ),
    );
  }
}
