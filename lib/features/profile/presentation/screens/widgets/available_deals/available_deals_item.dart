import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class AvailableDealsItem extends StatelessWidget {
  const AvailableDealsItem({
    super.key,
    required this.theme,
    required this.deal,
    required this.index,
  });
  final ThemeData theme;
  final DealModel deal;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.secondaryColor, width: .7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(MyIcons.file, color: ColorsManager.primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  deal.title,
                  style: theme.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsManager.errorLight.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              child: const Icon(
                                MyIcons.trash,
                                color: ColorsManager.errorLight,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              LocaleKeys.deleteDeal,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.deleteDealMessage,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: ColorsManager.grayText,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: ColorsManager.primaryColor,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      LocaleKeys.cancel,
                                      style: theme.textTheme.labelLarge!
                                          .copyWith(
                                            color: ColorsManager.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<UserDetailsCubit>()
                                          .deleteDeal(dealId: deal.id);
                                      Navigator.pop(dialogContext);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorsManager.errorLight,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      LocaleKeys.deleteDeal,
                                      style: theme.textTheme.labelLarge!
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  MyIcons.trash,
                  color: ColorsManager.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  context.pushRoute(
                    EditDealRoute(
                      userDetailsCubit: context.read<UserDetailsCubit>(),
                      deal: deal,
                      dealIndex: index,
                    ),
                  );
                },
                child: const Icon(
                  MyIcons.editsolid,
                  color: ColorsManager.primaryColor,
                  size: 18,
                ),
              ),
            ],
          ),
          const CustomDivider(),
          const SizedBox(height: 10),
          Text(
            deal.description,
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.primaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
