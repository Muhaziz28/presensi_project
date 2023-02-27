import 'package:get/get.dart';

import '../controllers/add_istri_controller.dart';

class AddIstriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddIstriController>(
      () => AddIstriController(),
    );
  }
}
