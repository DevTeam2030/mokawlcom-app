import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class CustomDropdownField<T> extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => _openBottomSheet(context, theme),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorsManager.fillColor,
          labelText: label,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(20),
          hintStyle: theme.textTheme.labelLarge!.copyWith(
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
        child: _buildDisplayText(theme),
      ),
    );
  }

  Widget _buildDisplayText(ThemeData theme) {
    if (multiSelect) {
      return Text(
        hintText ?? '',
        style: theme.textTheme.labelLarge!.copyWith(
          color: ColorsManager.secondaryColor,
        ),
      );
    } else {
      if (value == null) {
        return Text(
          hintText ?? '',
          style: theme.textTheme.labelLarge!.copyWith(
            color: ColorsManager.secondaryColor,
          ),
        );
      }
      return items.firstWhere((e) => e.value == value).child;
    }
  }

  void _openBottomSheet(BuildContext context, ThemeData theme) {
    if (multiSelect) {
      _openMultiSelectSheet(context, theme);
    } else {
      _openSingleSelectSheet(context, theme);
    }
  }

  void _openMultiSelectSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: _MultiSelectSheet<T>(
            items: items,
            selectedValues: selectedValues ?? [],
            theme: theme,
            label: label,
            hintText: hintText,
            onMultiChanged: onMultiChanged,
            onLoadMore: onLoadMore,
            isLoadingMore: isLoadingMore,
            hasMoreData: hasMoreData,
          ),
        );
      },
    );
  }

  void _openSingleSelectSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  _sheetHandle(),

                  if (label != null || hintText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        label ?? hintText!,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: items.length + (isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 24,
                        endIndent: 24,
                        color: ColorsManager.dividerGray,
                      ),
                      itemBuilder: (_, index) {
                        if (index == items.length && isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  color: ColorsManager.primaryColor,
                                ),
                              ),
                            ),
                          );
                        }

                        final item = items[index];
                        final selected = item.value == value;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                          title: DefaultTextStyle(
                            style: theme.textTheme.bodyMedium!.copyWith(
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
                            onChanged?.call(item.value);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sheetHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _MultiSelectSheet<T> extends StatefulWidget {
  const _MultiSelectSheet({
    required this.items,
    required this.selectedValues,
    required this.theme,
    this.label,
    this.hintText,
    required this.onMultiChanged,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMoreData = false,
  });

  final List<DropdownMenuItem<T>> items;
  final List<T> selectedValues;
  final ThemeData theme;
  final String? label;
  final String? hintText;
  final void Function(List<T>)? onMultiChanged;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMoreData;

  @override
  State<_MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<_MultiSelectSheet<T>> {
  late List<T> tempSelected;
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    tempSelected = List<T>.from(widget.selectedValues);
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients || !widget.hasMoreData) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      widget.onLoadMore?.call();
    }
  }

  void _resetLoading() {
    if (_isLoadingMore && !widget.isLoadingMore) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void didUpdateWidget(_MultiSelectSheet<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoadingMore != widget.isLoadingMore) {
      _resetLoading();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 24,
                endIndent: 24,
                color: ColorsManager.dividerGray,
              ),
              itemBuilder: (_, index) {
                if (index == widget.items.length && widget.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          color: ColorsManager.primaryColor,
                        ),
                      ),
                    ),
                  );
                }

                final item = widget.items[index];
                final selected = tempSelected.any((v) => v == item.value);

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
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
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
                  onTap: () {
                    setState(() {
                      if (selected) {
                        tempSelected.removeWhere((v) => v == item.value);
                      } else {
                        if (item.value != null) {
                          tempSelected.add(item.value as T);
                        }
                      }
                    });
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
                  widget.onMultiChanged?.call(tempSelected);
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
                  'Done',
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

  Widget _sheetHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
