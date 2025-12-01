import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Familia {
  final String id;
  final String nombre;
  final String? descripcion;
  Familia({required this.id, required this.nombre, this.descripcion});
}

class InventarioController extends GetxController {
  final String categoriaId;
  final String? inventarioId;

  InventarioController({required this.categoriaId, this.inventarioId});

  final List<Familia> familias = [];
  String? selectedFamiliaId;
  bool loadingFamilias = false;
  String searchQuery = '';

  final List<ProductoItem> productos = [];
  bool loadingInventario = false;
  String? savingProductoId;
  String? lastSavedProductoId;

  String get tituloBoton =>
      inventarioId == null ? 'Crear inventario' : 'Continuar inventario';

  @override
  void onInit() {
    super.onInit();
    loadFamilias();
    if (inventarioId != null && inventarioId!.isNotEmpty) {
      loadInventario();
    }
  }

  Future<void> loadFamilias() async {
    loadingFamilias = true;
    update();
    final doc = await FirebaseFirestore.instance
        .collection('categorias')
        .doc(categoriaId)
        .get();
    final data = doc.data() ?? {};
    final raw = data['familias'];
    familias
      ..clear()
      ..addAll(
        ((raw as List?) ?? []).map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          return Familia(
            id: (m['id'] as String?) ?? '',
            nombre: (m['nombre'] as String?) ?? '',
            descripcion: m['descripcion'] as String?,
          );
        }),
      );
    loadingFamilias = false;
    selectedFamiliaId = null;
    update();
  }

  void selectFamilia(String? id) {
    selectedFamiliaId = id;
    update();
  }

  void setSearch(String q) {
    searchQuery = q;
    update();
  }

  List<ProductoItem> get filteredProductos {
    final q = searchQuery.trim().toLowerCase();
    return productos.where((p) {
      final byFamilia =
          selectedFamiliaId == null || p.familiaId == selectedFamiliaId;
      final byText = q.isEmpty || p.nombre.toLowerCase().contains(q);
      return byFamilia && byText;
    }).toList();
  }

  Future<void> loadInventario() async {
    loadingInventario = true;
    update();
    final doc = await FirebaseFirestore.instance
        .collection('inventarios')
        .doc(inventarioId)
        .get();
    final data = doc.data() ?? {};
    final raw = data['productos'];
    productos
      ..clear()
      ..addAll(
        ((raw as List?) ?? []).map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          final item = ProductoItem(
            productoId: (m['productoId'] as String?) ?? '',
            nombre: (m['nombre'] as String?) ?? '',
            unidadMedida: (m['unidadMedida'] as String?) ?? '',
            familiaId: (m['familiaId'] as String?) ?? '',
            stockActual: (m['stockActual'] as num?)?.toDouble() ?? 0,
            costoUnitario:
                (m['costoUtilitario'] as num?)?.toDouble() ??
                (m['costoUnitario'] as num?)?.toDouble() ??
                0,
          );
          item.cantidad =
              (m['diferencia'] as num?)?.toDouble() ??
              (m['cantidad'] as num?)?.toDouble() ??
              0;
          return item;
        }),
      );
    loadingInventario = false;
    update();
  }

  void increment(ProductoItem p) {
    p.cantidad += 1;
    update();
  }

  void decrement(ProductoItem p) {
    if (p.cantidad > 0) {
      p.cantidad -= 1;
      update();
    }
  }

  void setCantidad(ProductoItem p, double value) {
    p.cantidad = value < 0 ? 0 : value;
    update();
  }

  Future<void> saveProductoCantidad(ProductoItem p) async {
    if (inventarioId == null || inventarioId!.isEmpty) return;
    savingProductoId = p.productoId;
    update();
    final ref = FirebaseFirestore.instance
        .collection('inventarios')
        .doc(inventarioId);
    final snap = await ref.get();
    final data = snap.data() ?? {};
    final rawList = (data['productos'] as List?) ?? [];
    final productosMaps = rawList
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    for (final m in productosMaps) {
      if ((m['productoId'] as String?) == p.productoId) {
        m['diferencia'] = p.cantidad;
        break;
      }
    }
    await ref.update({'productos': productosMaps});
    savingProductoId = null;
    lastSavedProductoId = p.productoId;
    update();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (lastSavedProductoId == p.productoId) {
        lastSavedProductoId = null;
        update();
      }
    });
  }

  Future<void> enviarRevision() async {
    if (inventarioId == null || inventarioId!.isEmpty) return;
    await FirebaseFirestore.instance
        .collection('inventarios')
        .doc(inventarioId)
        .update({'estado': 'Revision'});
  }
}

class ProductoItem {
  final String productoId;
  final String nombre;
  final String unidadMedida;
  final String familiaId;
  final double stockActual;
  final double costoUnitario;
  double cantidad = 0;

  ProductoItem({
    required this.productoId,
    required this.nombre,
    required this.unidadMedida,
    required this.familiaId,
    required this.stockActual,
    required this.costoUnitario,
  });
}
