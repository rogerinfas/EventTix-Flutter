# EventTix – Plataforma de Venta y Gestión de Boletos Inteligentes
## **INFORME FINAL DE PROYECTO**

---

### **1. PORTADA**

* **Proyecto:** EventTix (Aplicación Móvil + API Backend)
* **Curso:** Desarrollo de Aplicaciones para Dispositivos Móviles
* **Fecha:** Julio, 2026
* **Repositorio GitHub:** [EventTix-Flutter (Frontend)](https://github.com/rogerinfas/EventTix-Flutter) & [EventTix-API (Backend)](http://77.42.83.15:9988)

---

### **2. INTRODUCCIÓN Y PÚBLICO OBJETIVO**

#### **El Problema a Resolver**
En la actualidad, la adquisición de boletos para eventos en vivo suele ser un proceso engorroso o propenso a fraudes en la reventa. Los usuarios enfrentan dificultades para:
* **Transferir entradas** de forma segura a amigos o familiares sin pagar tarifas abusivas.
* **Cancelar reservas** cuando se les presenta un imprevisto, liberando el asiento para otros usuarios interesados.
* **Acceder de forma offline** a un código de acceso único y dinámico.

#### **Público Objetivo**
* **Usuarios Finales (Espectadores):** Personas de entre 16 y 60 años interesadas en asistir a conciertos, eventos deportivos, conferencias y obras teatrales, que buscan una interfaz intuitiva y transacciones seguras e inmediatas.
* **Organizadores de Eventos:** Quienes requieren de una plataforma transparente para la visualización del aforo y asientos asignados en tiempo real.

---

### **3. CARACTERÍSTICAS PRINCIPALES DE LA APLICACIÓN**

La aplicación móvil se conecta en tiempo real a una API REST en Python. Sus funciones principales son:

1. **Autenticación e Identidad (JWT):** Inicio de sesión y registro seguros con persistencia del token mediante `shared_preferences` para evitar re-inicios de sesión innecesarios.
2. **Cartelera Dinámica:** Exploración de eventos próximos organizados de forma visual con códigos de color dinámicos.
3. **Compra Asíncrona (Smart Booking):** Selección de asiento/zona y envío del ID del evento al backend para registrar la transacción.
4. **Billetera de Boletos Virtuales:** Visualización y ordenamiento de boletos en tiempo real. Los boletos cancelados o inactivos se agrupan automáticamente al final de la lista.
5. **Smart Ticket™ (Generador de QR):** Renderizado local del código QR de seguridad para ingreso al recinto basado en los metadatos provistos por el backend.
6. **Cancelación Automática:** Opción de liberar un boleto y habilitar el asiento para la venta de inmediato.
7. **Transferencia Directa P2P:** Envío instantáneo del boleto a cualquier otro usuario registrado ingresando su correo electrónico.

---

### **4. ARQUITECTURA DE SOFTWARE (MVVM)**

La aplicación frontend implementa el patrón **MVVM** (Model-View-ViewModel), el cual separa la interfaz de usuario de la lógica de negocio y las llamadas a la red.

```mermaid
graph TD
    subgraph Frontend (Flutter)
        V[Vistas / UI - Dart] -->|Observa cambios de estado| VM[ViewModels - Dart]
        VM -->|Actualiza Datos / Estado| V
        VM -->|Llama Métodos API| S[ApiService - HTTP Client]
        S -->|Deserializa JSON| M[Modelos - Evento/Boleto]
    end
    subgraph Backend (Flask API)
        S -->|Request HTTPS/JSON| R[Controladores / Rutas Python]
        R -->|Queries SQL| DB[(Base de Datos SQLite)]
    end
```

#### **Descripción de Componentes:**
* **Modelos (`lib/models/`):** Clases puras (`Evento`, `Boleto`) que representan las entidades del negocio y contienen serializadores `fromJson`.
* **ViewModels (`lib/viewmodels/`):** Clases intermedias (`EventosViewModel`, `BilleteraViewModel`) que administran la interacción con el servicio.
* **Vistas (`lib/views/`):** Widgets interactivos con estilo oscuro premium.
* **Servicio API (`lib/services/api_service.dart`):** Cliente HTTP centralizado que maneja cabeceras de autorización con JWT, reintentos y errores de red.

---

### **5. DECISIONES DE DISEÑO Y APRENDIZAJES**

1. **Reconstrucción Dinámica de Pestañas (Evitando el Congelamiento de Pantallas):**
   * *Decisión:* Reemplazamos la navegación estática con `IndexedStack` por un `switch/case` dinámico con transiciones `AnimatedSwitcher`.
   * *Aprendizaje:* `IndexedStack` congela las vistas hijas en memoria impidiendo que se disparen peticiones HTTP al cambiar de pestaña. Al forzar la reconstrucción con `ValueKey`, logramos que la Billetera se mantenga perfectamente sincronizada tras adquirir un nuevo boleto.
2. **Estilo Oscuro con HSL / Glassmorphism:**
   * *Decisión:* Se utilizó una paleta oscura con base `#0F0F1A`, realzada con acentos en violeta neón (`#6C3AE8`) y naranja quemado (`#FF6B35`).
   * *Aprendizaje:* La cohesión estética aumenta dramáticamente la confianza del usuario final, especialmente en apps transaccionales y de entretenimiento.
3. **Manejo de Errores P2P en Transferencia:**
   * *Decisión:* La transferencia de boletos muestra los errores específicos del servidor (como *"No existe el destinatario"* o *"El boleto ya no está activo"*) directamente al usuario dentro del cuadro de diálogo.

---

### **6. VÍDEO DE PRESENTACIÓN Y DEMOSTRACIÓN**

El video demostrativo abarca:
1. **Introducción:** Roles e integrantes.
2. **Arquitectura:** Estructura MVVM en Flutter y Flask.
3. **Flujo Funcional en Tiempo Real:** Registro de usuario -> Compra de entrada -> Inspección del boleto QR -> Transferencia de boleto -> Actualización automática de la Billetera.

* **Enlace al Video:** `[Colocar enlace al video de Youtube / Drive aquí]`

---

### **7. AUTOEVALUACIÓN Y RÚBRICA**

| Criterio | Autoevaluación | Justificación Técnica |
| :--- | :---: | :--- |
| **1. Funcionalidad general** | **Bueno (5 pts)** | La app maneja flujos complejos (compras de asientos, cancelaciones de reservas y transferencias entre cuentas) de forma síncrona/asíncrona y con refresco inmediato. |
| **2. Interfaz de usuario y diseño** | **Bueno (5 pts)** | Paleta de colores armoniosa, visualización del boleto tipo "troquelado físico", renderizado dinámico de QRs y micro-animaciones en botones. |
| **3. Documentación y presentación** | **Bueno (5 pts)** | Se adjunta este informe detallado, la rúbrica autoevaluada y el video demostrativo del sistema completo funcionando en el VPS. |
| **4. Código y buenas prácticas** | **Bueno (5 pts)** | Separación en sub-widgets, arquitectura MVVM limpia, comentarios descriptivos en español y versionamiento semántico con commits convencionales. |

* **Puntaje Estimado:** **20 / 20**
