import 'package:flutter/material.dart';
import 'views/pantalla_eventos.dart';
import 'views/pantalla_billetera.dart';
import 'views/pantalla_perfil.dart';
import 'views/pantalla_auth.dart';
import 'services/api_service.dart';

void main() {
  runApp(const EventTixApp());
}

// ─────────────────────────────────────────────────────────────────
// COLORES / TEMA
// ─────────────────────────────────────────────────────────────────

const _cFondo     = Color(0xFF0F0F1A);
const _cSuperficie = Color(0xFF1A1A2E);
const _cPrimario  = Color(0xFF6C3AE8);
const _cAcento    = Color(0xFFFF6B35);

// ─────────────────────────────────────────────────────────────────
// APP
// ─────────────────────────────────────────────────────────────────

class EventTixApp extends StatelessWidget {
  const EventTixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MaterialApp(
      title: 'EventTix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: _cPrimario,
          secondary: _cAcento,
          surface: _cSuperficie,
        ),
        scaffoldBackgroundColor: _cFondo,
      ),
      // Definición de rutas nombradas para transiciones limpias
      routes: {
        '/auth': (context) => const PantallaAuth(),
        '/home': (context) => const _PantallaBase(),
      },
      // Determina dinámicamente si redirige al Login o a la vista principal
      home: FutureBuilder<String?>(
        future: apiService.obtenerToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: _cFondo,
              body: Center(
                child: CircularProgressIndicator(color: _cPrimario),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
            return const _PantallaBase();
          }
          return const PantallaAuth();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PANTALLA BASE (NavigationBar)
// ─────────────────────────────────────────────────────────────────

class _PantallaBase extends StatefulWidget {
  const _PantallaBase();

  @override
  State<_PantallaBase> createState() => _PantallaBaseState();
}

class _PantallaBaseState extends State<_PantallaBase> {
  int _tab = 0;

  /// Devuelve la pantalla activa según el índice seleccionado.
  /// Al usar switch en lugar de IndexedStack, cada pestaña se reconstruye
  /// al ser seleccionada, garantizando datos frescos desde la API.
  Widget _buildBody() {
    switch (_tab) {
      case 0:
        return const PantallaEventos();
      case 1:
        return const PantallaBilletera();
      case 2:
        return const PantallaPerfil();
      default:
        return const PantallaEventos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AnimatedSwitcher proporciona una transición suave entre pestañas.
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey<int>(_tab),
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: _cSuperficie,
        indicatorColor: _cPrimario.withOpacity(0.25),
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event, color: _cPrimario),
            label: 'Eventos',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined),
            selectedIcon: Icon(Icons.wallet, color: _cPrimario),
            label: 'Billetera',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: _cPrimario),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
