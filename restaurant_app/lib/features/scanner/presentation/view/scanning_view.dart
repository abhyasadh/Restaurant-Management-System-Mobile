import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gif_view/gif_view.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restaurant_app/core/common/provider/socket.dart';
import 'package:restaurant_app/features/scanner/presentation/viewmodel/scanning_view_model.dart';

import '../../../../core/common/messages/snackbar.dart';

class ScanningView extends ConsumerStatefulWidget {
  const ScanningView({super.key});

  @override
  ConsumerState createState() => _ScanningViewState();
}

class _ScanningViewState extends ConsumerState<ScanningView> {

  late Socket socket;

  @override
  void initState() {
    super.initState();
    socket = ref.read(socketProvider);
    socket.socket.connect();
    socket.socket.on('Table Request Accepted', _handleRequestAccepted);
    socket.socket.on('Table Request Rejected', _handleRequestRejected);
  }

  void _handleRequestAccepted(tableId) {
    ref.read(scannerViewModelProvider.notifier).setTable(tableId);
  }

  void _handleRequestRejected(tableId) {
    showSnackBar(message: 'This table is unavailable!', context: context, error: true);
    ref.read(scannerViewModelProvider.notifier).resetState();
  }

  @override
  void dispose() {
    socket.socket.off('Table Request Accepted', _handleRequestAccepted);
    socket.socket.off('Table Request Rejected', _handleRequestRejected);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final scanningState = ref.watch(scannerViewModelProvider);
    final socket = ref.read(socketProvider);

    return Scaffold(
        body: SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 24,
              margin: const EdgeInsets.only(top: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Text(
                scanningState.requested
                    ? 'Please wait until your seat is verified. This may take a couple of minutes.'
                    : 'Press the button below and scan the QR on your table to get started.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Blinker',
                ),
              ),
            ),
            Expanded(
              child: Stack(alignment: Alignment.center, children: [
                scanningState.requested
                    ? const SizedBox()
                    : SpinKitSpinningLines(
                        color: Theme.of(context).primaryColor,
                        duration: const Duration(seconds: 2),
                        size: min(MediaQuery.of(context).size.width - 120,
                            MediaQuery.of(context).size.height - 120)),
                scanningState.requested
                    ? GifView.asset('assets/gif/scanned_loading.gif')
                    : GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  titlePadding: EdgeInsets.zero,
                                  actionsPadding:
                                      const EdgeInsets.only(bottom: 14),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  clipBehavior: Clip.hardEdge,
                                  shadowColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  title: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 18),
                                    child: Text(
                                      'QR Scanner',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontFamily: 'Blinker',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: MobileScanner(
                                              fit: BoxFit.cover,
                                              controller:
                                                  MobileScannerController(
                                                detectionSpeed:
                                                    DetectionSpeed.noDuplicates,
                                                facing: CameraFacing.back,
                                                torchEnabled: false,
                                              ),
                                              onDetect: (capture) {
                                                final List<Barcode> barcodes =
                                                    capture.barcodes;
                                                bool success = false;
                                                if (barcodes.isNotEmpty) {
                                                  success = ref.read(scannerViewModelProvider.notifier)
                                                      .scanQR(socket.socket, barcodes[0].rawValue!);
                                                }
                                                success
                                                    ? showSnackBar(
                                                        message:
                                                            'Verification Request Sent!\nPlease wait for a staff to verify your seat!',
                                                        context: context)
                                                    : showSnackBar(
                                                        message: 'Invalid QR',
                                                        context: context,
                                                        error: true);

                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(45)),
                          child: scanningState.requested
                              ? const CircularProgressIndicator()
                              : Icon(
                                  Icons.qr_code_rounded,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 44,
                                ),
                        ),
                      ),
              ]),
            ),
          ],
        ),
      ),
    ));
  }
}
