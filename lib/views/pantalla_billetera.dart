import 'package:flutter/material.dart';
import '../models/boleto.dart';
import '../viewmodels/billetera_viewmodel.dart';
import 'pantalla_detalle_boleto.dart';

/// [PantallaBilletera] representa la sección donde el usuario puede visualizar
/// sus boletos comprados (tanto activos como inactivos/utilizados).
class PantallaBilletera extends StatelessWidget {
  const PantallaBilletera({super.key});

  @override
  Widget build(BuildContext context) {
    // Instanciamos el ViewModel para obtener la lista de boletos y contadores.
    final viewModel = BilleteraViewModel();
    final boletos = viewModel.boletos;

    const cFondo = Color(0xFF0F0F1A);

    return Scaffold(
      backgroundColor: cFondo,
      // Helper method: Extrae el AppBar para mantener la legibilidad de la vista principal.
      appBar: _buildAppBar(viewModel),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: boletos.length,
        itemBuilder: (context, i) => _TarjetaBoleto(boleto: boletos[i]),
      ),
    );
  }

  /// Construye la barra superior con el conteo de boletos activos.
  PreferredSizeWidget _buildAppBar(BilleteraViewModel viewModel) {
    const cSuperficie = Color(0xFF1A1A2E);
    const cPrimario = Color(0xFF6C3AE8);

    return AppBar(
      backgroundColor: cSuperficie,
      title: const Text(
        'Mi Billetera',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Chip(
            label: Text(
              '${viewModel.totalActivos} Activos',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
            backgroundColor: cPrimario,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

/// [_TarjetaBoleto] representa la tarjeta individual de un boleto.
/// Permite navegación al detalle si el boleto se encuentra en estado 'activo'.
class _TarjetaBoleto extends StatelessWidget {
  final Boleto boleto;
  const _TarjetaBoleto({required this.boleto});

  // Getter auxiliar para validar si el boleto está disponible para su uso.
  bool get _activo => boleto.estado == 'activo';

  // Obtiene el color correspondiente según el estado del boleto.
  Color get _colorEstado => _activo ? const Color(0xFF4CAF50) : const Color(0xFFFF5252);

  @override
  Widget build(BuildContext context) {
    const cTarjeta = Color(0xFF16213E);

    return GestureDetector(
      onTap: _activo ? () => _irAlDetalle(context) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cTarjeta,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _colorEstado.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Helper method: Icono indicador izquierdo (código QR o cancelado).
            _buildIconIndicator(),
            const SizedBox(width: 14),
            // Helper method: Textos con el detalle del boleto (evento, asiento, fecha).
            Expanded(
              child: _buildTicketDetails(),
            ),
            // Helper method: Columna de estado a la derecha (Activo/Usado con flecha).
            _buildStatusColumn(),
          ],
        ),
      ),
    );
  }

  /// Navega a la pantalla del detalle del boleto.
  void _irAlDetalle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaDetalleBoleto(boleto: boleto),
      ),
    );
  }

  /// Construye el indicador visual (círculo con icono) según el estado del boleto.
  Widget _buildIconIndicator() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: _colorEstado.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _activo ? Icons.qr_code_2 : Icons.cancel_outlined,
        color: _colorEstado,
        size: 24,
      ),
    );
  }

  /// Construye la información principal del boleto.
  Widget _buildTicketDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boleto.eventoNombre,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          boleto.asiento,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          boleto.fecha,
          style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11),
        ),
      ],
    );
  }

  /// Construye la columna lateral derecha que indica la etiqueta del estado y flecha si es activo.
  Widget _buildStatusColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: _colorEstado.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            boleto.estado.toUpperCase(),
            style: TextStyle(
              color: _colorEstado,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_activo) ...[
          const SizedBox(height: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 13,
            color: Colors.white.withOpacity(0.3),
          ),
        ],
      ],
    );
  }
}
