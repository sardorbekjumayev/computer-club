import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/club_model.dart';
import '../theme/app_theme.dart';

class TariffsScreen extends StatelessWidget {
  final ComputerClub club;

  const TariffsScreen({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: CustomScrollView(
        slivers: [
          // Collapsing Toolbar with Image Slider
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.darkBg,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                   CarouselSlider(
                    options: CarouselOptions(
                      height: 350,
                      viewportFraction: 1.0,
                      autoPlay: true,
                    ),
                    items: club.imageUrls.map((url) {
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.darkBg.withValues(alpha: 0.8),
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
                      Text(
                        club.name,
                        style: AppTheme.theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.neonPurple.withValues(alpha: 0.1),
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
                      Text(
                        club.address,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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
          
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tariff = club.tariffs[index];
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
              childCount: club.tariffs.length,
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
