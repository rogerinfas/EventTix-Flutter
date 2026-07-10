import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../services/api_service.dart';

/// [PantallaDetalleEvento] permite visualizar los detalles de un [Evento]
/// y realizar la compra de un boleto especificando el asiento.
class PantallaDetalleEvento extends StatefulWidget {
  final Evento evento;
  const PantallaDetalleEvento({super.key, required this.evento});

  @override
  State<PantallaDetalleEvento> createState() => _PantallaDetalleEventoState();
}

class _PantallaDetalleEventoState extends State<PantallaDetalleEvento> {
  final _apiService = ApiService();
  final _asientoController = TextEditingController(text: 'General');
  bool _comprando = false;

  @override
  void dispose() {
    _asientoController.dispose();
    super.dispose();
  }

  /// Envía la solicitud de compra al backend.
  Future<void> _adquirirBoleto() async {
    final asiento = _asientoController.text.trim();
    if (asiento.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor especifica un asiento o sección')),
      );
      return;
    }

    setState(() => _comprando = true);

    try {
      final exito = await _apiService.comprarBoleto(widget.evento.id, asiento);
      if (exito && mounted) {
        // Mostrar alerta de éxito
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                SizedBox(width: 8),
                Text('¡Compra Exitosa!', style: TextStyle(color: Colors.white)),
              ],
            ),
            content: const Text(
              'Tu boleto ha sido generado. Puedes encontrarlo en la pestaña de Billetera.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Aceptar', style: TextStyle(color: Color(0xFFFF6B35))),
              ),
            ],
          ),
        );
        if (mounted) {
          Navigator.pop(context, true); // Devuelve true para indicar que se compró un boleto
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al procesar la compra. Intente nuevamente.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión con el servidor')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _comprando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const cFondo = Color(0xFF0F0F1A);
    const cSuperficie = Color(0xFF1A1A2E);
    const cTarjeta = Color(0xFF16213E);
    const cPrimario = Color(0xFF6C3AE8);
    const cAcento = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: cFondo,
      appBar: AppBar(
        backgroundColor: cSuperficie,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Detalle de Evento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera gráfica del evento
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.evento.color, widget.evento.color.withOpacity(0.4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.evento.categoria.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.evento.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Información detallada
            const Text(
              'INFORMACIÓN GENERAL',
              style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoTile(Icons.calendar_today_outlined, 'Fecha', widget.evento.fecha, cTarjeta),
            const SizedBox(height: 10),
            _buildInfoTile(Icons.location_on_outlined, 'Lugar', widget.evento.lugar, cTarjeta),
            const SizedBox(height: 10),
            _buildInfoTile(Icons.payments_outlined, 'Precio', widget.evento.precio, cTarjeta),
            const SizedBox(height: 24),

            // Selector de Asiento
            const Text(
              'COMPRAR ENTRADA',
              style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cSuperficie,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Asiento o Sección:',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _asientoController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cFondo,
                      prefixIcon: const Icon(Icons.chair_outlined, color: Colors.white38),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: cPrimario),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _comprando ? null : _adquirirBoleto,
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: _comprando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Adquirir Entrada', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cPrimario,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye una celda de información limpia
  Widget _buildInfoTile(IconData icon, String titulo, String valor, Color cTarjeta) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cTarjeta,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF6B35), size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
                const SizedBox(height: 2),
                Text(valor, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
