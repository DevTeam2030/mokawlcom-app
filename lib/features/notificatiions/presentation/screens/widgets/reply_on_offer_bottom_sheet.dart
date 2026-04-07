import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/price_offer_upload_file_section.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/offer_details_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/offer_details_state.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/reply_on_price_offer_upload_section.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class ReplyOnOfferBottomSheet extends StatefulWidget {
  const ReplyOnOfferBottomSheet({super.key, required this.address, required this.offerId});
  final String address;
  final String offerId;

  @override
  State<ReplyOnOfferBottomSheet> createState() =>
      _ReplyOnOfferBottomSheetState();
}

class _ReplyOnOfferBottomSheetState extends State<ReplyOnOfferBottomSheet> {
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
    return Padding(
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
                onSubmit: (_) => _submit(context),
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
              const ReplyOnPriceOfferUploadFileSection(),
              const SizedBox(height: 30),
              BlocConsumer<OfferDetailsCubit, OfferDetailsState>(
                listenWhen: (previous, current) =>
                    previous.replayOnOfferPriceState != current.replayOnOfferPriceState,
                buildWhen: (previous, current) =>
                    previous.replayOnOfferPriceState != current.replayOnOfferPriceState,
                listener: (context, state) {
                  if (state.replayOnOfferPriceState.isError) {
                    showDialog(
                      context: context,
                      builder: (context) => ErrorDialog(
                        theme: theme,
                        message: state.replayOnOfferPriceMessage,
                      ),
                    );
                  }
                  if (state.replayOnOfferPriceState.isSuccess) {
                    showDialog(
                      context: context,
                      builder: (context) => SuccessDialog(
                        onPressed: () => Navigator.pop(context),
                        text: LocaleKeys.close,
                        theme: theme,
                        message: state.replayOnOfferPriceMessage,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    isLoading: state.replayOnOfferPriceState.isLoading,
                    onPressed: () async {
                      await _submit(context);
                    },
                    text: LocaleKeys.send,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<OfferDetailsCubit>().replyOnOfferPrice(
        price: _price,
        title: _title,
        message: _message,
        offerId: widget.offerId,
       
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
