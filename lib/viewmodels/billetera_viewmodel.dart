import '../models/boleto.dart';
import '../services/api_service.dart';

/// [BilleteraViewModel] gestiona los datos de los boletos comprados por el usuario.
class BilleteraViewModel {
  final _apiService = ApiService();

  /// Obtiene los boletos del usuario desde el backend.
  Future<List<Boleto>> cargarBilletera() async {
    return await _apiService.obtenerBilletera();
  }
}
