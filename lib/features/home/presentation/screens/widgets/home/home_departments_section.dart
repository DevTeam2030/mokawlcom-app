import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/classification_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeDepartmentsSection extends StatefulWidget {
  const HomeDepartmentsSection({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<HomeDepartmentsSection> createState() => _HomeDepartmentsSectionState();
}

class _HomeDepartmentsSectionState extends State<HomeDepartmentsSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      context.read<HomeCubit>().loadMoreClassifications();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.getClassificationsState != current.getClassificationsState,
      builder: (context, state) => UiStateBuilder(
        theme: widget.theme,
        state: state.getClassificationsState,
        errorMessage: state.classificationsErrorMessage,
        onLoading: Skeletonizer(
          child: _buildGrid(
            context,
            List.generate(
              6,
              (i) => ClassificationModel(
                id: i,
                name: '******',
                image: '',
                number: i,
              ),
            ),
            isLoadingMore: true,
          ),
        ),
        onSuccess: _buildGrid(
          context,
          state.classificationsModel.classifications,
          isLoadingMore: state.getClassificationsState.isLoading,
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<ClassificationModel> classifications, {
    required bool isLoadingMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Text(
            LocaleKeys.departments,
            style: widget.theme.textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.grayText,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          key: const PageStorageKey("Departments"),
          controller: _scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
            crossAxisSpacing: 30,
            childAspectRatio: 0.78,
          ),
          itemCount: classifications.length + (isLoadingMore ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= classifications.length) {
              return Container(
                decoration: BoxDecoration(
                  color: ColorsManager.skeletonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }

            return ClassificationItem(
              theme: widget.theme,
              classificationModel: classifications[index],
              onTap: () {
                context.pushRoute(
                  ServicesRoute(title: classifications[index].name),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
