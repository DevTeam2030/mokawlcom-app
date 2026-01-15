import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            child: BlocSelector<ProfileCubit, ProfileState, File?>(
              selector: (state) {
                return state.profileImage;
              },
              builder: (context, image) {
                return CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  backgroundImage: image == null
                      ? const AssetImage(AssetsManager.userImage)
                      : FileImage(image),
                );
              },
            ),
          ),
          Positioned(
            bottom: -2,
            right: -4,
            child: InkWell(
              onTap: () async {
                await context.read<ProfileCubit>().changeProfileImage();
              },
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
