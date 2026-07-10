import 'package:flutter/material.dart';

/// [PantallaPerfil] representa la vista donde se muestra la información personal del usuario,
/// sus datos de contacto y opciones de conectividad de backend/cuenta.
class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    const cFondo = Color(0xFF0F0F1A);
    const cSuperficie = Color(0xFF1A1A2E);

    return Scaffold(
      backgroundColor: cFondo,
      appBar: AppBar(
        backgroundColor: cSuperficie,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Helper method: Construye el Avatar del usuario.
            _buildAvatar(),
            const SizedBox(height: 16),
            // Helper method: Construye la sección con el nombre y correo del usuario.
            _buildUserDetails(),
            const SizedBox(height: 32),
            // Helper method: Construye la etiqueta de estado de conectividad asíncrona.
            _buildBackendStatus(),
          ],
        ),
      ),
    );
  }

  /// Construye el widget del avatar circular del usuario usando la paleta del tema.
  Widget _buildAvatar() {
    const cPrimario = Color(0xFF6C3AE8);

    return CircleAvatar(
      radius: 50,
      backgroundColor: cPrimario.withOpacity(0.2),
      child: const Icon(Icons.person, size: 56, color: cPrimario),
    );
  }

  /// Construye los campos de texto informativos del usuario (nombre y correo).
  Widget _buildUserDetails() {
    return Column(
      children: [
        const Text(
          'Roger Infa Sanchez',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'rinfas@ulasalle.edu.pe',
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }

  /// Construye la etiqueta de estado que advierte sobre la futura integración con backend.
  Widget _buildBackendStatus() {
    return Text(
      'Conectar con backend – Próximamente',
      style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 13),
    );
  }
}
