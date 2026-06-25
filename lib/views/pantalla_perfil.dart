import 'package:flutter/material.dart';

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    const cFondo = Color(0xFF0F0F1A);
    const cSuperficie = Color(0xFF1A1A2E);
    const cPrimario = Color(0xFF6C3AE8);

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
            CircleAvatar(
              radius: 50,
              backgroundColor: cPrimario.withOpacity(0.2),
              child: const Icon(Icons.person, size: 56, color: cPrimario),
            ),
            const SizedBox(height: 16),
            const Text(
              'Roger Infa Sanchez',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'rinfas@ulasalle.edu.pe',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(height: 32),
            Text(
              'Conectar con backend – Próximamente',
              style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
