import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/lanuch_utils.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_details_model.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/contractor_info_cubit/contractor_info_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/service_details/expandable_text_widget.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<
      ContractorInfoCubit,
      ContractorInfoState,
      ContractorDetailsModel
    >(
      selector: (state) {
        return state.contractorDetails;
      },
      builder: (context, contractorDetails) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                LocaleKeys.hintAboutCompany,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const CustomDivider(),
              ExpandableTextWidget(
                text: contractorDetails.description,
                color: ColorsManager.accentTextColor,
              ),
              const SizedBox(height: 16),
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
              InkWell(
                onTap: () {
                  LaunchUtils.email(
                    email: contractorDetails.email,
                    onError: (msg) =>
                        showToast(message: msg, state: ToastStates.error),
                  );
                },
                child: Text(
                  contractorDetails.email,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blueAccent,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              contractorDetails.address.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          LocaleKeys.address,
                          style: theme.textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: ColorsManager.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    )
                  : const SizedBox.shrink(),

              contractorDetails.address.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          contractorDetails.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: ColorsManager.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
              contractorDetails.phone.isNotEmpty
                  ? Text(
                      LocaleKeys.phoneNumber,
                      style: theme.textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: ColorsManager.textColor,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
              Text(
                contractorDetails.phone,
                textDirection: TextDirection.ltr,
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
              contractorDetails.whatsapp.isNotEmpty
                  ? Text(
                      contractorDetails.whatsapp,
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  contractorDetails.facebook.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            LaunchUtils.open(
                              url: contractorDetails.facebook,
                              onError: (msg) {
                                showToast(
                                  message: msg,
                                  state: ToastStates.warning,
                                );
                              },
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: ColorsManager.primaryColor,
                            child: Icon(
                              MyIcons.facebook,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  contractorDetails.twitter.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            LaunchUtils.open(
                              url: contractorDetails.twitter,
                              onError: (msg) {
                                showToast(
                                  message: msg,
                                  state: ToastStates.warning,
                                );
                              },
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: ColorsManager.primaryColor,
                            child: Icon(
                              MyIcons.twitter,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  contractorDetails.instagram.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            LaunchUtils.open(
                              url: contractorDetails.instagram,
                              onError: (msg) {
                                showToast(
                                  message: msg,
                                  state: ToastStates.warning,
                                );
                              },
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: ColorsManager.primaryColor,
                            child: Icon(
                              MyIcons.instagram,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  contractorDetails.spanchat.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            LaunchUtils.open(
                              url: contractorDetails.spanchat,
                              onError: (msg) {
                                showToast(
                                  message: msg,
                                  state: ToastStates.warning,
                                );
                              },
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: ColorsManager.primaryColor,
                            child: Icon(
                              MyIcons.snapchat,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
