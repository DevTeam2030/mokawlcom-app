import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/core/utils/lanuch_utils.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';

@RoutePage()
class ConnectUsScreen extends StatefulWidget implements AutoRouteWrapper {
  const ConnectUsScreen({super.key});

  @override
  State<ConnectUsScreen> createState() => _ConnectUsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: this,
    );
  }
}

class _ConnectUsScreenState extends State<ConnectUsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getSettings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.connectUs,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) =>
                previous.getSettingsRequestStatus !=
                    current.getSettingsRequestStatus ||
                previous.settingsModel != current.settingsModel,
            builder: (context, state) => state.isConnected
                ? UiStateBuilder(
                    state: state.getSettingsRequestStatus,
                    onLoading: const CircularProgressIndicator(
                      color: ColorsManager.primaryColor,
                    ),
                    onSuccess: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 100,
                            color: ColorsManager.primaryColor,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            state.settingsModel.email,
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 48),
                          PrimaryButton(
                            onPressed: () {
                              if (state.settingsModel.email.isNotEmpty) {
                                LaunchUtils.email(
                                  email: state.settingsModel.email,
                                  onError: (msg) => showDialog(
                                    context: context,
                                    builder: (context) => ErrorDialog(
                                      message: msg,
                                      buttonText: LocaleKeys.exit,
                                      theme: theme,
                                    ),
                                  ),
                                );
                              }
                            },
                            text: LocaleKeys.connectUs,
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    errorMessage: state.errorMessage,
                    theme: theme,
                  )
                : NoInternetWidget(
                    errorMessage: state.errorMessage,
                    theme: theme,
                    onPressed: () => context.read<ProfileCubit>().getSettings(),
                  ),
          ),
        ),
      ),
    );
  }
}
