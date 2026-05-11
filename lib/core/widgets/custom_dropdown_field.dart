import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

Widget _sheetHandle() => Container(
  width: 40,
  height: 4,
  margin: const EdgeInsets.only(bottom: 16),
  decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(2),
  ),
);

Widget _loadingMoreIndicator() => const Padding(
  padding: EdgeInsets.symmetric(vertical: 16),
  child: Center(
    child: SizedBox(
      width: 26,
      height: 26,
      child: CircularProgressIndicator(color: ColorsManager.primaryColor),
    ),
  ),
);

// ---------------------------------------------------------------------------
// CustomDropdownField
// ---------------------------------------------------------------------------

class CustomDropdownField<T> extends StatefulWidget {
  const CustomDropdownField({
    super.key,
    this.value,
    required this.items,
    this.hintText,
    this.label,
    this.onChanged,
    required this.theme,
    this.onTap,
    this.multiSelect = false,
    this.selectedValues,
    this.onMultiChanged,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMoreData = false,
    this.readOnly = false,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? hintText;
  final String? label;
  final void Function(T?)? onChanged;
  final ThemeData theme;
  final void Function()? onTap;
  final bool multiSelect;
  final List<T>? selectedValues;
  final void Function(List<T>)? onMultiChanged;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMoreData;
  final bool readOnly;

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  late final ValueNotifier<List<DropdownMenuItem<T>>> _itemsNotifier;
  late final ValueNotifier<bool> _isLoadingMoreNotifier;
  late final ValueNotifier<bool> _hasMoreDataNotifier;

  @override
  void initState() {
    super.initState();
    _itemsNotifier = ValueNotifier(widget.items);
    _isLoadingMoreNotifier = ValueNotifier(widget.isLoadingMore);
    _hasMoreDataNotifier = ValueNotifier(widget.hasMoreData);
  }

  @override
  void didUpdateWidget(CustomDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Capture values now; defer the assignment so it never fires during build.
    final items = widget.items;
    final loadingMore = widget.isLoadingMore;
    final hasMore = widget.hasMoreData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _itemsNotifier.value = items;
      _isLoadingMoreNotifier.value = loadingMore;
      _hasMoreDataNotifier.value = hasMore;
    });
  }

