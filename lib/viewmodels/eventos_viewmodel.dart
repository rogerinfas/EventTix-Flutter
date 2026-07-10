import '../models/evento.dart';
import '../services/api_service.dart';

/// [EventosViewModel] se encarga de servir como puente entre la capa de presentación
/// ([PantallaEventos]) y el servicio de red ([ApiService]) para los eventos.
class EventosViewModel {
  final _apiService = ApiService();

  /// Solicita el listado de eventos al backend de manera asíncrona.
  Future<List<Evento>> cargarEventos() async {
    return await _apiService.obtenerEventos();
  }
}
