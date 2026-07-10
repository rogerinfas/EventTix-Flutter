import 'package:flutter/material.dart';

/// Modelo de datos que representa un [Evento] del catálogo.
class Evento {
  final int id;
  final String nombre;
  final String lugar;
  final String fecha;
  final String precio;
  final String categoria;
  final Color color;

  const Evento({
    required this.id,
    required this.nombre,
    required this.lugar,
    required this.fecha,
    required this.precio,
    required this.categoria,
    required this.color,
  });

  /// Factory constructor para deserializar un [Evento] desde un mapa JSON del backend.
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] as int,
      nombre: json['nombre'] ?? '',
      lugar: json['lugar'] ?? '',
      fecha: json['fecha'] ?? '',
      precio: json['precio'] ?? '',
      categoria: json['categoria'] ?? '',
      color: _parseHexColor(json['color_hex'] ?? ''),
    );
  }

  /// Método auxiliar para convertir un string Hexadecimal (ej: "#E91E63") a un objeto [Color] de Flutter.
  static Color _parseHexColor(String hex) {
    if (hex.isEmpty) return const Color(0xFF6C3AE8); // Color morado por defecto.
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
