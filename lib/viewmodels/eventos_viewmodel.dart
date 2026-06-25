import 'package:flutter/material.dart';
import '../models/evento.dart';

class EventosViewModel {
  // Lista de eventos mock estática
  final List<Evento> _eventos = const [
    Evento(
      id: 'e1',
      nombre: 'Concierto de Rock Épico',
      lugar: 'Estadio Metropolitano',
      fecha: '15 Jul 2026',
      precio: 'Q 350.00',
      categoria: 'Música',
      color: Color(0xFF6C3AE8),
    ),
    Evento(
      id: 'e2',
      nombre: 'Festival Jazz & Blues',
      lugar: 'Teatro Nacional',
      fecha: '22 Jul 2026',
      precio: 'Q 200.00',
      categoria: 'Música',
      color: Color(0xFF1A8FE3),
    ),
    Evento(
      id: 'e3',
      nombre: 'Stand-Up Comedy Night',
      lugar: 'Centro Cultural',
      fecha: '5 Ago 2026',
      precio: 'Q 150.00',
      categoria: 'Comedia',
      color: Color(0xFFFF6B35),
    ),
    Evento(
      id: 'e4',
      nombre: 'Ballet: El Lago de los Cisnes',
      lugar: 'Gran Teatro',
      fecha: '12 Ago 2026',
      precio: 'Q 280.00',
      categoria: 'Danza',
      color: Color(0xFFE91E8C),
    ),
    Evento(
      id: 'e5',
      nombre: 'EDM Festival Noche Eléctrica',
      lugar: 'Parque de la Industria',
      fecha: '20 Ago 2026',
      precio: 'Q 400.00',
      categoria: 'Electrónica',
      color: Color(0xFF00BCD4),
    ),
  ];

  List<Evento> get eventos => _eventos;
}
