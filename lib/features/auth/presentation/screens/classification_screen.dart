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

  @override
  void initState() {
    super.initState();
    activeIndex = ValueNotifier<int>(0);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AuthCubit>().getClassesifications();
    });

    _scrollController.addListener(() {
      final cubit = context.read<AuthCubit>();
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll > 0 && currentScroll / maxScroll >= 0.7) {
        cubit.loadMoreClassesifications();
      }
    });
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
        listenWhen: (previous, current) =>
            previous.getClassificationsState != current.getClassificationsState,
        listener: (context, state) {
          if (state.getClassificationsState.isError) {
            showToast(message: state.errorMessage, state: ToastStates.error);
          }
        },
        buildWhen: (previous, current) =>
            previous.getClassificationsState != current.getClassificationsState,
        builder: (context, state) => state.isConnected
            ? UiStateBuilder(
                state: state.getClassificationsState,
                theme: theme,
                errorMessage: state.errorMessage,
                onLoading: Skeletonizer(
                  child: _buildClassifications(
                    theme: theme,
                    classifications: List.generate(
                      6,
                      (index) => ClassificationModel(
                        id: index,
                        name: 'Loading...',
                        image: '',
                        number: index,
                      ),
                    ),
                    context: context,
                  ),
                ),
                onSuccess: _buildClassifications(
                  theme: theme,
                  classifications: state.classificationsModel.classifications,
                  context: context,
                ),
                onError: _buildClassifications(
                  theme: theme,
                  classifications: state.classificationsModel.classifications,
                  context: context,
                ),
              )
            : NoInternetWidget(
                errorMessage: state.errorMessage,
                theme: theme,
                onPressed: () async {
                  await context.read<AuthCubit>().getClassesifications();
                },
              ),
      ),
    );
  }

  Padding _buildClassifications({
    required ThemeData theme,
    required List<ClassificationModel> classifications,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(20.0),
      child: Column(
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
                  key: const PageStorageKey("classifications"),
                  controller: _scrollController,
                  itemCount: classifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    return ClassificationListItem(
                      theme: theme,
                      classificationModel: classifications[index],
                      isSelected: index == value,
                      onTap: () {
                        activeIndex.value = index;
                      },
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 10.0),
          PrimaryButton(
            onPressed: () {
              context.pushRoute(
                SelectServicesRoute(
                  classificationId: classifications[activeIndex.value].id,
                ),
              );
            },
            text: LocaleKeys.next,
          ),
          const SizedBox(height: 40.0),
        ],
      ),
    );
  }
}
