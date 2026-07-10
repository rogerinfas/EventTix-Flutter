import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/boleto.dart';
import '../services/api_service.dart';

/// [PantallaDetalleBoleto] muestra de forma gráfica e interactiva la información
/// de un boleto específico, incluyendo un código QR escaneable y botones para transferir y cancelar.
class PantallaDetalleBoleto extends StatefulWidget {
  final Boleto boleto;
  const PantallaDetalleBoleto({super.key, required this.boleto});

  @override
  State<PantallaDetalleBoleto> createState() => _PantallaDetalleBoletoState();
}

class _PantallaDetalleBoletoState extends State<PantallaDetalleBoleto> {
  final _apiService = ApiService();
  bool _procesando = false;

  /// Controla la cancelación del boleto llamando a la API tras confirmación del usuario.
  Future<void> _cancelarBoleto() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('¿Cancelar Boleto?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Esta acción es irreversible. Se liberará tu asiento y el boleto quedará inactivo.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Volver', style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5252)),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _procesando = true);

    try {
      final exito = await _apiService.cancelarBoleto(widget.boleto.id);
      if (exito && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Boleto cancelado exitosamente'),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true); // Retorna true para indicar que se refresque la billetera
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo cancelar el boleto'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de conexión con el servidor'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _procesando = false);
      }
    }
  }

  /// Despliega un formulario emergente para capturar el email del destinatario y ejecutar la transferencia.
  Future<void> _transferirBoleto() async {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final destinatarioNombre = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        bool dialogCargando = false;
        String? dialogError;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A2E),
              title: const Text('Transferir Boleto', style: TextStyle(color: Colors.white)),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingresa el email del usuario registrado que recibirá este boleto:',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email del destinatario',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                        filled: true,
                        fillColor: const Color(0xFF0F0F1A),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF6C3AE8)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa un correo';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                          return 'Ingresa un correo electrónico válido';
                        }
                        return null;
                      },
                    ),
                    if (dialogError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        dialogError!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: dialogCargando ? null : () => Navigator.pop(ctx),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white38)),
                ),
                ElevatedButton(
                  onPressed: dialogCargando
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setDialogState(() {
                            dialogCargando = true;
                            dialogError = null;
                          });

                          try {
                            final destNombre = await _apiService.transferirBoleto(
                              widget.boleto.id,
                              emailController.text.trim(),
                            );
                            if (context.mounted) {
                              Navigator.pop(ctx, destNombre);
                            }
                          } catch (e) {
                            setDialogState(() {
                              dialogCargando = false;
                              dialogError = e.toString().replaceAll('Exception: ', '');
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C3AE8)),
                  child: dialogCargando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Transferir', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );

    emailController.dispose();

    if (destinatarioNombre != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Boleto transferido con éxito a $destinatarioNombre'),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true); // Retorna true para indicar refresco de billetera
    }
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
          if (_procesando)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF6C3AE8)),
              ),
            ),
        ],
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
                'ID: ${widget.boleto.id}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.boleto.eventoNombre,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.boleto.asiento,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            widget.boleto.fecha,
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
        data: widget.boleto.qrData,
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
            onPressed: _procesando ? null : _transferirBoleto,
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
            onPressed: _procesando ? null : _cancelarBoleto,
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
