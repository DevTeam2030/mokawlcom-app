import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

@RoutePage()
class MyCurrentPackageScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const MyCurrentPackageScreen({super.key, required this.profileCubit});
  final ProfileCubit profileCubit;

  @override
  State<MyCurrentPackageScreen> createState() => _MyCurrentPackageScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: profileCubit, child: this);
  }
}

class _MyCurrentPackageScreenState extends State<MyCurrentPackageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.myCurrentPackage,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            previous.getPlanRequestStatus != current.getPlanRequestStatus,
        builder: (context, state) => UiStateBuilder(
          state: state.getPlanRequestStatus,
          onLoading: const Center(
            child: CircularProgressIndicator(color: ColorsManager.primaryColor),
          ),
          onSuccess: Container(
            margin: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 50,
            ),
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: ColorsManager.borderLightBlue),
              borderRadius: BorderRadius.circular(8),
              color: ColorsManager.surfaceColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage(
                    AssetsManager.subscriptionPackageImageWithoutBackground,
                  ),
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 13),
                Text(
                  LocaleKeys.youAreNowSubscribedToTheFreePackage,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${LocaleKeys.subscriptionDate} : ${state.planModel.startDate}",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.labelColor,
                  ),
                ),
                const CustomDivider(),
                Text(
                  "${LocaleKeys.packageIsValidFor} : ${state.planModel.numberOfMonths} ${LocaleKeys.months}",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.labelColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  LocaleKeys.expireAt,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  state.planModel.endDate,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          errorMessage: state.errorMessage,
          theme: theme,
        ),
      ),
    );
  }
}
