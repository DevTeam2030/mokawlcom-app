import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(
            LocaleKeys.hintAboutCompany,
            style: theme.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: ColorsManager.primaryColor,
            ),
          ),
          const CustomDivider(),
          Text(
            'شركة المقاولات العامة هي شركة رائدة في مجال البناء والتشييد، تأسست منذ أكثر من 20 عامًا وتتمتع بسجل حافل من المشاريع الناجحة في مختلف القطاعات. نحن ملتزمون بتقديم أعلى مستويات الجودة والخدمة لعملائنا، مع التركيز على الابتكار والاستدامة في جميع جوانب عملنا. فريقنا من المهندسين والفنيين ذوي الخبرة يعملون بلا كلل لضمان تحقيق رؤى عملائنا وتحويلها إلى واقع ملموس.',
            style: theme.textTheme.bodySmall!.copyWith(
              height: 1.5,
              color: ColorsManager.accentTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.commuincationsData,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryColor,
            ),
          ),
          const CustomDivider(),
          Text(
            LocaleKeys.email,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: ColorsManager.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "hr@example.net",
            style: theme.textTheme.bodyMedium!.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.blueAccent,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.address,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: ColorsManager.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'الخليج الغربي - الدوحة',
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.phoneNumber,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: ColorsManager.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '+974 4455 6677',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.whatsNumber,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: ColorsManager.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '+974 4455 6677',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorsManager.primaryColor,
                child: Icon(MyIcons.facebook, color: Colors.white, size: 20),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorsManager.primaryColor,
                child: Icon(MyIcons.twitter, color: Colors.white, size: 20),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorsManager.primaryColor,
                child: Icon(MyIcons.instagram, color: Colors.white, size: 20),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorsManager.primaryColor,
                child: Icon(MyIcons.snapchat, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
