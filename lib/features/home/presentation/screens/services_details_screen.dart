import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/service_details/service_details_list_item.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/contractor_info_cubit/contractor_info_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ServicesDetailsScreen extends StatelessWidget {
  const ServicesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<
      ContractorInfoCubit,
      ContractorInfoState,
      List<ContractorServiceModel>
    >(
      selector: (state) {
        return state.contractorDetails.services;
      },
      builder: (context, contractorServices) {
        return contractorServices.isNotEmpty
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ServiceDetailsListItem(
                  theme: theme,
                  contractorServiceModel: contractorServices[index],
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemCount: contractorServices.length,
              )
            : NoDataWidget(text: LocaleKeys.noServicesYet, theme: theme);
      },
    );
  }
}
