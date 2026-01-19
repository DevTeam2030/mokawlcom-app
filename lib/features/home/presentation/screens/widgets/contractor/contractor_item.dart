import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/lanuch_utils.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_model.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class ContractorItem extends StatelessWidget {
  const ContractorItem({
    super.key,
    required this.contractorModel,
    required this.theme, required this.serviceId,
  });
  final int serviceId;
  final ContractorModel contractorModel;
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ColorsManager.borderLightBlue, width: .8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 16.0,
              end: 8.0,
              top: 8.0,
              bottom: 5.0,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    context.pushRoute(
                      ContractorDetailsRoute(contractorId: contractorModel.id,
                      ),
                    );
                  },
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: const BoxDecoration(
                      color: ColorsManager.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: .antiAliasWithSaveLayer,
                    child: CustomCachedNetworkImage(
                      imageUrl: contractorModel.image,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pushRoute(
                          ContractorDetailsRoute(
                            contractorId: contractorModel.id,
                          ),
                        );
                      },
                      child: Text(
                        contractorModel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    contractorModel.address.isNotEmpty
                        ? Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Colors.green,
                              ),
                              Text(
                                contractorModel.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: ColorsManager.textColor,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: 4),
                    RatingBar.builder(
                      initialRating: contractorModel.rating.toDouble(),
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemSize: 18,
                      itemBuilder: (context, index) {
                        return const Icon(MyIcons.star, color: Colors.amber);
                      },
                      unratedColor: ColorsManager.secondaryColor,
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20,
                  ),
                  height: 26,
                  decoration: BoxDecoration(
                    color: ColorsManager.lightBlueBg,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: ColorsManager.borderLightBlue,
                      width: 1.2,
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      contractorModel.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: ColorsManager.labelColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 17.0),
            child: InkWell(
              onTap: () {
                context.pushRoute(
                  ContractorDetailsRoute(contractorId: contractorModel.id,
                  ),
                );
              },
              child: Text(
                LocaleKeys.hintAboutCompany,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 17.0, end: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contractorModel.description,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    context.pushRoute(
                      ContractorDetailsRoute(contractorId: contractorModel.id, ),
                    );
                  },
                  child: Text(
                    LocaleKeys.showMore,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsetsDirectional.only(
              start: 32.0,
              top: 19,
              bottom: 15,
              end: 18.0,
            ),
            decoration: const BoxDecoration(
              color: ColorsManager.primaryColor,
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(8.0),
                bottomStart: Radius.circular(8.0),
              ),
            ),
            child: Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsetsDirectional.all(10),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    context.read<AppCubit>().handleProtectedNavigation(
                      context: context,
                      onAllowed: () {
                        context.pushRoute(
                          ContractorDetailsRoute(
                            contractorId: contractorModel.id,
                            isOfferPrice: true,
        
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    LocaleKeys.showPrice,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                contractorModel.whatsApp.isNotEmpty
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsetsDirectional.all(10),
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          await LaunchUtils.open(
                            url: contractorModel.whatsApp,
                            onError: (msg) {
                              showToast(
                                message: msg,
                                state: ToastStates.warning,
                              );
                            },
                          );
                        },
                        child: const Icon(
                          MyIcons.whats,
                          color: Colors.green,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 3),
                contractorModel.phone.isNotEmpty
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsetsDirectional.all(10),
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          await LaunchUtils.call(
                            phone: contractorModel.phone,
                            onError: (msg) {
                              showToast(
                                message: msg,
                                state: ToastStates.warning,
                              );
                            },
                          );
                        },
                        child: const Icon(
                          MyIcons.call,
                          color: ColorsManager.primaryColor,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
