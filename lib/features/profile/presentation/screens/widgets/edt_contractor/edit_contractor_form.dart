import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/data/models/edit_contractor_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class EditContractorForm extends StatefulWidget {
  const EditContractorForm({
    super.key,
    required this.classificationId,
    required this.serviceIds,
    required this.userModel,
  });
  final int classificationId;
  final List<int> serviceIds;
  final UserModel userModel;

  @override
  State<EditContractorForm> createState() => _EditContractorFormState();
}

class _EditContractorFormState extends State<EditContractorForm> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autoValidatorMode;
  late TextEditingController _phoneController;
  late TextEditingController _whatsAppController;
  late TextEditingController _addressController;
  late TextEditingController _snapChatController;
  late TextEditingController _twitterController;
  late TextEditingController _facebookController;
  late TextEditingController _nameController;
  late TextEditingController _hintAboutCompanyController;
  String _phone = "";
  String _whatsapp = "";

  @override
  void initState() {
    super.initState();
    _phone = widget.userModel.phone;
    _whatsapp = widget.userModel.whatsapp;
    _formKey = GlobalKey<FormState>();
    _autoValidatorMode = AutovalidateMode.disabled;
    _phoneController = TextEditingController(text: widget.userModel.phone);
    _whatsAppController = TextEditingController(text: widget.userModel.phone);
    _addressController = TextEditingController(text: widget.userModel.address);
    _snapChatController = TextEditingController(
      text: widget.userModel.snapchat,
    );
    _twitterController = TextEditingController(text: widget.userModel.twitter);
    _facebookController = TextEditingController(
      text: widget.userModel.facabook,
    );
    _nameController = TextEditingController(text: widget.userModel.name);
    _hintAboutCompanyController = TextEditingController(
      text: widget.userModel.hintAboutComppany,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _whatsAppController.dispose();
    _addressController.dispose();
    _snapChatController.dispose();
    _twitterController.dispose();
    _facebookController.dispose();
    _nameController.dispose();
    _hintAboutCompanyController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PhoneNumber? phone;

    if (widget.userModel.phone.isNotEmpty &&
        widget.userModel.phone.startsWith('+')) {
      phone = PhoneNumber.fromCompleteNumber(
        completeNumber: widget.userModel.phone,
      );
    }

    PhoneNumber? whatsapp;

    if (widget.userModel.whatsapp.isNotEmpty &&
        widget.userModel.whatsapp.startsWith('+')) {
      whatsapp = PhoneNumber.fromCompleteNumber(
        completeNumber: widget.userModel.whatsapp,
      );
    }
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidatorMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.name,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.name,
            controller: _nameController,
            hintText: LocaleKeys.pleaseEnterYourName,
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.name,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.phone,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomIntlPhoneField(
            initialCountryCode: phone?.countryISOCode??"QA",
            onChanged: (completeNumber, countryCode) {
              _phone = completeNumber;
            },
            controller: _phoneController,
          ),

          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.whatsApp,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomIntlPhoneField(
            initialCountryCode: whatsapp?.countryISOCode??"QA",
            validator: (_) => null,
            onChanged: (completeNumber, countryCode) {
              _whatsapp = completeNumber;
            },
            controller: _whatsAppController,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.address,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.streetAddress,
            hintText: "الخليج الغربي - الدوحة",
            autofillHints: const [AutofillHints.addressCityAndState],
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.address,
            validator: (_) => null,
            controller: _addressController,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.socialMedia,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.snapchat,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
            hintText: "@snap_user",
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.snapchat,
            validator: (_) => null,
            controller: _snapChatController,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.twitter,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
            hintText: "@username",
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.twitter,
            validator: (_) => null,
            controller: _twitterController,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.facebook,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
            hintText: "https://www.facebook.com/username",
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.facebook,
            validator: (_) => null,
            controller: _facebookController,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.hintAboutCompany,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.multiline,
            maxLines: 10,
            textInputAction: TextInputAction.done,
            fieldName: LocaleKeys.hintAboutCompany,
            validator: (_) => null,
            controller: _hintAboutCompanyController,
          ),
          const SizedBox(height: 40.0),
          BlocConsumer<ProfileCubit, ProfileState>(
            listenWhen: (previous, current) =>
                previous.updateUserProfileRequestStatus !=
                current.updateUserProfileRequestStatus,
            buildWhen: (previous, current) =>
                previous.updateUserProfileRequestStatus !=
                current.updateUserProfileRequestStatus,
            listener: (context, state) {
              if (state.updateUserProfileRequestStatus.isError) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(message: state.errorMessage, theme: theme),
                );
              }
              if (state.updateUserProfileRequestStatus.isSuccess) {
                showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(
                    message: state.successMessage,
                    theme: theme,
                    onPressed: () => context.pop(),
                    text: LocaleKeys.close,
                  ),
                );
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                isLoading: state.updateUserProfileRequestStatus.isLoading,
                onPressed: () {
                  _onSubmit(context);
                },
                text: LocaleKeys.save,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<ProfileCubit>().editContractorProfile(
        editContractorProfileRequestModel: EditContractorProfileRequestModel(
          classificationId: widget.classificationId,
          serviceIds: widget.serviceIds,
          name: _nameController.text.trim(),
          phone: _phone.replaceAll(" ", ""),
          whatsapp: _whatsapp.replaceAll(" ", ""),
          address: _addressController.text.trim(),
          spanchat: _snapChatController.text.trim(),
          twitter: _twitterController.text.trim(),
          facebook: _facebookController.text.trim(),
          hintAboutCompany: _hintAboutCompanyController.text.trim(),
        ),
      );
    } else {
      setState(() {
        _autoValidatorMode = AutovalidateMode.always;
      });
    }
  }
}
