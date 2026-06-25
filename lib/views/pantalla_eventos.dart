import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../viewmodels/eventos_viewmodel.dart';

class PantallaEventos extends StatelessWidget {
  const PantallaEventos({super.key});

  @override
  Widget build(BuildContext context) {
    // Instanciamos el ViewModel para obtener los eventos estáticos
    final viewModel = EventosViewModel();
    final eventos = viewModel.eventos;

    const cFondo = Color(0xFF0F0F1A);
    const cSuperficie = Color(0xFF1A1A2E);
    const cAcento = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: cFondo,
      appBar: AppBar(
        backgroundColor: cSuperficie,
        title: Row(
          children: [
            Icon(Icons.confirmation_num, color: cAcento),
            const SizedBox(width: 8),
            const Text(
              'EventTix',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white54),
          SizedBox(width: 16),
          Icon(Icons.notifications_outlined, color: Colors.white54),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Próximos Eventos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Encuentra tu próxima experiencia',
                  style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: eventos.length,
              itemBuilder: (context, i) => _TarjetaEvento(evento: eventos[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaEvento extends StatelessWidget {
  final Evento evento;
  const _TarjetaEvento({required this.evento});

  @override
  Widget build(BuildContext context) {
    const cTarjeta = Color(0xFF16213E);
    const cAcento = Color(0xFFFF6B35);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [evento.color, evento.color.withOpacity(0.5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.music_note, color: Colors.white70, size: 28),
                const SizedBox(height: 4),
                Text(
                  evento.categoria,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(Icons.calendar_today_outlined, evento.fecha),
                  const SizedBox(height: 3),
                  _InfoRow(Icons.location_on_outlined, evento.lugar),
                  const SizedBox(height: 8),
                  Text(
                    evento.precio,
                    style: const TextStyle(
                      color: cAcento,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String texto;
  const _InfoRow(this.icon, this.texto);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.white38),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
