# CubaCel USSD - Aplicación Móvil

Aplicación Flutter para acceder rápidamente a los códigos USSD de la operadora Cubacel en Cuba.

## Características

- ✅ **Búsqueda rápida** de códigos USSD por nombre, código o descripción
- ✅ **Acceso directo** al marcador telefónico con un solo toque
- ✅ **Compartir códigos** fácilmente con contactos
- ✅ **Diseño moderno** y fácil de usar
- ✅ **Funciona offline** (no requiere internet para usar los códigos)
- ✅ **Códigos más comunes** preconfigurados

## Códigos Incluidos

| Función | Código | Descripción |
|---------|--------|-------------|
| Saldo Principal | `*222#` | Consulta tu saldo principal |
| Saldo Bonus | `*222*266#` | Consulta tu saldo bonus |
| Paquete Datos | `*99#` | Contratar paquetes de datos |
| Paquete Voz | `*123#` | Contratar paquetes de voz |
| Paquete SMS | `*124#` | Contratar paquetes de SMS |
| Transferir Saldo | `*234#` | Transferir saldo a otro número |
| Mi Número | `*222*328#` | Conocer mi propio número |
| Último Recarga | `*222*732#` | Consultar última recarga |
| Plan Amigos | `*111#` | Gestionar plan amigos |
| Buzón de Voz | `*999#` | Acceder al buzón de voz |

## Requisitos

- Flutter SDK >= 3.0.0
- Android SDK (para compilar APK)
- Dispositivo Android o iOS

## Instalación y Desarrollo

### 1. Clonar o descargar el proyecto

```bash
cd cubacel_ussd
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar en modo desarrollo

```bash
flutter run
```

### 4. Compilar APK para producción

```bash
flutter build apk --release
```

El archivo APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## Estructura del Proyecto

```
cubacel_ussd/
├── lib/
│   ├── main.dart           # Punto de entrada y UI principal
│   └── share_service.dart  # Servicio para compartir códigos
├── assets/                 # Recursos adicionales (imágenes, etc.)
├── pubspec.yaml           # Configuración del proyecto y dependencias
└── README.md              # Este archivo
```

## Notas Importantes

⚠️ **Ejecución de USSD**: Por razones de seguridad, Android no permite la ejecución automática de códigos USSD. La aplicación abrirá el marcador telefónico con el código precargado, y el usuario deberá presionar "Llamar" para ejecutarlo.

⚠️ **Requisitos de red**: Algunos códigos USSD requieren:
- Tener una SIM de Cubacel insertada
- Estar dentro de la cobertura de la red Cubacel
- Tener saldo disponible (para ciertos servicios)

## Personalización

Para agregar más códigos USSD, edita la lista `ussdCodes` en `lib/main.dart`:

```dart
UssdCode(
  name: 'Nombre del servicio',
  code: '*XXX#',
  description: 'Descripción del servicio',
  icon: Icons.icon_name,
),
```

## Licencia

Este proyecto es de código abierto y puede ser modificado libremente.

## Contribuciones

¡Las contribuciones son bienvenidas! Si conoces más códigos USSD de Cubacel o quieres mejorar la aplicación, no dudes en contribuir.

---

**Hecho con ❤️ para Cuba**
