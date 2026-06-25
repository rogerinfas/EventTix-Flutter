import '../models/boleto.dart';

class BilleteraViewModel {
  // Lista de boletos mock estática
  final List<Boleto> _boletos = const [
    Boleto(
      id: 'TIX-001',
      eventoNombre: 'Concierto de Rock Épico',
      asiento: 'Sección A – Fila 5 – Asiento 12',
      estado: 'activo',
      qrData: 'EVENTTIX|TIX-001|e1|A-5-12|2026-07-15',
      fecha: '15 Jul 2026',
    ),
    Boleto(
      id: 'TIX-002',
      eventoNombre: 'Festival Jazz & Blues',
      asiento: 'Sección B – Fila 2 – Asiento 7',
      estado: 'activo',
      qrData: 'EVENTTIX|TIX-002|e2|B-2-7|2026-07-22',
      fecha: '22 Jul 2026',
    ),
    Boleto(
      id: 'TIX-003',
      eventoNombre: 'Stand-Up Comedy Night',
      asiento: 'General – Zona VIP',
      estado: 'cancelado',
      qrData: 'EVENTTIX|TIX-003|e3|VIP|2026-08-05',
      fecha: '5 Ago 2026',
    ),
  ];

  List<Boleto> get boletos => _boletos;

  int get totalActivos => _boletos.where((b) => b.estado == 'activo').length;
}
