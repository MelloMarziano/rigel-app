import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rigel_app/screens/home/home_controller.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:rigel_app/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFE0DAC4),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD83232),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          titleSpacing: 16,
          title: Text(
            controller.username,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.PROFILE),
                child: const Icon(LucideIcons.user),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD83232),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.box,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sistema RIGEL',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gestión de Inventario',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Selecciona tu área de trabajo:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (controller.loading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ...controller.areas.map((area) {
                        final selected = controller.selectedAreaId == area.id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => controller.selectArea(area.id),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFD83232)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFFD83232)
                                      : Colors.black12,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.box,
                                    color: selected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    area.nombre,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 24),
                    Builder(
                      builder: (context) {
                        final enabled =
                            controller.selectedAreaId != null &&
                            controller.hasActiveInventory == true &&
                            !controller.checkingInventory;
                        final label = controller.selectedAreaId == null
                            ? 'Selecciona un área'
                            : controller.checkingInventory
                            ? 'Verificando...'
                            : (controller.hasActiveInventory == true
                                  ? 'Continuar'
                                  : 'No hay inventarios activos');
                        return GestureDetector(
                          onTap: enabled
                              ? () {
                                  Get.offAndToNamed(
                                    AppRoutes.INVENTARIO,
                                    arguments: {
                                      'categoriaId': controller.selectedAreaId,
                                      'inventarioId':
                                          controller.activeInventoryId,
                                    },
                                  );
                                }
                              : null,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: enabled
                                  ? const Color(0xFFD83232)
                                  : const Color(0xFFEA9898),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: controller.selectedAreaId != null
                            ? controller.clearSelection
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.circle_x,
                              size: 18,
                              color: controller.selectedAreaId != null
                                  ? const Color(0xFFD83232)
                                  : const Color(
                                      0xFFD83232,
                                    ).withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cancelar selección',
                              style: TextStyle(
                                color: controller.selectedAreaId != null
                                    ? const Color(0xFFD83232)
                                    : const Color(
                                        0xFFD83232,
                                      ).withValues(alpha: 0.5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
