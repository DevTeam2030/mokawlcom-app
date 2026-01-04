import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/services/services_list_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class SelectServicesScreen extends StatefulWidget {
  const SelectServicesScreen({super.key, required this.classificationId});
  final int classificationId;
  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  late final ValueNotifier<Set<int>> selectedIndices;

  @override
  void initState() {
    super.initState();
    selectedIndices = ValueNotifier<Set<int>>(<int>{});
  }

  @override
  void dispose() {
    selectedIndices.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    final current = Set<int>.from(selectedIndices.value);

    if (current.contains(index)) {
      current.remove(index);
    } else {
      current.add(index);
    }

    selectedIndices.value = current;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
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
        child: BlocSelector<AuthCubit, AuthState, List<SettingsModel>>(
          selector: (state) {
            return state.settingsResultModel.services;
          },
          builder: (context, services) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.chooseServices,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20.0),
                ValueListenableBuilder<Set<int>>(
                  valueListenable: selectedIndices,
                  builder: (context, value, _) {
                    return Expanded(
                      child: ListView.separated(
                        itemCount: services.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16.0),
                        itemBuilder: (context, index) => ServicesListItem(
                          theme: theme,
                          isSelected: value.contains(index),
                          service: services[index],
                          onTap: () => _toggleSelection(index),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                PrimaryButton(
                  onPressed: () {
                    context.read<AuthCubit>().saveSettings(
                      classificiationId: widget.classificationId,
                      services: selectedIndices.value
                          .map((e) => services[e].id)
                          .toList(),
                    );
                    context.pushRoute(const ContractorSignupRoute());
                  },
                  text: LocaleKeys.next,
                ),
                const SizedBox(height: 40.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
