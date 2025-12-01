import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_us_controller.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutUsController>(
      builder: (controller) => Scaffold(
        backgroundColor: const Color(0xFFE0DAC4),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD83232),
          foregroundColor: Colors.white,
          title: Text(controller.title),
        ),
        body: const Center(
          child: Text('Acerca de Nosotros'),
        ),
      ),
    );
  }
}
