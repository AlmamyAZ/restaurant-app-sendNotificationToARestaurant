// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/collection/view_models/collections.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';

class AddNewCollection extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var viewinsets = MediaQuery.of(context).viewInsets.bottom;

    return ViewModelBuilder<CollectionModel>.nonReactive(
      viewModelBuilder: () => locator<CollectionModel>(),
      disposeViewModel: false,
      builder: (context, model, child) => AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
        ),
        height: 200 + viewinsets,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Nouvelle collection',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                child: InputField(
                  controller: model.collectionName,
                  validator: codeValidator,
                  placeholder: 'Nommer votre collection',
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    primaryColor,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await model.addUserCollection(true);
                  }
                },
                child: Text(
                  'Ajouter ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
