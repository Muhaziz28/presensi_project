import 'package:get/get.dart';

import '../controllers/agama_controller.dart';

class AgamaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgamaController>(
      () => AgamaController(),
    );
  }
}
