import 'package:flutter/material.dart';

class Evento {
  final String id;
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
}
