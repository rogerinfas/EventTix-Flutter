import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// [PantallaPerfil] representa la vista donde se muestra la información personal del usuario,
/// sus datos de contacto obtenidos desde el backend y la opción de cerrar sesión.
class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  final _apiService = ApiService();
  String _nombre = 'Cargando...';
  String _email = '...';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosPerfil();
  }

  /// Recupera los datos de perfil del backend.
  Future<void> _cargarDatosPerfil() async {
    try {
      final perfil = await _apiService.obtenerPerfil();
      if (mounted) {
        setState(() {
          _nombre = perfil['nombre'] ?? '';
          _email = perfil['email'] ?? '';
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _nombre = 'Error al cargar';
          _email = 'Revisa tu conexión';
          _cargando = false;
        });
      }
    }
  }

  /// Borra el token de sesión y redirige al usuario a la pantalla de login.
  Future<void> _cerrarSesion() async {
    await _apiService.cerrarSesion();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
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
        elevation: 0,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: _cargando
            ? const CircularProgressIndicator(color: Color(0xFF6C3AE8))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Helper method: Construye el Avatar del usuario.
                    _buildAvatar(),
                    const SizedBox(height: 20),
                    // Helper method: Construye la sección con el nombre y correo del usuario.
                    _buildUserDetails(),
                    const SizedBox(height: 48),
                    // Botón para cerrar sesión
                    _buildLogoutButton(),
                  ],
                ),
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
        Text(
          _nombre,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _email,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construye el botón de cerrar sesión.
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: _cerrarSesion,
        icon: const Icon(Icons.logout, size: 18),
        label: const Text(
          'Cerrar Sesión',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFF5252),
          side: const BorderSide(color: Color(0xFFFF5252)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
