class Boleto {
  final String id;
  final String eventoNombre;
  final String asiento;
  final String estado; // 'activo' | 'cancelado'
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
}
