import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evento.dart';
import '../models/boleto.dart';

/// Servicio encargado de la comunicación HTTP con la API de EventTix.
/// Gestiona la persistencia del token JWT y el consumo de endpoints protegidos y públicos.
class ApiService {
  static const String baseUrl = 'http://77.42.83.15:9988/api';
  static const String _keyToken = 'jwt_token';
  static const String _keyNombre = 'usuario_nombre';

  /// Guarda el token JWT y el nombre de usuario localmente.
  Future<void> guardarSesion(String token, String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyNombre, nombre);
  }

  /// Recupera el token JWT guardado.
  Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Recupera el nombre del usuario guardado.
  Future<String?> obtenerNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNombre);
  }

  /// Elimina los datos de sesión localmente.
  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyNombre);
  }

  /// Retorna un mapa con las cabeceras requeridas, incluyendo el Bearer token si existe.
  Future<Map<String, String>> _obtenerHeaders({bool requiereAuth = true}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (requiereAuth) {
      final token = await obtenerToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Registra un nuevo usuario en la plataforma.
  Future<bool> registrar(String nombre, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: await _obtenerHeaders(requiereAuth: false),
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'password': password,
      }),
    );

    return response.statusCode == 201;
  }

  /// Realiza el inicio de sesión del usuario.
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: await _obtenerHeaders(requiereAuth: false),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      final nombre = data['nombre'] as String;
      await guardarSesion(token, nombre);
      return true;
    }
    return false;
  }

  /// Carga el catálogo de eventos del backend.
  Future<List<Evento>> obtenerEventos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/eventos'),
      headers: await _obtenerHeaders(requiereAuth: false),
    );

    if (response.statusCode == 200) {
      final List<dynamic> listJson = jsonDecode(utf8.decode(response.bodyBytes));
      return listJson.map((json) => Evento.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener eventos del servidor');
    }
  }

  /// Obtiene los datos del perfil del usuario autenticado.
  Future<Map<String, String>> obtenerPerfil() async {
    final response = await http.get(
      Uri.parse('$baseUrl/perfil'),
      headers: await _obtenerHeaders(requiereAuth: true),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return {
        'nombre': data['nombre'] ?? '',
        'email': data['email'] ?? '',
      };
    } else {
      throw Exception('Error al obtener datos del perfil');
    }
  }

  /// Carga la lista de boletos comprados por el usuario autenticado.
  Future<List<Boleto>> obtenerBilletera() async {
    final response = await http.get(
      Uri.parse('$baseUrl/billetera'),
      headers: await _obtenerHeaders(requiereAuth: true),
    );

    if (response.statusCode == 200) {
      final List<dynamic> listJson = jsonDecode(utf8.decode(response.bodyBytes));
      return listJson.map((json) => Boleto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener la billetera del servidor');
    }
  }

  /// Compra un boleto para un evento.
  Future<bool> comprarBoleto(int eventoId, String asiento) async {
    final response = await http.post(
      Uri.parse('$baseUrl/billetera/comprar'),
      headers: await _obtenerHeaders(requiereAuth: true),
      body: jsonEncode({
        'evento_id': eventoId,
        'asiento': asiento,
      }),
    );

    return response.statusCode == 201;
  }

  /// Cancela un boleto activo del usuario.
  Future<bool> cancelarBoleto(int boletoId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/billetera/$boletoId/cancelar'),
      headers: await _obtenerHeaders(requiereAuth: true),
    );
    return response.statusCode == 200;
  }

  /// Transfiere un boleto a otro usuario mediante su correo.
  /// Lanza una excepción si hay error para que la UI muestre el mensaje exacto.
  Future<String> transferirBoleto(int boletoId, String emailDestinatario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/billetera/transferir'),
      headers: await _obtenerHeaders(requiereAuth: true),
      body: jsonEncode({
        'boleto_id': boletoId,
        'destinatario_email': emailDestinatario,
      }),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return data['destinatario'] ?? emailDestinatario;
    } else {
      throw Exception(data['error'] ?? 'Error desconocido al transferir');
    }
  }
}
