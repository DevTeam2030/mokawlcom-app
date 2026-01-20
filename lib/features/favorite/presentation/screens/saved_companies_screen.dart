import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_cubit.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_state.dart';
import 'package:mokawlcom_app/features/favorite/presentation/screens/saved_company_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';

@RoutePage()
class SavedCompaniesScreen extends StatefulWidget {
  const SavedCompaniesScreen({super.key});

  @override
  State<SavedCompaniesScreen> createState() => _SavedCompaniesScreenState();
}

class _SavedCompaniesScreenState extends State<SavedCompaniesScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<FavoriteCubit>();

    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      cubit.loadMoreFavorites();
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.savedCompanies,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: BlocConsumer<FavoriteCubit, FavoriteState>(
        listenWhen: (prev, curr) =>
            prev.getFavoritesState != curr.getFavoritesState ||
            prev.removeFavoriteState != curr.removeFavoriteState,
        buildWhen: (prev, curr) =>
            prev.getFavoritesState != curr.getFavoritesState ||
            prev.favorites != curr.favorites,
        listener: (context, state) {
          if (state.getFavoritesState.isError) {
            showToast(message: state.errorMessage, state: ToastStates.error);
          }
          if (state.removeFavoriteState.isError) {
            showToast(message: state.errorMessage, state: ToastStates.error);
          }
        },
        builder: (context, state) {
          final hasData = state.favorites.isNotEmpty;

          if (!state.isConnected && !hasData) {
            return NoInternetWidget(
              errorMessage: state.errorMessage,
              theme: theme,
              onPressed: () => context.read<FavoriteCubit>().getFavorites(),
            );
          }

          return UiStateBuilder(
            state: state.getFavoritesState,
            theme: theme,
            errorMessage: state.errorMessage,
            onLoading: Skeletonizer(
              enabled: state.getFavoritesState.isLoading && !hasData,
              child: _buildList(
                theme,
                hasData
                    ? state.favorites.values.toList()
                    : List.generate(
                        6,
                        (index) => FavoriteModel(
                          id: index,
                          contractorId: 0,
                          companyName: '',
                          address: '',
                          logo: '',
                          rate: 0,
                        ),
                      ),
                state.getFavoritesState,
              ),
            ),
            onSuccess: state.favorites.isNotEmpty
                ? _buildList(
                    theme,
                    state.favorites.values.toList(),
                    state.getFavoritesState,
                  )
                : NoDataWidget(text: LocaleKeys.noSavedCompanies, theme: theme),
            onError: state.favorites.isNotEmpty
                ? _buildList(
                    theme,
                    state.favorites.values.toList(),
                    state.getFavoritesState,
                  )
                : NoDataWidget(text: LocaleKeys.noSavedCompanies, theme: theme),
          );
        },
      ),
    );
  }

  Widget _buildList(
    ThemeData theme,
    List<FavoriteModel> favorites,
    RequestStatus status,
  ) {
    _resetLoading(status);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: favorites.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == favorites.length) {
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

                return SavedCompanyItem(
                  theme: theme,
                  favoriteModel: favorites[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
