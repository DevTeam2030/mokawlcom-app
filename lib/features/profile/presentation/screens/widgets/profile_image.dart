import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
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
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.profileImage != current.profileImage ||
                  previous.userModel.logo != current.userModel.logo,
              builder: (context, state) {
                Widget widget;

                if (state.profileImage != null) {
                  widget = Image.file(state.profileImage!, fit: .cover);
                } else if (state.profileImage == null &&
                    state.userModel.logo.isNotEmpty) {
                  widget = CustomCachedNetworkImage(
                    imageUrl: state.userModel.logo,
                    width: 96,
                    height: 96,
                    fit: .cover,
                  );
                } else {
                  widget = Image.asset(AssetsManager.userImage, fit: .cover);
                }
                return Container(
                  width: 96,
                  height: 96,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: widget,
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
