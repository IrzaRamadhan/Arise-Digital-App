import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../shared/theme.dart';
import '../../widgets/buttons.dart';
import '../manajemen/manajemen_aset/aset_barang/aset_barang_detail_page.dart';
import '../manajemen/manajemen_aset/aset_sdm/aset_sdm_detail_page.dart';

class ScanQrCodePage extends StatefulWidget {
  const ScanQrCodePage({super.key});

  @override
  State<ScanQrCodePage> createState() => _ScanQrCodePageState();
}

class _ScanQrCodePageState extends State<ScanQrCodePage> {
  bool isScanned = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (isScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final code = barcodes.first.rawValue ?? "";
            setState(() => isScanned = true);

            try {
              final int id = int.parse(code.split('-')[0]);
              final String jenis = code.split('-')[1].toLowerCase();

              if (jenis == 'barang') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AsetBarangDetailPage(id: id),
                  ),
                );
              } else if (jenis == 'sdm') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AsetSdmDetailPage(id: id)),
                );
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Barcode Tidak Valid"),
                        content: Text('Jenis barcode tidak dikenali'),
                        actions: [
                          CustomFilledButton(
                            title: 'Scan Ulang',
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() => isScanned = false);
                            },
                          ),
                        ],
                      ),
                );
              }
            } catch (e) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => PopScope(
                      canPop: false,
                      child: AlertDialog(
                        title: Text(
                          'Barcode Tidak Valid',
                          style: interBodyLargeSemibold,
                        ),
                        content: Text(
                          'Format barcode tidak sesuai atau tidak dapat dibaca.',
                          style: interBodySmallRegular,
                        ),
                        actions: [
                          CustomFilledButton(
                            title: 'Scan Ulang',
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() => isScanned = false);
                            },
                          ),
                        ],
                      ),
                    ),
              );
            }
          }
        },
      ),
    );
  }
}
