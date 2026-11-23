import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/classification_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCustomer = context.select(
      (AppCubit cubit) => cubit.state.userType == UserType.user,
    );

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
              classifications: List.generate(
                6,
                (i) => ClassificationModel(
                  id: i,
                  name: '******',
                  image: '',
                  numberOfServices: i,
                ),
              ),
              status: state.getClassificationsState,
              showRequestQuote: isCustomer,
            ),
          ),
          onSuccess: _buildGrid(
            context,
            classifications: state.classificationsModel.classifications,
            status: state.getClassificationsState,
            showRequestQuote: isCustomer,
          ),
          onError: hasData
              ? _buildGrid(
                  context,
                  classifications: state.classificationsModel.classifications,
                  status: state.getClassificationsState,
                  showRequestQuote: isCustomer,
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
    required bool showRequestQuote,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 14,
              crossAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            itemCount:
                classifications.length +
                (showRequestQuote ? 1 : 0) +
                (status.isLoadingMore ? 2 : 0),
            itemBuilder: (context, index) {
              final categoryOffset = showRequestQuote ? 1 : 0;
              final categoryItemCount = classifications.length + categoryOffset;
              if (index >= categoryItemCount && status.isLoadingMore) {
                return Container(
                  decoration: BoxDecoration(
                    color: ColorsManager.skeletonColor,
                    shape: BoxShape.circle,
                  ),
                );
              }

              if (showRequestQuote && index == 0) {
                return ClassificationItem(
                  theme: widget.theme,
                  classificationModel: const ClassificationModel(
                    id: 0,
                    name: '',
                    image: '',
                    numberOfServices: 0,
                  ),
                  assetImage: 'assets/images/request_quote.png',
                  label: LocaleKeys.requestQuote,
                  showServiceCount: false,
                  onTap: () => context.pushRoute(const CustomerDealsRoute()),
                );
              }

              final classification = classifications[index - categoryOffset];

              return ClassificationItem(
                theme: widget.theme,
                classificationModel: classification,
                onTap: () {
                  context.pushRoute(
                    ServicesRoute(classificationModel: classification),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
