import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/club_model.dart';
import '../services/location_service.dart';
import '../widgets/club_card.dart';
import '../theme/app_theme.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _isLoading = false;
  List<ComputerClub> _results = [];
  bool _gpsDisabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    setState(() {
      _isLoading = true;
      _gpsDisabled = false;
    });

    final position = await LocationService.getCurrentLocation();
    
    if (position == null) {
      final enabled = await LocationService.isLocationEnabled();
      if (!enabled) {
        setState(() {
          _gpsDisabled = true;
          _isLoading = false;
        });
        _showGpsModal();
      } else {
        // Permission denied or other error
        setState(() {
          _results = [];
          _isLoading = false;
        });
      }
    } else {
      // Mock delay for "searching"
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _results = mockClubs;
        _isLoading = false;
      });
    }
  }

  void _showGpsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 64, color: AppTheme.neonPurple),
            const SizedBox(height: 16),
            Text(
              'ENABLE LOCATION',
              style: AppTheme.theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'We need your GPS to find the nearest computer clubs in your area.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _checkLocation();
                },
                child: const Text('TRY AGAIN'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('NOT NOW', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FIND CLUBS',
          style: AppTheme.theme.textTheme.headlineMedium?.copyWith(fontSize: 20, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _checkLocation,
            icon: const Icon(Icons.refresh, color: AppTheme.neonPurple),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppTheme.neonPurple),
                  const SizedBox(height: 16),
                  const Text('Scanning area...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : _gpsDisabled
              ? _buildEmptyState('GPS is disabled. Enable it to find clubs.')
              : _results.isEmpty
                  ? _buildEmptyState('No computer clubs found in your area')
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      children: _results.map((club) => ClubCard(club: club)).toList(),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 100, color: Colors.grey.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checkLocation,
              child: const Text('RETRY SEARCH'),
            ),
          ],
        ),
      ),
    );
  }
}
