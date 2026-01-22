import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_details_model.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/contractor_info_cubit/contractor_info_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/service_item.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ContractorDetailsTopSection extends StatelessWidget {
  const ContractorDetailsTopSection({
    super.key,
    required this.contractorDetailsModel,
    required this.theme,
  });
  final ContractorDetailsModel contractorDetailsModel;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 44.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ColorsManager.secondaryColor, width: .5),
      ),
      child: Column(
        children: [
          Skeleton.replace(
            replacement: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ColorsManager.skeletonColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Container(
              width: 48,
              height: 48,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorsManager.secondaryColor,
                  width: .5,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CustomCachedNetworkImage(
                  imageUrl: contractorDetailsModel.logo,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Text(
                contractorDetailsModel.companyName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              contractorDetailsModel.address.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.green,
                        ),
                        Text(
                          contractorDetailsModel.address,
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
                  : const SizedBox.shrink(),
            ],
          ),
          const CustomDivider(thickness: 0.5),
          Skeleton.replace(
            replacement: Container(
              alignment: AlignmentDirectional.center,
              width: 50,
              height: 38,
              decoration: BoxDecoration(
                color: ColorsManager.skeletonColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: FittedBox(
              child: Container(
                alignment: AlignmentDirectional.center,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                height: 38,
                decoration: BoxDecoration(
                  color: ColorsManager.lightBlueBg,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: ColorsManager.borderLightBlue,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  contractorDetailsModel.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: ColorsManager.labelColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 46,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ServiceItem(
                service: contractorDetailsModel.classifications[index],
                theme: theme,
              ),
              separatorBuilder: (_, _) => const SizedBox(width: 13),
              itemCount: contractorDetailsModel.classifications.length,
            ),
          ),
          const SizedBox(height: 16),
          BlocConsumer<ContractorInfoCubit, ContractorInfoState>(
            listenWhen: (prev, curr) =>
                prev.rateContractorState != curr.rateContractorState,
            buildWhen: (previous, current) =>
                previous.rateContractorState != current.rateContractorState ||
                previous.rating != current.rating,
            listener: (context, state) {
              if (state.rateContractorState.isError) {
                showToast(
                  message: state.errorMessage,
                  state: ToastStates.error,
                );
              }
            },
            builder: (context, state) {
              return Skeleton.replace(
                replacement: Row(
                  mainAxisAlignment: .center,
                  children: List.generate(
                    5,
                    (index) =>
                        Icon(MyIcons.star, color: ColorsManager.skeletonColor),
                  ),
                ),
                child: GestureDetector(
                  onTap: AppConstants.userType == UserType.visitor
                      ? () {
                          context.read<AppCubit>().handleProtectedNavigation(
                            context: context,
                            onAllowed: () {},
                          );
                        }
                      : null,
                  child: RatingBar.builder(
                    initialRating: state.rating,
                     unratedColor: ColorsManager.borderLightBlue,
                    ignoreGestures: AppConstants.userType == UserType.visitor,
                    itemSize: 24,
                    itemBuilder: (context, index) {
                      return const Icon(MyIcons.star, color: Colors.amber);
                    },
                    onRatingUpdate: (rating) {
                      context.read<AppCubit>().handleProtectedNavigation(
                        context: context,
                        onAllowed: () {
                          context.read<ContractorInfoCubit>().rateContractor(
                            contractorId: contractorDetailsModel.id,
                            rating: rating,
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
