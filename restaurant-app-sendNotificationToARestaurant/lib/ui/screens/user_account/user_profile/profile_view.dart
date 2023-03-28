// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.router.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/profile_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/input_masks.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/appbar_loader.dart';
import 'package:restaurant_app/ui/widgets/uielements/centered_scrollable_child.dart';
import 'package:restaurant_app/ui/widgets/uielements/dashboard_item.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';

class ProfileView extends StatelessWidget {
  final FocusNode firstnameFocusNode = FocusNode();
  final FocusNode lastnameFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) {
        model.fetchUserData();
      },
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Mon compte',
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
            actions: [
              if (model.isBusy) AppbarLoader(),
              if (!model.isBusy)
                IconButton(
                    icon: model.editMode
                        ? Icon(Icons.save_outlined)
                        : Icon(Icons.edit_outlined),
                    onPressed: () {
                      if (model.editMode) {
                        if ((_formKey.currentState!.validate()))
                          model.saveChanges();
                      } else
                        model.activateEditMode();
                    })
            ],
          ),
          backgroundColor: Colors.white,
          body: CenteredScrollableChild(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    verticalSpaceMedium,
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                              onTap: () {
                                model.pickProfilePicture();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[100],
                                backgroundImage: CachedNetworkImageProvider(
                                    model.profilePicture!),
                                radius: 80,
                              )),
                          if (!model.busy(model.profilePicture))
                            Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    size: 40,
                                  ),
                                  color: primaryColor,
                                  onPressed: () {
                                    model.pickProfilePicture();
                                  },
                                )),
                          if (model.busy(model.profilePicture))
                            Positioned(
                              right: 0,
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                            )
                        ],
                      ),
                    ),
                    verticalSpaceLarge,
                    InputField(
                        placeholder: 'Prénom',
                        controller: model.firstnameController,
                        autofocus: model.editMode,
                        fieldFocusNode: firstnameFocusNode,
                        nextFocusNode: lastnameFocusNode,
                        enabled: model.editMode),
                    InputField(
                      placeholder: 'Nom de famille',
                      controller: model.lastnameController,
                      fieldFocusNode: lastnameFocusNode,
                      nextFocusNode: usernameFocusNode,
                      enabled: model.editMode,
                    ),
                    InputField(
                      placeholder: "Nom d'utilisateur",
                      controller: model.usernameController,
                      fieldFocusNode: usernameFocusNode,
                      nextFocusNode: mobileFocusNode,
                      enabled: model.editMode,
                    ),
                    verticalSpaceSmall,
                    InputField(
                      label: 'Mobile',
                      placeholder: ' Votre numéro de téléphone',
                      prefix: '+224 ',
                      controller: model.phoneController,
                      fieldFocusNode: mobileFocusNode,
                      formatters: [phoneNumberMaskFormatter],
                      validator: phoneValidator,
                      enabled: model.editMode,
                    ),
                    verticalSpaceSmall,
                    InputField(
                      placeholder: 'Email',
                      controller: model.emailController,
                      isReadOnly: true,
                    ),
                    verticalSpaceSmall,
                    DashboardItem(
                        onTap: () {
                          navigationService
                              .navigateTo(Routes.adressesListScreen);
                        },
                        text: 'Mes Adresses',
                        icon: Icons.home_outlined),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
