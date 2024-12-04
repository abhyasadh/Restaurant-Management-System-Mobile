import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';

final gifControllerProvider = Provider<OrdersGifController>((ref) {
  return OrdersGifController();
});

class OrdersGifController {
  GifController controller = GifController();

  OrdersGifController() {
    controller.addListener(() {
      if (controller.currentIndex == 30) {
        controller.pause();
      }
    });
  }
}
