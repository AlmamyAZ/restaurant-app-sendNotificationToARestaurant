// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import 'package:restaurant_app/ui/shared/input_masks.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/uielements/appbar_loader.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/centered_scrollable_child.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';

class AdressFormScreen extends StatelessWidget {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode districtFocusNode = FocusNode();
  final FocusNode zoneFocusNode = FocusNode();
  final FocusNode moreDetailsFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return ViewModelBuilder<AdressesViewModel>.reactive(
      onModelReady: (model) {
        model.initialiseMapForm(initialisationData: arguments);
      },
      viewModelBuilder: () => AdressesViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Informations de l\'adresse',
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
            actions: [
              if (!arguments['newAdress'])
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    model.activateEditMode();
                  },
                ),
              if (!arguments['newAdress'] && !model.isBusy)
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    model.deleteAdressById();
                  },
                ),
              if (!arguments['newAdress'] && model.isBusy) AppbarLoader()
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
                    Container(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          rotateGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          zoomControlsEnabled: false,

                          // markers:
                          markers: model.markers,
                          initialCameraPosition: CameraPosition(
                            target: model.initialPosition,
                            zoom: 15,
                          ),
                          onMapCreated: model.onMapCreated,
                        ),
                      ),
                    ),
                    verticalSpaceMedium,
                    InputField(
                        placeholder: "Nommez l'adresse",
                        controller: model.nameController,
                        validator: codeValidator,
                        autofocus: true,
                        fieldFocusNode: nameFocusNode,
                        nextFocusNode: zoneFocusNode,
                        enabled: model.editMode),
                    verticalSpaceSmall,
                    InputField(
                        placeholder: 'Quartier, zone',
                        controller: model.zoneController,
                        validator: codeValidator,
                        fieldFocusNode: zoneFocusNode,
                        nextFocusNode: districtFocusNode,
                        enabled: model.editMode),
                    verticalSpaceSmall,
                    GestureDetector(
                      onTap: () {
                        if (model.editMode) model.showDistricts(context, model);
                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: InputField(
                            placeholder: 'Commune',
                            validator: codeValidator,
                            controller: model.districtController,
                            fieldFocusNode: districtFocusNode,
                            nextFocusNode: moreDetailsFocusNode,
                            enabled: model.editMode),
                      ),
                    ),
                    verticalSpaceSmall,
                    InputField(
                        placeholder: 'Autre indications...',
                        controller: model.descriptionController,
                        fieldFocusNode: moreDetailsFocusNode,
                        nextFocusNode: phoneFocusNode,
                        enabled: model.editMode),
                    verticalSpaceSmall,
                    InputField(
                        label: 'Mobile',
                        placeholder: ' Votre numero de telephone',
                        prefix: '+224 ',
                        controller: model.phoneController,
                        validator: phoneValidator,
                        textInputType: TextInputType.phone,
                        formatters: [phoneNumberMaskFormatter],
                        fieldFocusNode: phoneFocusNode,
                        enabled: model.editMode),
                    verticalSpaceMedium,
                    if (model.editMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BusyButton(
                            title: 'Enregistrer',
                            busy: model.isBusy,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                arguments['newAdress']
                                    ? model.createAdress()
                                    : model.editAdress();
                              }
                            },
                          )
                        ],
                      ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
