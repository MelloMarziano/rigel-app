import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';

import 'inventario_controller.dart';
import '../../routes/app_routes.dart';

class InventarioScreen extends StatelessWidget {
  const InventarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventarioController>(
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFE0DAC4),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD83232),
          foregroundColor: Colors.white,
          title: const Text('Inventario'),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Get.offAndToNamed(AppRoutes.HOME);
            },
            icon: const Icon(LucideIcons.arrow_left),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Categoría: ${controller.categoriaId}'),
              // const SizedBox(height: 8),
              // Text('Inventario: ${controller.inventarioId ?? '-'}'),
              const SizedBox(height: 16),
              TextField(
                onChanged: controller.setSearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(LucideIcons.search),
                  hintText: 'Buscar productos...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: controller.loadingFamilias
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: const Text('Todos'),
                              selected: controller.selectedFamiliaId == null,
                              selectedColor: const Color(0xFFD83232),
                              labelStyle: TextStyle(
                                color: controller.selectedFamiliaId == null
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                              onSelected: (_) => controller.selectFamilia(null),
                            ),
                          ),
                          ...controller.familias.map((f) {
                            final sel = controller.selectedFamiliaId == f.id;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(f.nombre),
                                selected: sel,
                                selectedColor: const Color(0xFFD83232),
                                labelStyle: TextStyle(
                                  color: sel ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                                onSelected: (_) =>
                                    controller.selectFamilia(f.id),
                              ),
                            );
                          }),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: controller.loadingInventario
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: controller.filteredProductos.length,
                        itemBuilder: (context, index) {
                          final p = controller.filteredProductos[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () async {
                                final controllerText = TextEditingController();
                                final amountText = ''.obs;
                                final value = await showGeneralDialog<double>(
                                  context: context,
                                  barrierLabel: 'Cantidad',
                                  barrierDismissible: true,
                                  barrierColor: Colors.black.withValues(
                                    alpha: 0.4,
                                  ),
                                  transitionDuration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  pageBuilder: (ctx, a1, a2) {
                                    return Material(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Container(
                                          width: 340,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                p.nombre,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Unidad: ${p.unidadMedida} • Stock: ${p.stockActual.toStringAsFixed(0)} • Precio: \$${p.costoUnitario.toStringAsFixed(2)}',
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 12),
                                              TextField(
                                                controller: controllerText,
                                                keyboardType:
                                                    const TextInputType.numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.,]'),
                                                  ),
                                                ],
                                                onChanged: (v) {
                                                  amountText.value = v;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: '0',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Obx(() {
                                                final val =
                                                    double.tryParse(
                                                      amountText.value
                                                          .replaceAll(',', '.'),
                                                    ) ??
                                                    0;
                                                final total =
                                                    val * p.costoUnitario;
                                                return Text(
                                                  'Equivale a: \$${total.toStringAsFixed(2)}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              }),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () => Navigator.of(
                                                        ctx,
                                                      ).pop(),
                                                      child: Container(
                                                        height: 44,
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFEEDFC1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Cancelar',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        final parsed =
                                                            double.tryParse(
                                                              controllerText
                                                                  .text
                                                                  .replaceAll(
                                                                    ',',
                                                                    '.',
                                                                  ),
                                                            );
                                                        Navigator.of(ctx).pop(
                                                          parsed ?? p.cantidad,
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 44,
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFD83232,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Aceptar',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (value != null) {
                                  controller.setCantidad(p, value);
                                  await controller.saveProductoCantidad(p);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.nombre,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${p.unidadMedida} • Stock: ${p.stockActual.toStringAsFixed(0)} • \$${p.costoUnitario.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final controllerText =
                                                TextEditingController();
                                            final value = await showGeneralDialog<double>(
                                              context: context,
                                              barrierLabel: 'Cantidad',
                                              barrierDismissible: true,
                                              barrierColor: Colors.black
                                                  .withValues(alpha: 0.4),
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 200,
                                                  ),
                                              pageBuilder: (ctx, a1, a2) {
                                                return Material(
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: Container(
                                                      width: 340,
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          const Text(
                                                            'Cantidad',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                controllerText,
                                                            keyboardType:
                                                                const TextInputType.numberWithOptions(
                                                                  decimal: true,
                                                                ),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.allow(
                                                                RegExp(
                                                                  r'[0-9.,]',
                                                                ),
                                                              ),
                                                            ],
                                                            decoration: InputDecoration(
                                                              hintText: '0',
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: () =>
                                                                      Navigator.of(
                                                                        ctx,
                                                                      ).pop(),
                                                                  child: Container(
                                                                    height: 44,
                                                                    decoration: BoxDecoration(
                                                                      color: const Color(
                                                                        0xFFEEDFC1,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                      'Cancelar',
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    final parsed = double.tryParse(
                                                                      controllerText
                                                                          .text
                                                                          .replaceAll(
                                                                            ',',
                                                                            '.',
                                                                          ),
                                                                    );
                                                                    Navigator.of(
                                                                      ctx,
                                                                    ).pop(
                                                                      parsed ??
                                                                          p.cantidad,
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    height: 44,
                                                                    decoration: BoxDecoration(
                                                                      color: const Color(
                                                                        0xFFD83232,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                      'Aceptar',
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                            if (value != null) {
                                              controller.setCantidad(p, value);
                                              await controller
                                                  .saveProductoCantidad(p);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEEDFC1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              p.cantidad.toStringAsFixed(2),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Builder(
                                          builder: (_) {
                                            if (controller.savingProductoId ==
                                                p.productoId) {
                                              return const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xFFD83232)),
                                                ),
                                              );
                                            } else if (controller
                                                    .lastSavedProductoId ==
                                                p.productoId) {
                                              return const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 18,
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  await CoolAlert.show(
                    context: context,
                    type: CoolAlertType.confirm,
                    title: 'Confirmar envío',
                    text: '¿Deseas enviar este inventario a revisión?',
                    confirmBtnText: 'Sí',
                    cancelBtnText: 'No',
                    onConfirmBtnTap: () async {
                      // Navigator.of(context).pop();
                      await controller.enviarRevision();
                      Get.offAllNamed(AppRoutes.HOME);
                    },
                    onCancelBtnTap: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
                child: Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD83232),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Enviar a revisión',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
