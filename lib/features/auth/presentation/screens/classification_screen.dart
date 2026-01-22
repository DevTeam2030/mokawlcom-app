import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/classification/classification_list_item.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  late final ValueNotifier<int> activeIndex;
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    activeIndex = ValueNotifier<int>(-1);
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getClassifications();
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      context.read<AuthCubit>().loadMoreClassifications();
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
    activeIndex.dispose();
    _scrollController.dispose();
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
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (p, c) =>
            p.getClassificationsState != c.getClassificationsState,
        listener: (context, state) {
          if (state.getClassificationsState.isError) {
            showDialog(
              context: context,
              builder: (context) =>
                  ErrorDialog(theme: theme, message: state.errorMessage),
            );
          }
        },
        builder: (context, state) {
          final hasData = state.classificationsModel.classifications.isNotEmpty;

          if (!state.isConnected && !hasData) {
            return NoInternetWidget(
              errorMessage: state.errorMessage,
              theme: theme,
              onPressed: () => context.read<AuthCubit>().getClassifications(),
            );
          }

          return UiStateBuilder(
            state: state.getClassificationsState,
            theme: theme,
            errorMessage: state.errorMessage,
            onLoading: Skeletonizer(
              containersColor: ColorsManager.skeletonColor,
              enabled: state.getClassificationsState.isLoading && !hasData,
              child: _buildList(
                theme,
                hasData
                    ? state.classificationsModel.classifications
                    : List.generate(
                        6,
                        (i) => ClassificationModel(
                          id: i,
                          name: 'Loading',
                          image: '',
                          numberOfServices: i,
                        ),
                      ),
                state.getClassificationsState,
              ),
            ),
            onSuccess: _buildList(
              theme,
              state.classificationsModel.classifications,
              state.getClassificationsState,
            ),
            onError: _buildList(
              theme,
              state.classificationsModel.classifications,
              state.getClassificationsState,
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(
    ThemeData theme,
    List<ClassificationModel> classifications,
    RequestStatus status,
  ) {
    _resetLoading(status);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.chooseClassification),
          const SizedBox(height: 20),
          ValueListenableBuilder<int>(
            valueListenable: activeIndex,
            builder: (_, value, __) {
              return Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: classifications.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == classifications.length) {
                      if (status == RequestStatus.loadingMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }

                    return ClassificationListItem(
                      theme: theme,
                      classificationModel: classifications[index],
                      isSelected: index == value,
                      onTap: () => activeIndex.value = index,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            onPressed: () {
              if (activeIndex.value == -1) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    theme: theme,
                    message: LocaleKeys.pleaseSelectClassification,
                  ),
                );
                return;
              }
              context.pushRoute(
                SelectServicesRoute(
                  classificationId: classifications[activeIndex.value].id,
                ),
              );
            },
            text: LocaleKeys.next,
          ),
        ],
      ),
    );
  }
}
