import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';

@RoutePage()
class TermsAndConditionsScreen extends StatefulWidget implements AutoRouteWrapper {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: this,
    );
  }
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.termsAndConditions,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryColor,
              ),
        ),
      ),
      body: Center(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (previous, current) =>
              previous.getSettingsRequestStatus != current.getSettingsRequestStatus ||
              previous.settingsModel != current.settingsModel,
          builder: (context, state) => state.isConnected
              ? UiStateBuilder(
                  state: state.getSettingsRequestStatus,
                  onLoading: const CircularProgressIndicator(
                    color: ColorsManager.primaryColor,
                  ),
                  onSuccess: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.all(16),
                    child: Text(
                      state.settingsModel.termsAndConditions,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  errorMessage: state.errorMessage,
                  theme: Theme.of(context),
                )
              : NoInternetWidget(
                  errorMessage: state.errorMessage,
                  theme: Theme.of(context),
                  onPressed: () => context.read<ProfileCubit>().getSettings(),
                ),
        ),
      ),
    );
  }
}