import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// [PantallaAuth] gestiona la interfaz gráfica y la lógica para el registro
/// e inicio de sesión de los usuarios de la plataforma EventTix.
class PantallaAuth extends StatefulWidget {
  const PantallaAuth({super.key});

  @override
  State<PantallaAuth> createState() => _PantallaAuthState();
}

class _PantallaAuthState extends State<PantallaAuth> {
  final _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para los campos de entrada
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Estados visuales y de control de flujo
  bool _esLogin = true;
  bool _cargando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Procesa la solicitud al backend (Registro o Login) y redirige en caso de éxito.
  Future<void> _enviarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_esLogin) {
        // Ejecuta el flujo de Login
        final exito = await _apiService.login(email, password);
        if (exito) {
          if (mounted) {
            // Reinicia la navegación hacia la pantalla principal
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          setState(() => _mensajeError = 'Credenciales incorrectas');
        }
      } else {
        // Ejecuta el flujo de Registro
        final nombre = _nombreController.text.trim();
        final exito = await _apiService.registrar(nombre, email, password);
        if (exito) {
          // Después del registro, hace login automáticamente
          final exitoLogin = await _apiService.login(email, password);
          if (exitoLogin && mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          setState(() => _mensajeError = 'El correo ya está registrado o datos inválidos');
        }
      }
    } catch (e) {
      setState(() => _mensajeError = 'Error de conexión con el servidor');
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const cFondo = Color(0xFF0F0F1A);
    const cSuperficie = Color(0xFF1A1A2E);
    const cPrimario = Color(0xFF6C3AE8);
    const cAcento = Color(0xFFFF6B35);

    return Scaffold(
      backgroundColor: cFondo,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: cSuperficie,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Encabezado Logotipo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.confirmation_num, color: cAcento, size: 36),
                      const SizedBox(width: 8),
                      const Text(
                        'EventTix',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _esLogin ? 'Inicia sesión para continuar' : 'Crea tu cuenta de EventTix',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Mensaje de Error
                  if (_mensajeError != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      ),
                      child: Text(
                        _mensajeError!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Campo Nombre (sólo para Registro)
                  if (!_esLogin) ...[
                    TextFormField(
                      controller: _nombreController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        label: 'Nombre completo',
                        icon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Campo Email
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      label: 'Correo electrónico',
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo Contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 4) {
                        return 'La contraseña debe tener al menos 4 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botón Principal de Envío
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _enviarFormulario,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cPrimario,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _cargando
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              _esLogin ? 'Iniciar Sesión' : 'Registrarse',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón Secundario de Alternar Modo
                  TextButton(
                    onPressed: _cargando
                        ? null
                        : () {
                            setState(() {
                              _esLogin = !_esLogin;
                              _mensajeError = null;
                            });
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: cAcento,
                    ),
                    child: Text(
                      _esLogin
                          ? '¿No tienes cuenta? Regístrate aquí'
                          : '¿Ya tienes cuenta? Inicia sesión',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Estilizado común de los campos de texto
  InputDecoration _inputDecoration({required String label, required IconData icon}) {
    const cPrimario = Color(0xFF6C3AE8);

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4)),
      filled: true,
      fillColor: const Color(0xFF0F0F1A),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cPrimario, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
