class ClubTariff {
  final String title;
  final String price;
  final String description;
  final String icon;

  ClubTariff({
    required this.title,
    required this.price,
    required this.description,
    required this.icon,
  });

  factory ClubTariff.fromJson(Map<String, dynamic> json) {
    return ClubTariff(
      title: json['title'] ?? '',
      price: json['price']?.toString() ?? '',
      description: json['duration']?.toString() ?? '',
      icon: 'payments',
    );
  }
}

class ComputerClub {
  final String id;
  final String name;
  final double distance;
  final List<String> imageUrls;
  final List<ClubTariff> tariffs;
  final String address;
  final double rating;
  final double lat;
  final double lng;
  final String? description;

  ComputerClub({
    required this.id,
    required this.name,
    required this.distance,
    required this.imageUrls,
    required this.tariffs,
    required this.address,
    required this.rating,
    required this.lat,
    required this.lng,
    this.description,
  });

  factory ComputerClub.fromJson(Map<String, dynamic> json) {
    return ComputerClub(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      distance: _parseDouble(json['distance']),
      lat: _parseDouble(json['latitude']),
      lng: _parseDouble(json['longitude']),
      imageUrls: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      tariffs: (json['tariffs'] as List?)?.map((e) => ClubTariff.fromJson(e)).toList() ?? [],
      address: json['description'] ?? json['address'] ?? '',
      rating: 4.5,
      description: json['description'],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

final List<ComputerClub> mockClubs = [
  ComputerClub(
    id: '1',
    name: 'Cyber Zone',
    distance: 1.2,
    imageUrls: [
      'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=800',
      'https://images.unsplash.com/photo-1598550874175-4d0fe4cf43df?q=80&w=800',
      'https://images.unsplash.com/photo-1624696941338-934bf86c28b4?q=80&w=800',
    ],
    tariffs: [
      ClubTariff(title: 'Hourly', price: '2\$', description: 'Standard Zone (RTX 3060)', icon: 'time'),
      ClubTariff(title: 'Night Tariff', price: '8\$', description: '22:00 - 08:00', icon: 'nightlight'),
      ClubTariff(title: 'VIP Zone', price: '4\$', description: 'RTX 4080 + Secretlab', icon: 'star'),
      ClubTariff(title: 'Student Discount', price: '1.5\$', description: 'Show your ID', icon: 'school'),
    ],
    address: '123 Gaming Street, Downtown',
    rating: 4.8,
    lat: 41.311081,
    lng: 69.240562,
  ),
  ComputerClub(
    id: '2',
    name: 'Neon Rift',
    distance: 2.5,
    imageUrls: [
      'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=800',
      'https://images.unsplash.com/photo-1542751110-97427bbecf20?q=80&w=800',
    ],
    tariffs: [
      ClubTariff(title: 'Morning Rush', price: '1\$', description: '08:00 - 12:00', icon: 'wb_sunny'),
      ClubTariff(title: 'Standard', price: '2.5\$', description: 'All day', icon: 'computer'),
      ClubTariff(title: 'Pro Suite', price: '5\$', description: '240Hz Monitors', icon: 'bolt'),
    ],
    address: '45 Tech Plaza, West Side',
    rating: 4.5,
    lat: 41.321081,
    lng: 69.250562,
  ),
];
