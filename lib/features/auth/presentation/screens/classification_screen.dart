import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/classification/classification_list_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  late final ValueNotifier<int> activeIndex;

  @override
  void initState() {
    super.initState();
    activeIndex = ValueNotifier<int>(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getSettings();
    });
  }

  @override
  void dispose() {
    activeIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: Text(
          LocaleKeys.registerNewContractor,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) =>
              previous.getSettingsState != current.getSettingsState,
          builder: (context, state) => UiStateBuilder(
            state: state.getSettingsState,
            theme: theme,
            isConnected: state.isConnected,
            errorMessage: state.errorMessage,
            onPressed: () async {
              await context.read<AuthCubit>().getSettings();
            },
            onLoading: const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primaryColor,
              ),
            ),
            onSuccess: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.chooseClassification,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<int>(
                  valueListenable: activeIndex,
                  builder: (context, value, _) {
                    return Expanded(
                      child: ListView.separated(
                        itemCount:
                            state.settingsResultModel.classifications.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16.0),
                        itemBuilder: (context, index) => ClassificationListItem(
                          theme: theme,
                          settingsModel:
                              state.settingsResultModel.classifications[index],
                          isSelected: index == value,
                          onTap: () {
                            activeIndex.value = index;
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                PrimaryButton(
                  onPressed: () {
                    context.pushRoute(
                      SelectServicesRoute(
                        classificationId: state
                            .settingsResultModel
                            .classifications[activeIndex.value]
                            .id,
                      ),
                    );
                  },
                  text: LocaleKeys.next,
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
