import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  String title = 'Perfil';
  Map<String, dynamic>? user;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    final raw = box.read('user');
    if (raw is Map) {
      user = Map<String, dynamic>.from(raw);
    } else {
      user = null;
    }
    update();
  }

  Future<void> logout() async {
    final box = GetStorage();
    await box.remove('user');
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
