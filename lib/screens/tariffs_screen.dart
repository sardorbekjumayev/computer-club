import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/club_model.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class TariffsScreen extends StatefulWidget {
  final ComputerClub club;

  const TariffsScreen({super.key, required this.club});

  @override
  State<TariffsScreen> createState() => _TariffsScreenState();
}

class _TariffsScreenState extends State<TariffsScreen> {
  late ComputerClub _currentClub;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentClub = widget.club;
    // If we only have basic info (no tariffs or no images), fetch full details
    if (_currentClub.tariffs.isEmpty || _currentClub.imageUrls.isEmpty) {
      _fetchDetails();
    }
  }

  Future<void> _fetchDetails() async {
    setState(() => _isLoading = true);
    final fullClub = await ApiService.fetchClubDetails(widget.club.id);
    if (fullClub != null && mounted) {
      setState(() {
        // Merge distance from previous object if not in full details
        _currentClub = ComputerClub(
          id: fullClub.id,
          name: fullClub.name,
          distance: widget.club.distance,
          imageUrls: fullClub.imageUrls,
          tariffs: fullClub.tariffs,
          address: fullClub.description ?? fullClub.address,
          rating: fullClub.rating,
          lat: fullClub.lat != 0 ? fullClub.lat : widget.club.lat,
          lng: fullClub.lng != 0 ? fullClub.lng : widget.club.lng,
          description: fullClub.description,
        );
        _isLoading = false;
      });
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.neonPurple))
        : CustomScrollView(
        slivers: [
          // Collapsing Toolbar with Image Slider
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.darkBg,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  if (_currentClub.imageUrls.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 350,
                        viewportFraction: 1.0,
                        autoPlay: true,
                      ),
                      items: _currentClub.imageUrls.map((url) {
                        return Image.network(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.black,
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Container(
                      color: AppTheme.cardBg,
                      child: const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.darkBg.withAlpha(200),
                          AppTheme.darkBg,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _currentClub.name,
                          style: AppTheme.theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.neonPurple.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_border, color: AppTheme.neonPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.neonGreen, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _currentClub.address,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_currentClub.description != null && _currentClub.description!.isNotEmpty) ...[
                    Text(
                      'ABOUT THIS CLUB',
                      style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 14,
                        letterSpacing: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentClub.description!,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                  ],
                  Text(
                    'AVAILABLE TARIFFS',
                    style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      letterSpacing: 1.5,
                      color: AppTheme.neonPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          if (_currentClub.tariffs.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text('No tariffs available for this club.', style: TextStyle(color: Colors.grey)),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tariff = _currentClub.tariffs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.darkBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_getIconData(tariff.icon), color: AppTheme.neonGreen),
                        ),
                        title: Text(
                          tariff.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                        subtitle: Text(
                          tariff.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          tariff.price,
                          style: TextStyle(
                            color: AppTheme.neonPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: GoogleFonts.orbitron().fontFamily,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0),
                  );
                },
                childCount: _currentClub.tariffs.length,
              ),
            ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.neonPurple,
        label: const Text('BOOK A SEAT', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.event_seat),
      ).animate().scale(delay: 500.ms),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'time': return Icons.access_time;
      case 'nightlight': return Icons.nightlight_round;
      case 'star': return Icons.star;
      case 'school': return Icons.school;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'computer': return Icons.computer;
      case 'bolt': return Icons.bolt;
      default: return Icons.payments;
    }
  }
}
