import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/services/services_list_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late final ValueNotifier<Set<int>> selectedIndices;

  @override
  void initState() {
    super.initState();
    selectedIndices = ValueNotifier<Set<int>>(<int>{});
  }

  @override
  void dispose() {
    selectedIndices.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    final current = Set<int>.from(selectedIndices.value);

    if (current.contains(index)) {
      current.remove(index);
    } else {
      current.add(index);
    }

    selectedIndices.value = current;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50.0),
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                LocaleKeys.registerNewContractor,
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              LocaleKeys.chooseServices,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: ValueListenableBuilder<Set<int>>(
                valueListenable: selectedIndices,
                builder: (context, value, _) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                    itemBuilder: (context, index) => ServicesListItem(
                      theme: theme,
                      isSelected: value.contains(index),
                      onTap: () => _toggleSelection(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            PrimaryButton(onPressed: () {}, text: LocaleKeys.next),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
