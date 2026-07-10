import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/boleto.dart';

/// [PantallaDetalleBoleto] muestra de forma gráfica e interactiva la información
/// de un boleto específico, incluyendo un código QR escaneable y botones de acción.
class PantallaDetalleBoleto extends StatelessWidget {
  final Boleto boleto;
  const PantallaDetalleBoleto({super.key, required this.boleto});

  /// Muestra una notificación emergente (SnackBar) simulando la integración del backend.
  void _proximamente(BuildContext context, String accion) {
    const cPrimario = Color(0xFF6C3AE8);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$accion – disponible con backend'),
        backgroundColor: cPrimario,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cFondo = Color(0xFF0F0F1A);
    const cSuperficie = Color(0xFF1A1A2E);

    return Scaffold(
      backgroundColor: cFondo,
      appBar: AppBar(
        backgroundColor: cSuperficie,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Mi Boleto',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Helper method: Parte superior del boleto con el degradado y datos del evento.
            _buildTicketHeader(),
            // Widget separado: Línea punteada que simula el troquelado/corte físico del boleto.
            _SeparadorBoleto(),
            // Helper method: Parte inferior del boleto con el código QR y botones de acción.
            _buildTicketBody(context),
          ],
        ),
      ),
    );
  }

  /// Construye la sección superior del boleto físico digitalizado.
  Widget _buildTicketHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C3AE8), Color(0xFF3A1AE8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.confirmation_num, color: Colors.white54, size: 14),
              const SizedBox(width: 6),
              Text(
                'ID: ${boleto.id}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            boleto.eventoNombre,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            boleto.asiento,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            boleto.fecha,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Construye la sección inferior del boleto que aloja el código QR y los botones de acción.
  Widget _buildTicketBody(BuildContext context) {
    const cTarjeta = Color(0xFF16213E);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cTarjeta,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          const Text(
            'CÓDIGO DE ACCESO',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          // Helper method: Código QR generado dinámicamente.
          _buildQRCode(),
          const SizedBox(height: 14),
          Text(
            'Smart Ticket™ – Escanéalo en la entrada',
            style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 12),
          ),
          const SizedBox(height: 28),
          // Helper method: Botones para transferir o cancelar boleto.
          _buildActionButtons(context),
        ],
      ),
    );
  }

  /// Genera e interactúa con el widget de código QR.
  Widget _buildQRCode() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: QrImageView(
        data: boleto.qrData,
        version: QrVersions.auto,
        size: 200,
        backgroundColor: Colors.white,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF6C3AE8),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF0F0F1A),
        ),
      ),
    );
  }

  /// Construye la fila de botones de acciones principales sobre el boleto.
  Widget _buildActionButtons(BuildContext context) {
    const cPrimario = Color(0xFF6C3AE8);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _proximamente(context, 'Transferir'),
            icon: const Icon(Icons.send_outlined, size: 18),
            label: const Text('Transferir'),
            style: OutlinedButton.styleFrom(
              foregroundColor: cPrimario,
              side: const BorderSide(color: cPrimario),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _proximamente(context, 'Cancelar'),
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: const Text('Cancelar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF5252),
              side: const BorderSide(color: Color(0xFFFF5252)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// [_SeparadorBoleto] es un widget que representa visualmente el troquelado
/// mediante círculos a los extremos laterales y una línea segmentada central.
class _SeparadorBoleto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const cFondo = Color(0xFF0F0F1A);
    const cTarjeta = Color(0xFF16213E);

    return Container(
      color: cTarjeta,
      child: Row(
        children: [
          // Muesca semicircular izquierda
          Container(
            width: 22,
            height: 30,
            decoration: const BoxDecoration(
              color: cFondo,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
            ),
          ),
          // Línea de puntos segmentados dinámica según el ancho de pantalla
          Expanded(
            child: LayoutBuilder(
              builder: (_, constraints) {
                const dw = 8.0, sp = 6.0;
                final n = (constraints.maxWidth / (dw + sp)).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    n,
                    (_) => Container(
                      width: dw,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                );
              },
            ),
          ),
          // Muesca semicircular derecha
          Container(
            width: 22,
            height: 30,
            decoration: const BoxDecoration(
              color: cFondo,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
