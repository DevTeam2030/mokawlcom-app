import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

@RoutePage()
class EditDealScreen extends StatefulWidget implements AutoRouteWrapper {
  const EditDealScreen({
    super.key,
    required this.userDetailsCubit,
    required this.deal,
    required this.dealIndex,
  });
  
  final UserDetailsCubit userDetailsCubit;
  final DealModel deal;
  final int dealIndex;

  @override
  State<EditDealScreen> createState() => _EditDealScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: userDetailsCubit, child: this);
  }
}

class _EditDealScreenState extends State<EditDealScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autoValidateMode;
  
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autoValidateMode = AutovalidateMode.disabled;
    
    _titleController = TextEditingController(text: widget.deal.title);
    _descriptionController = TextEditingController(text: widget.deal.description);
    

  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.editDeal,
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
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  type: TextInputType.text,
                  hintText: "",
                  fieldName: LocaleKeys.offerAddress,
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
                  controller: _descriptionController,
                  textInputAction: TextInputAction.done,
                  type: TextInputType.multiline,
                  maxLines: 20,
                  hintText: "",
                  fieldName: LocaleKeys.offerDetails,
                  onSubmit: (_) => _submit(),
                ),
                const SizedBox(height: 72),
                BlocConsumer<UserDetailsCubit, UserDetailsState>(
                  listenWhen: (previous, current) =>
                      previous.editDealState != current.editDealState,
                  listener: (context, state) {
                    if (state.editDealState.isError) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          theme: theme,
                          message: state.errorMessage,
                        ),
                      );
                    }
                    if (state.editDealState.isSuccess) {
                      showDialog(
                        context: context,
                        builder: (context) => SuccessDialog(
                          theme: theme,
                          message: state.successMessage,
                          onPressed: () {
                            context.pop();
                          },
                          text: LocaleKeys.back,
                        ),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.editDealState != current.editDealState,
                  builder: (context, state) {
                    return PrimaryButton(
                      onPressed: _submit,
                      text: LocaleKeys.editDeal,
                      isLoading: state.editDealState.isLoading,
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
      widget.userDetailsCubit.editDeal(
        dealId: widget.deal.id,
        index: widget.dealIndex,
        title: _titleController.text,
        description: _descriptionController.text,
      );
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }
}
