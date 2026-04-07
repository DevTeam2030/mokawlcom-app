import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/contractor_info_cubit/contractor_info_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/price_offer_upload_file_section.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class OfferPriceBottomSheet extends StatefulWidget {
  const OfferPriceBottomSheet({
    super.key,
    required this.address,
    required this.contractorId,
    required this.contractorInfoCubit,
  });
  final String address;
  final int contractorId;
  final ContractorInfoCubit contractorInfoCubit;

  @override
  State<OfferPriceBottomSheet> createState() => _OfferPriceBottomSheetState();
}

class _OfferPriceBottomSheetState extends State<OfferPriceBottomSheet> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  String _price = "";
  String _title = "";
  String _message = "";

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: widget.contractorInfoCubit,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
          bottom: 32,
          top: 10,
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    widget.address,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.offerAddress,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  type: TextInputType.text,
                  fieldName: LocaleKeys.offerAddress,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.price,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  type: TextInputType.number,
                  fieldName: LocaleKeys.price,
                  isPrice: true,
                  onSaved: (value) => _price = value!,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.message,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  textInputAction: TextInputAction.done,
                  type: TextInputType.text,
                  maxLines: 5,
                  fieldName: LocaleKeys.message,
                  onSaved: (value) => _message = value!,
                  onSubmit: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.attachAFile,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                PriceOfferUploadFileSection(theme: theme),
                const SizedBox(height: 24),
                BlocConsumer<ContractorInfoCubit, ContractorInfoState>(
                  listenWhen: (previous, current) =>
                      previous.addOfferPriceState != current.addOfferPriceState,
                  buildWhen: (previous, current) =>
                      previous.addOfferPriceState != current.addOfferPriceState,
                  listener: (context, state) {
                    if (state.addOfferPriceState.isError) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          theme: theme,
                          message: state.addOfferPriceMessage,
                        ),
                      );
                    }
                    if (state.addOfferPriceState.isSuccess) {
                      showDialog(
                        context: context,
                        builder: (context) => SuccessDialog(
                          onPressed: () => Navigator.pop(context),
                          text: LocaleKeys.close,
                          theme: theme,
                          message: state.addOfferPriceMessage,
                        ),
                      );
                      context.read<NotificationsCubit>().getUserOffers();
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      isLoading: state.addOfferPriceState.isLoading && state.file ==null,
                      onPressed: () async {
                        await _submit();
                      },
                      text: LocaleKeys.send,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await widget.contractorInfoCubit.addOfferPrice(
        title: _title,
        price: _price,
        message: _message,
        contractorId: widget.contractorId,
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
