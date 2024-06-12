import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:pharma_signal/views/profil/pharmacy_map/current_position.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PharmacyMapView extends StatelessWidget {
  const PharmacyMapView({Key? key});

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            AppBar(
              title: Text(
                AppLocalizations.of(context)?.myPharmacies ?? Constants.notAvailable,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 690,
              child: const Center(child: _MapWidget()),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleLayer extends StatefulWidget {
  const _CircleLayer({Key? key});

  @override
  State<_CircleLayer> createState() => __CircleLayerState();
}

class __CircleLayerState extends State<_CircleLayer> {
  LatLng? pos;

  @override
  void initState() {
    super.initState();
    getPos();
  }

  Future<void> getPos() async {
    try {
      Position position = await determinePosition();

      setState(() {
        double lat = position.latitude;
        double lng = position.longitude;
        pos = LatLng(lat, lng);
      });
    } catch (e) {
      print('Erreur lors de la lecture du fichier JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pos == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return CircleLayer(
        circles: [
          CircleMarker(
            point: pos!,
            color: Colors.blue.withOpacity(0.3),
            radius: 10,
            borderColor: Colors.blue,
            borderStrokeWidth: 1,
          ),
        ],
      );
    }
  }
}

class _MapWidget extends StatefulWidget {
  const _MapWidget({Key? key});

  @override
  State<_MapWidget> createState() => __MapWidgetState();
}

class __MapWidgetState extends State<_MapWidget> {
  List<Marker> points = [];
  List<dynamic> _items = [];

  static const Icon iconMarker =
      Icon(Icons.location_on, color: Colors.red, size: 30);

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/pharma_idf.json');
      final data = json.decode(response);
      setState(() {
        _items = data;

        _parseJsonCreateListMarker();
      });
    } catch (e) {
      print('Erreur lors de la lecture du fichier JSON: $e');
    }
  }

  void _parseJsonCreateListMarker() {
    for (var point in _items) {
      double lng = point['geometry']['coordinates'][0].toDouble();
      double lat = point['geometry']['coordinates'][1].toDouble();

      points.add(Marker(
        point: LatLng(lat, lng),
        width: 12,
        height: 12,
        child: GestureDetector(
          child: iconMarker,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: determinePosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur: ${snapshot.error}'),
          );
        }
        final currentPosition = snapshot.data;
        if (currentPosition == null) {
          return const Center(
            child: Text('Impossible de récupérer la position actuelle'),
          );
        }
        return FlutterMap(
          options: MapOptions(
            center: LatLng(
                currentPosition.latitude,
                currentPosition
                    .longitude), // Centre la carte sur la position actuelle
            zoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'Pharmacies',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
            const _MyCurrenLocationLayer(),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(50),
                markers: _items.isEmpty
                    ? [const Marker(point: LatLng(0, 0), child: iconMarker)]
                    : points,
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MyCurrenLocationLayer extends StatelessWidget {
  const _MyCurrenLocationLayer({Key? key});

  @override
  Widget build(BuildContext context) {
    return CurrentLocationLayer(
      alignPositionOnUpdate: AlignOnUpdate.once,
      alignDirectionOnUpdate: AlignOnUpdate.never,
      style: const LocationMarkerStyle(
        marker: DefaultLocationMarker(
          child: Icon(
            Icons.navigation,
            color: Colors.white,
          ),
        ),
        markerSize: Size(30, 30),
        markerDirection: MarkerDirection.heading,
      ),
    );
  }
}
