import 'package:equatable/equatable.dart';

class Promo extends Equatable {
  final String id;
  final String title;

  /// Ringkasan satu baris untuk kartu/carousel.
  final String subtitle;

  final String imageUrl;

  /// Deskripsi lengkap (boleh multi-paragraf, dipisah `\n`).
  final String description;

  final DateTime? validUntil;

  const Promo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    this.validUntil,
  });

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, description, validUntil];
}
