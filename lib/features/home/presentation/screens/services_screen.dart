import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/service_grid_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/classification_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.title});
  final String title;
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<HomeCubit>().getServices();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      context.read<HomeCubit>().loadMoreServices();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.services,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 18),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 16.0),
                child: Text(
                  widget.title,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.grayText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocConsumer<HomeCubit, HomeState>(
              listenWhen: (previous, current) =>
                  previous.getServicesState != current.getServicesState,
              buildWhen: (previous, current) =>
                  previous.getServicesState != current.getServicesState,
              listener: (context, state) {
                if (state.getServicesState.isError) {
                  showToast(
                    message: state.servicesErrorMessage,
                    state: ToastStates.error,
                  );
                }
              },
              builder: (context, state) => UiStateBuilder(
                theme: theme,
                state: state.getServicesState,
                errorMessage: state.servicesErrorMessage,
                onLoading: Expanded(
                  child: Skeletonizer(
                    child: _buildServices(
                      theme: theme,
                      services: List.generate(
                        6,
                        (index) => ServiceModel(
                          id: index,
                          name: '******',
                          image: '',
                          number: index,
                        ),
                      ),
                    ),
                  ),
                ),
                onSuccess: Expanded(
                  child: _buildServices(
                    theme: theme,
                    services: state.servicesModel.services,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView _buildServices({
    required ThemeData theme,
    required List<ServiceModel> services,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      key: const PageStorageKey("Services"),
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 20,
        childAspectRatio: 0.78,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ServiceGridItem(
          theme: theme,
          serviceModel: services[index],
          onTap: () {
            context.pushRoute( JobOffersRoute(
              classification: widget.title,
              service: services[index].name,
            ));
          },
        );
      },
    );
  }
}
