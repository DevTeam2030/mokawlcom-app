import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
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
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      _isLoadingMore = true;
      context.read<HomeCubit>().loadMoreClassifications();
    }
  }

  void _resetLoading(RequestStatus status) {
    if (_isLoadingMore &&
        (status == RequestStatus.success || status == RequestStatus.error)) {
      _isLoadingMore = false;
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
      buildWhen: (p, c) =>
          p.getClassificationsState != c.getClassificationsState,
      builder: (context, state) {
        final hasData = state.classificationsModel.classifications.isNotEmpty;

        return UiStateBuilder(
          theme: widget.theme,
          state: state.getClassificationsState,
          errorMessage: state.classificationsErrorMessage,
          onLoading: Skeletonizer(
            containersColor: ColorsManager.skeletonColor,
            enabled: state.getClassificationsState.isLoading && !hasData,
            child: _buildGrid(
              context,
              classifications: hasData
                  ? state.classificationsModel.classifications
                  : List.generate(
                      6,
                      (i) => ClassificationModel(
                        id: i,
                        name: '******',
                        image: '',
                        number: i,
                      ),
                    ),
              status: state.getClassificationsState,
            ),
          ),
          onSuccess: _buildGrid(
            context,
            classifications: state.classificationsModel.classifications,
            status: state.getClassificationsState,
          ),
          onError: hasData
              ? _buildGrid(
                  context,
                  classifications: state.classificationsModel.classifications,
                  status: state.getClassificationsState,
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildGrid(
    BuildContext context, {
    required List<ClassificationModel> classifications,
    required RequestStatus status,
  }) {
    _resetLoading(status);

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
          controller: _scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 20,
            childAspectRatio: 0.78,
          ),
          itemCount: classifications.length + (status.isLoadingMore ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= classifications.length && status.isLoadingMore) {
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
                  ServicesRoute(classificationModel: classifications[index]),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
