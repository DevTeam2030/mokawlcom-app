import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/data/models/edit_contractor_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class EditContractorForm extends StatefulWidget {
  const EditContractorForm({
    super.key,
    required this.classificationId,
    required this.serviceIds,
  });
  final int classificationId;
  final List<int> serviceIds;

  @override
  State<EditContractorForm> createState() => _EditContractorFormState();
}

class _EditContractorFormState extends State<EditContractorForm> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autoValidatorMode;
  late TextEditingController _phoneController;
  late TextEditingController _whatsAppController;
  String? facebook;
  String? twitter;
  String? snapChat;
  String? address;
  String hintAboutComany = "";
  String name = "";
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autoValidatorMode = AutovalidateMode.disabled;
    _phoneController = TextEditingController();
    _whatsAppController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
            hintText: LocaleKeys.pleaseEnterYourName,
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.name,
            onSaved: (value) => name = value!,
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
            onChanged: (completeNumber, countryCode) {
              _phoneController.text = completeNumber;
            },
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
            validator: (_) => null,
            onChanged: (completeNumber, countryCode) {
              _whatsAppController.text = completeNumber;
            },
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
            onSaved: (value) => address = value!,
            validator: (_) => null,
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
            onSaved: (value) => snapChat = value!,
            validator: (_) => null,
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
            onSaved: (value) => twitter = value!,
            validator: (_) => null,
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
            onSaved: (value) => facebook = value!,
            validator: (_) => null,
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
            onSaved: (value) => hintAboutComany = value!,
            onSubmit: (_) => _onSubmit(context),
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
          name: name.trim(),
          phone: _phoneController.text.replaceAll(" ", ""),
          whatsapp: _whatsAppController.text.replaceAll(" ", ""),
          address: address?.trim(),
          spanchat: snapChat?.trim(),
          twitter: twitter?.trim(),
          facebook: facebook?.trim(),
          hintAboutCompany: hintAboutComany.trim(),
        ),
      );
    } else {
      setState(() {
        _autoValidatorMode = AutovalidateMode.always;
      });
    }
  }
}
