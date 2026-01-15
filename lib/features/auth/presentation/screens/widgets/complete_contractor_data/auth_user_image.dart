import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';

class AuthUserImage extends StatelessWidget {
  final VoidCallback? onEditTap;

  const AuthUserImage({super.key, this.onEditTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: ColorsManager.primaryColor,
            child: BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) => previous.logo != current.logo,
              builder: (context, state) {
                return CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  backgroundImage: state.logo != null
                      ? FileImage(state.logo!)
                      : const AssetImage(AssetsManager.userImage),
                );
              },
            ),
          ),
          Positioned(
            bottom: -2,
            right: -4,
            child: InkWell(
              onTap: onEditTap ?? () {},
              child: const CircleAvatar(
                backgroundColor: ColorsManager.primaryColor,
                radius: 16,
                child: Icon(Icons.edit, size: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
