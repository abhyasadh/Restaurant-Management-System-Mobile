import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OffersView extends ConsumerWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Offers',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    ),
      body: const Center(
        child: Text(
          'Sorry! We currently have no offers.',
          style: TextStyle(fontFamily: 'Blinker', fontSize: 20),
        ),
      ),
    );
  }
}
