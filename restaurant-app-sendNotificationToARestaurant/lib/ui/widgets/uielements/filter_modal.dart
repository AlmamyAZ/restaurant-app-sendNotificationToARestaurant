// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_list_view_model.dart';

List<String> filters = [
  "Recommandés (par défaut)",
  "Distance",
  "Note",
  "Nobre d'avis",
];

class FilterModal extends StatelessWidget {
  final AllRestaurantsViewModel model;
  FilterModal({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Trier par: ',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    // Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          filters[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        Radio(
                            value: index,
                            groupValue: model.selectedFilter,
                            onChanged: (value) {
                              model.setSelectedFilter(value);
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: filters.length,
            ),
          ),
        ],
      ),
    );
  }
}
