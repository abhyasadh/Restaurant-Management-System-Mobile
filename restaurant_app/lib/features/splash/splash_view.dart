import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

import 'splash_view_model.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  String logoAssetPath = 'assets/gif/logo_animated.gif';
  GifController controller = GifController();

  @override
  void initState() {
    controller.addListener(() {
      if (controller.currentIndex == 28) {
        controller.pause();
        ref.read(splashViewModelProvider.notifier).init(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width / 1.75
        : MediaQuery.of(context).size.height / 1.75;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: ClipOval(
          child: Container(
            color: Colors.white,
            child: GifView.asset(
              logoAssetPath,
              controller: controller,
              width: size,
              height: size,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
