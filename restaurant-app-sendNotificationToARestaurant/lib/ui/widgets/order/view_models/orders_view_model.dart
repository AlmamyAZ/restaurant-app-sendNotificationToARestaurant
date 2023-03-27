import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/order.dart';
import 'package:stacked/stacked.dart';

const String _terminateStreamKey = 'terminated';
const String _incomingStreamKey = 'incoming';

class OrdersViewModel extends MultipleStreamViewModel {
  Order? _selectedOrder;
  Order? get selectedOrder => _selectedOrder;

  set selectedOrder(Order? value) {
    _selectedOrder = value;
    notifyListeners();
  }

  // List<Order>? _ordersTerminated;
  List<Order> get ordersTerminated {
    return dataMap![_terminateStreamKey] ?? [];
  }

  // List<Order>? _ordersIncoming;
  List<Order> get ordersIncoming {
    return dataMap![_incomingStreamKey] ?? [];
  }

  @override
  Map<String, StreamData> get streamsMap => {
        _terminateStreamKey:
            StreamData<List<Order>>(orderService.getTerminatedOrders()),
        _incomingStreamKey:
            StreamData<List<Order>>(orderService.getIncomingOrders()),
      };

  void navigateToOrderDetails({required bool completed, required Order order}) {
    if (completed) {
      navigationService.navigateTo(Routes.orderDetailsScreen, arguments: order);
    } else {
      navigationService.navigateTo(Routes.orderStatusScreen,
          arguments: order.id);
    }
  }

  double getTotal() {
    if (selectedOrder == null) return 0;
    return selectedOrder!.products!.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.quantity! * element.price!));
  }

  @override
  void dispose() {
    print('view model Account disposed');
    super.dispose();
  }
}
