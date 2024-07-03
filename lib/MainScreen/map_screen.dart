import 'package:bitirmes/MainScreen/over_map_location.dart';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: LoginFormPage.currentCustomer.getMapPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }

          final places = snapshot.data;

          if (places is! List<MapPlace>) {
            return Center(child: Text('Error'));
          }

          return _Body(places: places);
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    super.key,
    required this.places,
  });

  final List<MapPlace> places;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  MapPlace? _selectedPlace;
  var favoriteLocations = <MapPlace>[];
  late bool isFavorite = false;

  void setSelectedPlace(MapPlace? place) {
    setState(() {
      _selectedPlace = place;
      isFavorite = favoriteLocations
          .any((location) => location.name == _selectedPlace?.name);
      print("isFavoritemap $isFavorite");
    });
  }

  @override
  void initState() {
    super.initState();
    allFavoritePlaces();
  }

  Future<void> allFavoritePlaces() async {
    var bodyStr = await LoginFormPage.currentCustomer.listAllFavoritePlaces();
    print(bodyStr);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        favoriteLocations = bodyStr ?? [];
      });
    });
  }

  // @override
  // void didUpdateWidget(covariant _Body oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   allFavoritePlaces();
  // }

  @override
  Widget build(BuildContext context) {
    final markers = Set<Marker>();

    for (final place in widget.places) {
      final marker = place.toMapMarker(setSelectedPlace);

      if (marker == null) {
        continue;
      }

      markers.add(
        marker,
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: markers.length > 0
                ? markers.first.position
                : LatLng(41.192783, 29.1569999),
            zoom: 9,
          ),
          markers: markers,
        ),
        if (_selectedPlace != null && widget.places.length > 0)
          OverMapLocation(
            place: _selectedPlace!,
            isFavorite: isFavorite,
          ),
      ],
    );
  }
}
