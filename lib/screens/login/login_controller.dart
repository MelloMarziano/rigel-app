import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  String title = 'Rigel App';
  final email = ''.obs;
  final password = ''.obs;
  bool loading = false;

  void setEmail(String v) {
    email.value = v;
    update();
  }

  void setPassword(String v) {
    password.value = v;
    update();
  }

  Future<void> login() async {
    final e = email.value.trim();
    final p = password.value.trim();
    if (e.isEmpty || p.isEmpty) {
      Get.snackbar('Error', 'Ingrese email y contraseña');
      return;
    }
    loading = true;
    update();
    try {
      final qs = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: e)
          .limit(1)
          .get();
      if (qs.docs.isEmpty) {
        Get.snackbar('Error', 'Credenciales inválidas');
        return;
      }
      final doc = qs.docs.first;
      final data = doc.data();
      final pass = (data['password'] as String?) ?? '';
      if (pass != p) {
        Get.snackbar('Error', 'Credenciales inválidas');
        return;
      }
      final userOut = <String, dynamic>{
        'id': doc.id,
        'email': (data['email'] as String?) ?? '',
        'nombre': (data['nombre'] as String?) ?? '',
        'rol': (data['rol'] as String?) ?? '',
      };
      final box = GetStorage();
      await box.write('user', userOut);
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      if (e is FirebaseException) {
        Get.snackbar('Error', e.message ?? 'Fallo al consultar Firestore');
      } else {
        Get.snackbar('Error', 'No se pudo iniciar sesión');
      }
    } finally {
      loading = false;
      update();
    }
  }
}
