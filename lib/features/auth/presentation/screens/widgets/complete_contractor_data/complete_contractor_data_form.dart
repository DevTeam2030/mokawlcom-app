import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class CompleteContractorDataForm extends StatefulWidget {
  const CompleteContractorDataForm({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<CompleteContractorDataForm> createState() =>
      _CompleteContractorDataFormState();
}

class _CompleteContractorDataFormState
    extends State<CompleteContractorDataForm> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late final TextEditingController _phoneController;
  String? whatsApp;
  String? facebook;
  String? twitter;
  String? snapChat;
  String hintAboutComany = "";
  String name = "";
  String _completePhone = '';
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
    _phoneController = TextEditingController(
      text: context.read<AuthCubit>().state.phone,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PhoneNumber? phone;
    if (context.read<AuthCubit>().state.phone.isNotEmpty &&
        context.read<AuthCubit>().state.phone.startsWith('+')) {
      phone = PhoneNumber.fromCompleteNumber(
        completeNumber: context.read<AuthCubit>().state.phone,
      );
    }
    _completePhone = phone?.completeNumber ?? "";
    final theme = widget.theme;
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.name,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.name,
            hintText: LocaleKeys.pleaseEnterYourName,
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.name,
            onSaved: (value) => name = value!,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.phone,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomIntlPhoneField(
            controller: _phoneController,
            initialCountryCode: phone?.countryISOCode ?? "EG",
            onChanged: (completeNumber, countryCode) {
              _completePhone = completeNumber;
            },
            onSubmitted: (_) async => await _submit(context),
            validator: (_) => null,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.whatsApp,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomIntlPhoneField(
            onChanged: (completeNumber, countryCode) {
              whatsApp = completeNumber;
            },
            onSubmitted: (_) async => await _submit(context),
            validator: (_) => null,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.socialMedia,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.snapchat,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
            hintText: "@snap_user",
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.snapchat,
            onSaved: (value) => snapChat = value,
            validator: (_) => null,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.twitter,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
            hintText: "@username",
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.twitter,
            onSaved: (value) => twitter = value,
            validator: (_) => null,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.facebook,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
            hintText: "Profile link",
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.facebook,
            onSaved: (value) => facebook = value,
            validator: (_) => null,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.hintAboutCompany,
            style: theme.textTheme.titleMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
            maxLines: 10,
            textInputAction: TextInputAction.done,
            fieldName: LocaleKeys.hintAboutCompany,
            onSaved: (value) => hintAboutComany = value!,
            onSubmit: (_) async => await _submit(context),
          ),
          const SizedBox(height: 40.0),
          BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.completeContractorDataState !=
                current.completeContractorDataState,
            buildWhen: (previous, current) =>
                previous.completeContractorDataState !=
                current.completeContractorDataState,
            listener: (context, state) async {
              if (state.completeContractorDataState.isError) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(message: state.errorMessage, theme: theme),
                );
              }
              if (state.completeContractorDataState.isSuccess) {
                await showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(
                    message: state.successMessage,
                    text: LocaleKeys.next,
                    theme: theme,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
                if (context.mounted) {
                  context.navigateTo(const LoginRoute());
                }
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                isLoading: state.completeContractorDataState.isLoading,
                onPressed: () async {
                  await _submit(context);
                },
                text: LocaleKeys.save,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthCubit>().completeContractorData(
        name: name,
        phone: _completePhone,
        hintAboutComany: hintAboutComany,
        whatsApp: whatsApp?.replaceAll(" ", ""),
        facebook: facebook?.replaceAll(" ", ""),
        twitter: twitter?.replaceAll(" ", ""),
        snapChat: snapChat?.replaceAll(" ", ""),
      );
    } else {
      setState(() {
        _autovalidateMode = .always;
      });
    }
  }
}
