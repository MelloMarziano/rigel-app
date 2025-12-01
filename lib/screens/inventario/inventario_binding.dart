import 'package:get/get.dart';

import 'inventario_controller.dart';

class InventarioBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;
    final categoriaId = args?['categoriaId'] as String? ?? '';
    final inventarioId = args?['inventarioId'] as String?;
    Get.lazyPut<InventarioController>(() =>
        InventarioController(categoriaId: categoriaId, inventarioId: inventarioId));
  }
}
