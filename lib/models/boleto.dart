/// Modelo de datos que representa un [Boleto] comprado por el usuario.
class Boleto {
  final int id;
  final String eventoNombre;
  final String asiento;
  final String estado; // 'activo' | 'cancelado' (o 'usado' según el backend)
  final String qrData;
  final String fecha;

  const Boleto({
    required this.id,
    required this.eventoNombre,
    required this.asiento,
    required this.estado,
    required this.qrData,
    required this.fecha,
  });

  /// Factory constructor para deserializar un [Boleto] desde un mapa JSON del backend.
  factory Boleto.fromJson(Map<String, dynamic> json) {
    return Boleto(
      id: json['id'] as int,
      eventoNombre: json['evento_nombre'] ?? '',
      asiento: json['asiento'] ?? '',
      estado: json['estado'] ?? 'activo',
      qrData: json['qr_data'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}
