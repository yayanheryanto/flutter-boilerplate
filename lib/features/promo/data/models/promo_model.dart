import 'package:emas/features/promo/domain/entities/promo.dart';

/// Isi `response` dari endpoint promo (amplop `{reff_no, response}` sudah
/// dibuka `ApiEnvelopeInterceptor`).
///
/// ```json
/// {
///   "id": "promo-1",
///   "title": "Cashback 10% Lelang Motor",
///   "subtitle": "Khusus transaksi pertama",
///   "image_url": "https://…/promo1.jpeg",
///   "description": "…",
///   "valid_until": "2026-12-31T23:59:59.000"
/// }
/// ```
class PromoModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;
  final DateTime? validUntil;

  const PromoModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    this.validUntil,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      validUntil: DateTime.tryParse(json['valid_until'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'image_url': imageUrl,
        'description': description,
        'valid_until': validUntil?.toIso8601String(),
      };

  Promo toEntity() => Promo(
        id: id,
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        description: description,
        validUntil: validUntil,
      );
}

/// Isi `response` dari `GET PromoEndpoints.list`:
/// `{ "items": [ {…promo…}, … ] }`.
class PromoListModel {
  final List<PromoModel> items;

  const PromoListModel({required this.items});

  factory PromoListModel.fromJson(Map<String, dynamic> json) {
    final raw = (json['items'] as List<dynamic>?) ?? const [];
    return PromoListModel(
      items: raw.map((e) => PromoModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'items': items.map((e) => e.toJson()).toList()};
}
