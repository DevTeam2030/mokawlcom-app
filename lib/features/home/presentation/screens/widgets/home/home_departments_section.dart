import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/classification_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeDepartmentsSection extends StatelessWidget {
  const HomeDepartmentsSection({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.getClassificationsState != current.getClassificationsState,
      builder: (context, state) => UiStateBuilder(
        state: state.getClassificationsState,
        onLoading: Skeletonizer(
          child: _buildHomeDepartments(
            context: context,
            classifications: List.generate(
              6,
              (index) => ClassificationModel(
                id: index,
                name: "******",
                image: "",
                number: index,
              ),
            ),
          ),
        ),
        onSuccess: _buildHomeDepartments(
          context: context,
          classifications: state.classifications,
        ),
        errorMessage: state.classificationsErrorMessage,
        theme: theme,
      ),
    );
  }

  Column _buildHomeDepartments({
    required BuildContext context,
    required List<ClassificationModel> classifications,
  }) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16.0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              LocaleKeys.departments,
              style: theme.textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.grayText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 30,
          runSpacing: 24,
          children: List.generate(
            classifications.length,
            (index) => ClassificationItem(
              onTap: () {
                context.pushRoute(const ServicesRoute());
              },
              theme: theme,
              classificationModel: classifications[index],
            ),
          ),
        ),
      ],
    );
  }
}