  @override
  void dispose() {
    _itemsNotifier.dispose();
    _isLoadingMoreNotifier.dispose();
    _hasMoreDataNotifier.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.readOnly
          ? null
          : (widget.onTap ?? () => _openSheet(context)),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorsManager.fillColor,
          labelText: widget.label,
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.all(20),
          hintStyle: widget.theme.textTheme.labelLarge!.copyWith(
            color: ColorsManager.secondaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorsManager.secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: ColorsManager.primaryColor,
              width: 2,
            ),
          ),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: ColorsManager.secondaryColor,
          ),
        ),
        child: _buildDisplayText(),
      ),
    );
  }

  Widget _buildDisplayText() {
    final theme = widget.theme;
    final hintStyle = theme.textTheme.labelLarge!.copyWith(
      color: ColorsManager.secondaryColor,
    );

    if (widget.multiSelect || widget.value == null || widget.items.isEmpty) {
      return Text(widget.hintText ?? '', style: hintStyle);
    }

    final matched = widget.items.firstWhere(
      (e) => e.value == widget.value,
      orElse: () => DropdownMenuItem<T>(
        value: widget.value,
        child: Text(widget.hintText ?? '', style: hintStyle),
      ),
    );
    return matched.child;
  }

  // ── Sheet launchers ────────────────────────────────────────────────────────

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => widget.multiSelect
          ? FractionallySizedBox(
              heightFactor: 0.85,
              child: _MultiSelectSheet<T>(
                itemsNotifier: _itemsNotifier,
                isLoadingMoreNotifier: _isLoadingMoreNotifier,
                hasMoreDataNotifier: _hasMoreDataNotifier,
                selectedValues: widget.selectedValues ?? [],
                theme: widget.theme,
                label: widget.label,
                hintText: widget.hintText,
                onMultiChanged: widget.onMultiChanged,
                onLoadMore: widget.onLoadMore,
              ),
            )
          : _SingleSelectSheet<T>(
              itemsNotifier: _itemsNotifier,
              isLoadingMoreNotifier: _isLoadingMoreNotifier,
              hasMoreDataNotifier: _hasMoreDataNotifier,
              value: widget.value,
              theme: widget.theme,
              label: widget.label,
              hintText: widget.hintText,
              onChanged: widget.onChanged,
              onLoadMore: widget.onLoadMore,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared scroll-pagination mixin
// ---------------------------------------------------------------------------

mixin _PaginationMixin<W extends StatefulWidget> on State<W> {
  late final ScrollController scrollController;
  bool _isLoadingMore = false;

  ValueNotifier<bool> get isLoadingMoreNotifier;
  ValueNotifier<bool> get hasMoreDataNotifier;
  VoidCallback? get onLoadMore;

  void initPagination() {
    scrollController = ScrollController()..addListener(_onScroll);
    isLoadingMoreNotifier.addListener(_onLoadingMoreChanged);
  }

  void disposePagination() {
    scrollController.dispose();
    isLoadingMoreNotifier.removeListener(_onLoadingMoreChanged);
  }

  void _onScroll() {
    if (_isLoadingMore ||
        !scrollController.hasClients ||
        !hasMoreDataNotifier.value) {
      return;
    }

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      onLoadMore?.call();
    }
  }

  void _onLoadingMoreChanged() {
    if (_isLoadingMore && !isLoadingMoreNotifier.value) {
      setState(() => _isLoadingMore = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Single-select sheet
// ---------------------------------------------------------------------------

class _SingleSelectSheet<T> extends StatefulWidget {
  const _SingleSelectSheet({
    required this.itemsNotifier,
    required this.isLoadingMoreNotifier,
    required this.hasMoreDataNotifier,
    this.value,
    required this.theme,
    this.label,
    this.hintText,
    this.onChanged,
    this.onLoadMore,
  });

  final ValueNotifier<List<DropdownMenuItem<T>>> itemsNotifier;
  final ValueNotifier<bool> isLoadingMoreNotifier;
  final ValueNotifier<bool> hasMoreDataNotifier;
  final T? value;
  final ThemeData theme;
  final String? label;
  final String? hintText;
  final void Function(T?)? onChanged;
  final VoidCallback? onLoadMore;

  @override
  State<_SingleSelectSheet<T>> createState() => _SingleSelectSheetState<T>();
}

class _SingleSelectSheetState<T> extends State<_SingleSelectSheet<T>>
    with _PaginationMixin<_SingleSelectSheet<T>> {
  @override
  ValueNotifier<bool> get isLoadingMoreNotifier => widget.isLoadingMoreNotifier;
  @override
  ValueNotifier<bool> get hasMoreDataNotifier => widget.hasMoreDataNotifier;
  @override
  VoidCallback? get onLoadMore => widget.onLoadMore;

  @override
  void initState() {
    super.initState();
    initPagination();
  }

  @override
  void dispose() {
    disposePagination();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, _) => SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _sheetHandle(),
            if (widget.label != null || widget.hintText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  widget.label ?? widget.hintText!,
                  style: widget.theme.textTheme.titleMedium!.copyWith(
                    color: ColorsManager.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  widget.itemsNotifier,
                  widget.isLoadingMoreNotifier,
                ]),
                builder: (_, _) {
                  final items = widget.itemsNotifier.value;
                  final isLoadingMore = widget.isLoadingMoreNotifier.value;
                  return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: items.length + (isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      indent: 24,
                      endIndent: 24,
                      color: ColorsManager.dividerGray,
                    ),
                    itemBuilder: (_, index) {
                      if (index == items.length) return _loadingMoreIndicator();

                      final item = items[index];
                      final selected = item.value == widget.value;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 4,
                        ),
                        title: DefaultTextStyle(
                          style: widget.theme.textTheme.bodyMedium!.copyWith(
                            color: selected
                                ? ColorsManager.primaryColor
                                : Colors.black87,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          child: item.child,
                        ),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle,
                                color: ColorsManager.primaryColor,
                              )
                            : null,
                        onTap: () {
                          widget.onChanged?.call(item.value);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Multi-select sheet
// ---------------------------------------------------------------------------

class _MultiSelectSheet<T> extends StatefulWidget {
  const _MultiSelectSheet({
    required this.itemsNotifier,
    required this.isLoadingMoreNotifier,
    required this.hasMoreDataNotifier,
    required this.selectedValues,
    required this.theme,
    this.label,
    this.hintText,
    this.onMultiChanged,
    this.onLoadMore,
  });

  final ValueNotifier<List<DropdownMenuItem<T>>> itemsNotifier;
  final ValueNotifier<bool> isLoadingMoreNotifier;
  final ValueNotifier<bool> hasMoreDataNotifier;
  final List<T> selectedValues;
  final ThemeData theme;
  final String? label;
  final String? hintText;
  final void Function(List<T>)? onMultiChanged;
  final VoidCallback? onLoadMore;

  @override
  State<_MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<_MultiSelectSheet<T>>
    with _PaginationMixin<_MultiSelectSheet<T>> {
  late List<T> _tempSelected;

  @override
  ValueNotifier<bool> get isLoadingMoreNotifier => widget.isLoadingMoreNotifier;
  @override
  ValueNotifier<bool> get hasMoreDataNotifier => widget.hasMoreDataNotifier;
  @override
  VoidCallback? get onLoadMore => widget.onLoadMore;

  @override
  void initState() {
    super.initState();
    _tempSelected = List<T>.from(widget.selectedValues);
    initPagination();
  }

  @override
  void dispose() {
    disposePagination();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _sheetHandle(),
          if (widget.label != null || widget.hintText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                widget.label ?? widget.hintText!,
                style: widget.theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: ListenableBuilder(
              listenable: Listenable.merge([
                widget.itemsNotifier,
                widget.isLoadingMoreNotifier,
              ]),
              builder: (_, _) {
                final items = widget.itemsNotifier.value;
                final isLoadingMore = widget.isLoadingMoreNotifier.value;
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: items.length + (isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    indent: 24,
                    endIndent: 24,
                    color: ColorsManager.dividerGray,
                  ),
                  itemBuilder: (_, index) {
                    if (index == items.length) return _loadingMoreIndicator();

                    final item = items[index];
                    final selected = _tempSelected.any((v) => v == item.value);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      title: DefaultTextStyle(
                        style: widget.theme.textTheme.bodyMedium!.copyWith(
                          color: selected
                              ? ColorsManager.primaryColor
                              : Colors.black87,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        child: item.child,
                      ),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color: ColorsManager.primaryColor,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              color: Colors.grey,
                            ),
                      onTap: () => setState(() {
                        if (selected) {
                          _tempSelected.removeWhere((v) => v == item.value);
                        } else if (item.value != null) {
                          _tempSelected.add(item.value as T);
                        }
                      }),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onMultiChanged?.call(_tempSelected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleKeys.done,
                  style: widget.theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
