import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/models/item.dart';
import '../../core/providers/location_provider.dart';
import '../../core/providers/items_provider.dart';
import '../../theme/colors.dart';
import 'widgets/radius_filter_chip.dart';
import 'widgets/item_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780), // Seoul
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    await ref.read(locationProvider.notifier).checkPermissions();
    await ref.read(locationProvider.notifier).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final mapRadius = ref.watch(mapRadiusProvider);

    // Listen for radius changes and reload nearby items
    ref.listen(mapRadiusProvider, (previous, next) {
      if (previous != next) {
        _loadNearbyItems();
      }
    });

    // Listen for location changes and reload nearby items
    ref.listen(locationProvider, (previous, next) {
      if (previous?.userLocation != next.userLocation && next.userLocation != null) {
        _loadNearbyItems();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _moveToUserLocation();
            },
            initialCameraPosition: _defaultPosition,
            markers: _markers,
            onTap: (LatLng position) {
              // Clear any bottom sheet when tapping empty area
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            buildingsEnabled: true,
            style: _mapStyle,
          ),

          // Loading overlay
          if (locationState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Filter chips
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: const RadiusFilterChip(),
          ),

          // My location button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: _moveToUserLocation,
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 2,
              child: const Icon(Icons.my_location),
            ),
          ),

          // Permission error card
          if (locationState.permissionState != null && !locationState.permissionState!.isGranted)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: Card(
                color: AppColors.warning.withValues(alpha: 0.95),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_off, color: Colors.white),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              '위치 권한이 필요합니다',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '주변 아이템을 보려면 위치 권한을 허용해주세요.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => ref.read(locationProvider.notifier).openAppSettings(),
                            child: const Text('설정으로 이동', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Error message
          if (locationState.error != null)
            Positioned(
              bottom: 200,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locationState.error!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _moveToUserLocation() {
    final locationState = ref.read(locationProvider);
    if (locationState.userLocation != null && _mapController != null) {
      final position = CameraPosition(
        target: LatLng(
          locationState.userLocation!.latitude,
          locationState.userLocation!.longitude,
        ),
        zoom: 15.0,
      );
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(position));
      _loadNearbyItems();
    } else {
      // Retry getting location
      ref.read(locationProvider.notifier).getCurrentLocation();
    }
  }

  Future<void> _loadNearbyItems() async {
    final locationState = ref.read(locationProvider);
    final mapRadius = ref.read(mapRadiusProvider);
    
    if (locationState.userLocation == null) return;

    try {
      final nearbyItemsAsync = await ref.read(nearbyItemsProvider({
        'lat': locationState.userLocation!.latitude,
        'lng': locationState.userLocation!.longitude,
        'radius': mapRadius,
      }).future);

      _updateMapMarkers(nearbyItemsAsync);
    } catch (error) {
      // Handle error - could show a snackbar
      debugPrint('Error loading nearby items: $error');
    }
  }

  void _updateMapMarkers(List<Item> items) {
    final clusters = ref.read(itemClustersProvider(items));
    final newMarkers = <Marker>{};

    for (int i = 0; i < clusters.length; i++) {
      final cluster = clusters[i];
      newMarkers.add(
        Marker(
          markerId: MarkerId('cluster_$i'),
          position: LatLng(cluster.lat, cluster.lng),
          icon: _getMarkerIcon(cluster.count),
          onTap: () => _showItemBottomSheet(cluster.items),
          infoWindow: InfoWindow(
            title: cluster.count == 1 
                ? cluster.items.first.title
                : '${cluster.count}개 아이템',
            snippet: cluster.count == 1 
                ? '${cluster.items.first.pricePerDay}원/일'
                : null,
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  BitmapDescriptor _getMarkerIcon(int count) {
    // Simple marker icons for different cluster sizes
    if (count == 1) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    } else if (count <= 5) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  void _showItemBottomSheet(List<Item> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => ItemBottomSheet(items: items),
    );
  }

  // Custom map style (optional - can be removed for default style)
  static const String _mapStyle = '''
  [
    {
      "featureType": "poi",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    }
  ]
  ''';

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}