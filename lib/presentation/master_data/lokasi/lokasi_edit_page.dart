import 'package:arise/data/models/lokasi_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../bloc/lokasi/lokasi_bloc.dart';
import '../../../data/models/lokasi_form_model.dart';
import '../../../helper/cek_internet_helper.dart';
import '../../../helper/navigation_helper.dart';
import '../../../shared/theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/forms.dart';
import '../../../widgets/snackbar.dart';

class LokasiEditPage extends StatefulWidget {
  final LokasiModel lokasi;
  const LokasiEditPage({super.key, required this.lokasi});

  @override
  State<LokasiEditPage> createState() => _LokasiEditPageState();
}

class _LokasiEditPageState extends State<LokasiEditPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final searchController = TextEditingController();

  LatLng defaultPosition = const LatLng(-7.250445, 112.768845);
  GoogleMapController? mapController;
  Marker? markerSelected;

  LatLng? myCurrentPosition;

  bool get isMarkerMyLocation {
    if (markerSelected == null || myCurrentPosition == null) return false;
    return markerSelected!.position.latitude == myCurrentPosition!.latitude &&
        markerSelected!.position.longitude == myCurrentPosition!.longitude;
  }

  Future<void> getMyLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    myCurrentPosition = LatLng(pos.latitude, pos.longitude);

    setMarker(pos.latitude, pos.longitude, 'Lokasi Saya');
  }

  void setMarker(double lat, double lng, String title) {
    latitudeController.text = lat.toStringAsFixed(6);
    longitudeController.text = lng.toStringAsFixed(6);

    setState(() {
      markerSelected = Marker(
        markerId: MarkerId(title),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
    );
  }

  Future<void> searchPlace(String query) async {
    if (query.isEmpty) return;
    List<Location> locations = await locationFromAddress(query);

    if (locations.isNotEmpty) {
      final loc = locations.first;
      setMarker(loc.latitude, loc.longitude, query);
    }
  }

  void onTapMap(LatLng latlng) {
    setMarker(latlng.latitude, latlng.longitude, 'Lokasi Dipilih');
  }

  @override
  void initState() {
    super.initState();
    _initLocationPermission();
    namaController.text = widget.lokasi.nama;
    alamatController.text = widget.lokasi.alamat;
    latitudeController.text = widget.lokasi.latitude;
    longitudeController.text = widget.lokasi.longitude;
    defaultPosition = LatLng(
      double.parse(widget.lokasi.latitude),
      double.parse(widget.lokasi.longitude),
    );
    markerSelected =
        markerSelected = Marker(
          markerId: MarkerId(widget.lokasi.nama),
          position: defaultPosition,
          infoWindow: InfoWindow(title: widget.lokasi.nama),
        );
  }

  Future<void> _initLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Lokasi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama',
              placeholder: 'Contoh: Kantor Pusat',
              badgeRequired: true,
            ),
            const SizedBox(height: 16),
            CustomOutlineForm(
              controller: alamatController,
              title: 'Alamat',
              placeholder: 'Alamat',
              badgeRequired: true,
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: CustomOutlineForm(
                    controller: latitudeController,
                    title: 'Latitude',
                    placeholder: 'Latitude',
                    badgeRequired: true,
                  ),
                ),
                Expanded(
                  child: CustomOutlineForm(
                    controller: longitudeController,
                    title: 'Longitude',
                    placeholder: 'Longitude',
                    badgeRequired: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Peta Lokasi',
              style: interBodySmallSemibold.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 8),
            CustomOutlineForm(
              controller: searchController,
              title: 'Lokasi',
              placeholder: 'Cari lokasi...',
              useTitle: false,
              prefixIcon: Hicons.search1Bold,
              onFieldSubmitted: searchPlace,
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: defaultPosition,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) => mapController = controller,
                    onTap: onTapMap,
                    markers: markerSelected != null ? {markerSelected!} : {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        isMarkerMyLocation
                            ? primary1.withValues(alpha: 0.25)
                            : Colors.grey.withValues(alpha: 0.25),
                    child: IconButton(
                      onPressed: getMyLocation,
                      icon: Icon(
                        Icons.my_location,
                        color: isMarkerMyLocation ? primary1 : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => LokasiBloc(),
            child: BlocConsumer<LokasiBloc, LokasiState>(
              listener: (context, state) {
                if (state is LokasiUpdated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is LokasiFailed) {
                  context.loaderOverlay.hide();
                  showCustomSnackbar(
                    context: context,
                    message: state.message,
                    isSuccess: false,
                  );
                }
              },
              builder: (context, state) {
                return CustomFilledButton(
                  title: 'Simpan Lokasi',
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      bool isConnected = await hasInternetConnection();
                      if (isConnected) {
                        if (context.mounted) {
                          context.loaderOverlay.show();
                          context.read<LokasiBloc>().add(
                            UpdateLokasi(
                              id: widget.lokasi.id,
                              data: LokasiFormModel(
                                nama: namaController.text,
                                alamat: alamatController.text,
                                latitude: double.parse(latitudeController.text),
                                longitude: double.parse(
                                  longitudeController.text,
                                ),
                              ),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          showCustomSnackbar(
                            context: context,
                            message: 'Periksa Koneksi Internet Anda',
                            isSuccess: false,
                          );
                        }
                      }
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
