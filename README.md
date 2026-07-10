# EventTix Frontend (Flutter) 🎟️

Aplicación móvil híbrida desarrollada en **Flutter** para la gestión, visualización y compra de boletos para eventos culturales y de entretenimiento. 

Este cliente móvil consume directamente los servicios expuestos por la API REST de **EventTix API** en producción.

---

## 🛠️ Stack Tecnológico

*   **Framework**: Flutter (Dart) con Material Design 3.
*   **Gestión de Red**: Integrado con el cliente HTTP nativo mediante el paquete `http`.
*   **Almacenamiento Local**: Uso de `shared_preferences` para almacenar y persistir el token de sesión JWT del usuario.
*   **Generador QR**: Código de acceso dinámico por boleto renderizado localmente mediante `qr_flutter`.

---

## 🌐 Conexión al Backend Desplegado

La aplicación móvil está configurada para consumir los endpoints de la API desplegada en:
*   **Base URL**: `http://77.42.83.15:9988/api`

### Endpoints Consumidos
1.  `POST /api/register` — Permite el autoregistro de usuarios.
2.  `POST /api/login` — Autentica al usuario devolviendo el JWT.
3.  `GET /api/perfil` — Carga dinámicamente los datos del usuario autenticado.
4.  `GET /api/eventos` — Lista todos los eventos disponibles con sus respectivos detalles y colores de categoría.
5.  `GET /api/billetera` — Carga en tiempo real los boletos asociados al usuario autenticado.
6.  `POST /api/billetera/comprar` — Realiza la adquisición de un boleto (disponible a través de endpoints futuros).

---

## 📁 Arquitectura del Código (`lib/`)

El proyecto sigue una estructura limpia bajo el patrón **MVVM** (Model-View-ViewModel) para desacoplar la interfaz gráfica de la lógica de negocio y consumo de red:

```
lib/
├── models/
│   ├── boleto.dart         ← Modelo para deserializar boletos
│   └── evento.dart         ← Modelo para deserializar eventos y parsear colores hexadecimales
├── services/
│   └── api_service.dart    ← Centraliza llamadas HTTP y persistencia local del JWT
├── viewmodels/
│   ├── billetera_viewmodel.dart  ← Puente asíncrono para boletos del usuario
│   └── eventos_viewmodel.dart    ← Puente asíncrono para el catálogo de eventos
└── views/
    ├── pantalla_auth.dart  ← Interfaz de Login y Registro de usuarios
    ├── pantalla_eventos.dart     ← Vista del catálogo general de eventos
    ├── pantalla_billetera.dart   ← Vista de boletos comprados (Activos y Usados)
    ├── pantalla_detalle_boleto.dart   ← Vista detallada del boleto con su respectivo código QR
    └── pantalla_perfil.dart      ← Vista del perfil del usuario y logout
```

---

## 🚀 Cómo correr el proyecto localmente

### Requisitos previos
*   Flutter SDK configurado.
*   Dispositivo físico o emulador (con conexión a internet para cargar los datos del servidor VPS).

### Instrucciones
1.  Obtener las dependencias de la app:
    ```bash
    flutter pub get
    ```
2.  Ejecutar el proyecto en tu emulador o dispositivo:
    ```bash
    flutter run
    ```
