import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class Categoria {
  final String id;
  final String nombre;
  Categoria({required this.id, required this.nombre});
}

class HomeController extends GetxController {
  final List<Categoria> areas = [];
  String? selectedAreaId;
  String username = 'Usuario';
  bool loading = false;
  bool checkingInventory = false;
  bool? hasActiveInventory;
  String? activeInventoryId;

  bool get canStart => selectedAreaId != null;

  void selectArea(String id) {
    selectedAreaId = id;
    update();
    checkActiveInventory(id);
  }

  void clearSelection() {
    selectedAreaId = null;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    final user = box.read('user') as Map<String, dynamic>?;
    if (user != null) {
      final nombre = user['nombre'] as String?;
      if (nombre != null && nombre.isNotEmpty) {
        username = nombre;
      }
    }
    loadAreas();
  }

  Future<void> loadAreas() async {
    loading = true;
    update();
    final snapshot = await FirebaseFirestore.instance
        .collection('categorias')
        .get();
    areas
      ..clear()
      ..addAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          final nombre = (data['nombre'] as String?) ?? doc.id;
          return Categoria(id: doc.id, nombre: nombre);
        }),
      );
    loading = false;
    update();
  }

  Future<void> checkActiveInventory(String categoriaId) async {
    checkingInventory = true;
    hasActiveInventory = null;
    activeInventoryId = null;
    update();
    try {
      final qs = await FirebaseFirestore.instance
          .collection('inventarios')
          .where('categoriaId', isEqualTo: categoriaId)
          .where('estado', isEqualTo: 'borrador')
          .limit(1)
          .get();
      if (qs.docs.isNotEmpty) {
        hasActiveInventory = true;
        activeInventoryId = qs.docs.first.id;
      } else {
        hasActiveInventory = false;
      }
    } catch (e) {
      try {
        final qs = await FirebaseFirestore.instance
            .collection('inventarios')
            .where('categoriaId', isEqualTo: categoriaId)
            .limit(5)
            .get();
        final docs = qs.docs.where((d) {
          final estado = (d.data()['estado'] as String?) ?? '';
          return estado == 'borrador';
        }).toList();
        if (docs.isNotEmpty) {
          hasActiveInventory = true;
          activeInventoryId = docs.first.id;
        } else {
          hasActiveInventory = false;
        }
      } catch (_) {
        hasActiveInventory = false;
      }
    } finally {
      checkingInventory = false;
      update();
    }
  }
}
