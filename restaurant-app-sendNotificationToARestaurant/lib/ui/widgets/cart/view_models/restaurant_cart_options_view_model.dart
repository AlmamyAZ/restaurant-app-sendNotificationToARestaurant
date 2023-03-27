import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:stacked/stacked.dart';

@injectable
class RestaurantCartOptionsViewModel extends BaseViewModel {
  bool _orderIsDelivery = true;
  bool get orderIsDelivery => _orderIsDelivery;

  OrderTime _orderTime = OrderTime.asap;
  OrderTime get orderTime => _orderTime;

  Map<String, String> _orderDay = {
    'value': 'today',
    'label': 'Ajourd\' hui',
  };
  Map<String, dynamic> get orderDay => _orderDay;

  Map<String, dynamic>? _orderHour;
  Map<String, dynamic>? get orderHour => _orderHour;

  // Form for shceduling the order

  final hourController = TextEditingController();

  final List<Map<String, String>> days = [
    {
      'value': 'today',
      'label': 'Ajourd\' hui',
    },
  ];

  List<Map<String, dynamic>> _hours = [];
  List<Map<String, dynamic>> get hours => _hours;

  List<Map<String, dynamic>> _todayHours = [];
  List<Map<String, dynamic>> get todayHours => _todayHours;

  // List<Map<String, dynamic>> _tomorrowHours = [];
  // List<Map<String, dynamic>> get tomorrowHours => _tomorrowHours;

  // Elements
  int? _orderQuantity;
  int? get orderQuantity => _orderQuantity;

  void setOrderDeliveryState(bool state) {
    _orderIsDelivery = state;
    notifyListeners();
  }

  void setOrderTime(OrderTime orderTime) {
    _orderTime = orderTime;
    resetOrderHour();
    notifyListeners();
  }

  void resetOrderHour() {
    debugPrint("resetOrderHour 😂😂😂😂 :");
    _orderHour = {
      'value': null,
      'label': null,
    };
  }

  void setOrderDay(String orderDay) async {
    setBusy(true);
    int indexDay = days.indexWhere((day) => day['value'] == orderDay);
    _orderDay = days[indexDay];
    resetOrderHour();
    await Future.delayed(Duration(milliseconds: 200));
    setBusy(false);
  }

  void setOrderTimeFrame(String timeFrame) {
    int indexTimeFrame =
        _hours.indexWhere((hour) => hour['value'] == timeFrame);
    _orderHour = _hours[indexTimeFrame];

    notifyListeners();
  }

  void handleOrderTime(DateTime time) {
    print('handleOrderTime $time');
    notifyListeners();
  }

  void handleItemQuantityChange(int unit) {
    if (_orderQuantity! + unit < 0) return;
    _orderQuantity = _orderQuantity! + unit;
    notifyListeners();
  }

  void initialiseModel(RestaurantCartViewModel model) {
    _orderIsDelivery = model.restaurantCart!.isDelivery!;
    _orderTime = model.restaurantCart!.orderTime!;

    _orderHour = {'value': null, 'label': null};
    _orderDay = {
      'value': model.restaurantCart!.orderDeliveryDay == 'Demain'
          ? 'tomorrow'
          : 'today',
      'label': model.restaurantCart!.orderDeliveryDay ?? 'Ajourd\' hui'
    };
    notifyListeners();
  }

  void initialiseModelElement(RestaurantCartViewModel model, Product element) {
    _orderQuantity = element.quantity;
    notifyListeners();
  }

  void getDeliveryHours() {
    if (restaurantService.currentRestaurantOpenHours == null) return;

    List<Map<String, dynamic>> generatedTodayHours = generateDeliveryHours(
        restaurantService.currentRestaurantOpenHours!,
        today: true);

    // List<Map<String, dynamic>> generateTomorrowdHours = generateDeliveryHours(
    //     restaurantService.currentRestaurantOpenHours!,
    //     today: false);

    _hours = _todayHours = generatedTodayHours;
    // _tomorrowHours = generateTomorrowdHours;

    notifyListeners();
  }

  Widget generateTimeselector() {
    _hours = _todayHours;
    return SelectFormField(
      controller: hourController,
      type: SelectFormFieldType.dropdown,
      labelText: 'Heure',
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      items: hours,
      onChanged: (val) {
        setOrderTimeFrame(val);
      },
    );
  }

  @override
  void dispose() {
    print('view model Cart Options disposed');
    super.dispose();
  }
}
