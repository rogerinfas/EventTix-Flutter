import 'package:flutter/material.dart';
import 'views/pantalla_eventos.dart';
import 'views/pantalla_billetera.dart';
import 'views/pantalla_perfil.dart';

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
      home: const _PantallaBase(),
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

  static const _tabs = <Widget>[
    PantallaEventos(),
    PantallaBilletera(),
    PantallaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _tabs),
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
