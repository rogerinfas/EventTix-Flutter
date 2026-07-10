import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../viewmodels/eventos_viewmodel.dart';

/// [PantallaEventos] representa la pantalla de inicio donde se listan
/// todos los eventos próximos disponibles en la plataforma.
class PantallaEventos extends StatelessWidget {
  const PantallaEventos({super.key});

  @override
  Widget build(BuildContext context) {
    // Instanciamos el ViewModel para obtener los eventos estáticos del repositorio.
    final viewModel = EventosViewModel();
    final eventos = viewModel.eventos;

    // Paleta de colores personalizada definida a nivel de diseño.
    const cFondo = Color(0xFF0F0F1A);

    return Scaffold(
      backgroundColor: cFondo,
      // Helper method: Extrae la AppBar para mantener el build principal limpio y modular.
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Helper method: Construye el título y subtítulo de la sección de bienvenida.
          _buildHeader(),
          // Listado de eventos ocupando el espacio restante disponible.
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

  /// Construye la barra superior ([AppBar]) con el logotipo de EventTix e iconos de acción rápida.
  PreferredSizeWidget _buildAppBar() {
    const cSuperficie = Color(0xFF1A1A2E);
    const cAcento = Color(0xFFFF6B35);

    return AppBar(
      backgroundColor: cSuperficie,
      elevation: 0,
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
        IconButton(
          icon: Icon(Icons.search, color: Colors.white54),
          onPressed: null, // Acción futura de búsqueda
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.white54),
          onPressed: null, // Acción futura para notificaciones
        ),
        SizedBox(width: 16),
      ],
    );
  }

  /// Construye la cabecera informativa de bienvenida de la pantalla de eventos.
  Widget _buildHeader() {
    return Padding(
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
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// [_TarjetaEvento] es un componente gráfico que muestra la información resumida
/// de un [Evento] específico (Categoría, Título, Fecha, Lugar y Precio).
class _TarjetaEvento extends StatelessWidget {
  final Evento evento;
  const _TarjetaEvento({required this.evento});

  @override
  Widget build(BuildContext context) {
    const cTarjeta = Color(0xFF16213E);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          // Helper method: Extrae el thumbnail/miniatura izquierdo con degradado dinámico.
          _buildThumbnail(),
          // Helper method: Extrae el cuerpo informativo de la derecha.
          Expanded(
            child: _buildEventDetails(),
          ),
        ],
      ),
    );
  }

  /// Construye la miniatura gráfica lateral izquierda de la tarjeta.
  Widget _buildThumbnail() {
    return Container(
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
    );
  }

  /// Construye la información textual derecha sobre el evento.
  Widget _buildEventDetails() {
    const cAcento = Color(0xFFFF6B35);

    return Padding(
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
          // Filas informativas reutilizables con iconos
          _InfoRow(icon: Icons.calendar_today_outlined, text: evento.fecha),
          const SizedBox(height: 3),
          _InfoRow(icon: Icons.location_on_outlined, text: evento.lugar),
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
    );
  }
}

/// [_InfoRow] es un widget auxiliar reutilizable para renderizar una línea
/// con un icono a la izquierda y un texto corto a la derecha de forma consistente.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.white38),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
