import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class SendOfferToContractorsScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const SendOfferToContractorsScreen({
    super.key,
    required this.userDetailsCubit,
  });
  final UserDetailsCubit userDetailsCubit;

  @override
  State<SendOfferToContractorsScreen> createState() =>
      _SendOfferToContractorsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: userDetailsCubit, child: this);
  }
}

class _SendOfferToContractorsScreenState
    extends State<SendOfferToContractorsScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autoValidateMode;
  String title = '';
  String description = '';
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autoValidateMode = AutovalidateMode.disabled;
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.sendOfferToContractors,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 32,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.shareYourDealNow,
                  style: theme.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  LocaleKeys.offerAddress,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  type: TextInputType.text,
                  hintText: "",
                  fieldName: LocaleKeys.offerAddress,
                  onSaved: (value) => title = value!,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.offerDetails,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  textInputAction: TextInputAction.done,
                  type: TextInputType.multiline,
                  maxLines: 20,
                  hintText: "",
                  fieldName: LocaleKeys.offerDetails,
                  onSaved: (value) => description = value!,
                  onSubmit: (_) => _submit(),
                ),
                const SizedBox(height: 72),
                BlocConsumer<UserDetailsCubit, UserDetailsState>(
                  listenWhen: (previous, current) =>
                      previous.addDealState != current.addDealState,
                  listener: (context, state) {
                    if (state.addDealState.isError) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          theme: theme,
                          message: state.errorMessage,
                        ),
                      );
                    }
                    if (state.addDealState.isSuccess) {
                      showDialog(
                        context: context,
                        builder: (context) => SuccessDialog(
                          theme: theme,
                          message: state.successMessage,
                          onPressed: () => context.pop(),
                          text: LocaleKeys.back,
                        ),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.addDealState != current.addDealState,
                  builder: (context, state) {
                    return PrimaryButton(
                      onPressed: _submit,
                      text: LocaleKeys.save,
                      isLoading: state.addDealState.isLoading,
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.userDetailsCubit.addDeal(
        title: title,
        description: description,
      );
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }
}
