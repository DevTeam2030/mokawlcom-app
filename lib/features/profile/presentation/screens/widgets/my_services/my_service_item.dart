import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/lanuch_utils.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class MyServiceItem extends StatelessWidget {
  const MyServiceItem({
    super.key,
    required this.theme,
    required this.service,
    required this.index,
  });
  final ThemeData theme;
  final ContractorServiceModel service;
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
                  service.title,
                  style: theme.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => context.read<UserDetailsCubit>().deleteService(
                  serviceId: service.id,
                  index: index,
                ),
                child: const Icon(
                  MyIcons.trash,
                  color: ColorsManager.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () => context.pushRoute(
                  EditServiceRoute(
                    theme: theme,
                    service: service,
                    userDetailsCubit: context.read<UserDetailsCubit>(),
                    serviceIndex: index,
                  ),
                ),
                child: const Icon(
                  MyIcons.editsolid,
                  color: ColorsManager.primaryColor,
                  size: 18,
                ),
              ),
            ],
          ),
          const CustomDivider(),
          Text(
            "${LocaleKeys.priceAverage} : ${service.price}",
            style: theme.textTheme.labelSmall!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            service.description,
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.primaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 10,
            children: List<Widget>.generate(service.images.length, (index) {
              return InkWell(
                onTap: () {
                  LaunchUtils.open(
                    url: service.images[index],
                    onError: (msg) {
                      showToast(message: msg, state: ToastStates.error);
                    },
                  );
                },
                child: const Icon(
                  Icons.image_outlined,
                  size: 35,
                  color: ColorsManager.primaryColor,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
