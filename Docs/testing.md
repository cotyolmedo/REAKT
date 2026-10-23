# Estrategia y registro de pruebas REAKT

## Criterio

Avanzar de componentes aislados hacia integración. Una prueba solo se considera
aprobada si registra condiciones, versión, resultado esperado, resultado real y
evidencia cuando corresponda. No inferir validación física desde una revisión
estática o un archivo CAD.

## Matriz pendiente

### Firmware y ESP-NOW

- [ ] Compilar gateway y nodo para la placa ESP32 real; registrar versión del
  core.
- [ ] Verificar inicialización, transmisión y recepción con un nodo.
- [ ] Extender a cinco nodos.
- [ ] Probar límites, paquetes inválidos, cola llena, pérdidas, duplicados,
  orden, timeouts y recuperación.
- [ ] Probar coexistencia entre el transporte App ↔ gateway y el canal ESP-NOW.

### Pulsador NA

- [ ] Verificar GPIO y polaridad antes de habilitar `BUTTON_GPIO`.
- [ ] Confirmar un solo evento por pulsación y rearme tras liberación.
- [ ] Probar rebote, pulsaciones rápidas/prolongadas y vibración.
- [ ] Definir y medir el criterio de timestamp.

### WS2812B y alimentación

- [ ] Verificar estados visuales, nivel lógico, brillo y consumo máximo.
- [ ] Medir tensiones durante picos de LED y radio.
- [ ] Verificar protección, carga, temperatura y batería baja.
- [ ] Probar operación durante carga solo si existe un *power-path* diseñado.

### Aplicación

- [ ] Ejecutar `flutter analyze` y pruebas automatizadas.
- [ ] Validar navegación y renderizado en Android/iOS.
- [ ] Probar conexión, desconexión, datos inválidos y errores de backend.
- [ ] Sustituir datos de demostración solo cuando existan interfaces reales.

### Backend

- [ ] Probar migraciones, restricciones, CRUD, autenticación y RLS.
- [ ] Verificar que Flutter no use claves privilegiadas.
- [ ] Probar fallos de red y autorización.

### Integración

```text
Flutter → gateway → nodo (WS2812B)
Flutter ← gateway ← nodo (pulsador)
Flutter o servicio autorizado ↔ Supabase/PostgreSQL
```

Validar camino normal, desconexiones y recuperación antes de la exhibición.

## Evidencia existente

### Consolidación del repositorio — 2026-10-10

- `git diff --check`: completado sin errores de espacios en blanco.
- Revisión automatizada de enlaces Markdown locales: 0 enlaces rotos.
- Búsqueda fuera de `Tests/`: sin referencias a las antiguas rutas paralelas
  numeradas.
- Búsqueda en `firmware/`: sin llamadas a `delay()`.
- Búsqueda de patrones comunes de tokens JWT/API: sin coincidencias.
- Arduino CLI, PlatformIO, KiCad CLI y compilador C++ independiente: no
  disponibles; compilación de firmware y nuevo DRC no ejecutados.

### Flutter — 2026-10-09

- Revisión estática de `app/` realizada.
- `flutter analyze`, pruebas y renderizado quedaron sin ejecutar porque el SDK
  no estaba disponible en ese entorno.
- Estado: no verificado en dispositivo.

### Flutter — intento de verificación 2026-10-10

- El SDK fue detectado en el entorno, pero `flutter pub get`/`flutter analyze` y
  luego `flutter --version` no produjeron salida y agotaron los límites de 120 s
  y 30 s respectivamente.
- No se generó `pubspec.lock` ni se modificó `app/`.
- Estado: análisis aún pendiente; investigar la instalación del SDK antes de
  atribuir el timeout al proyecto.

### Prototipo web — 2026-10-09

- Revisión estática de metadatos Apple, `viewport-fit=cover`, safe areas,
  navegación móvil y manifest en `REAKT_web.html`.
- Safari en iPhone/iPad y modo Home Screen: pendientes.
- Detalle en `cambios pagina.md`.

### PCB V0.1 — 2026-10-09

- KiCad 9 CLI pudo analizar `hardware/pcb/reakt-nodo/reakt-nodo.kicad_pcb`.
- Informe guardado en `hardware/pcb/reakt-nodo/drc-v0.1.rpt`: cero pads sin
  conectar y advertencias esperables por footprints/serigrafía provisionales.
- Esto no constituye un DRC limpio de liberación.
- Esquemático, ERC, revisión de fabricación, encastre 3D y pruebas físicas:
  pendientes.

## Pruebas históricas

Los sketches en `Tests/` con ESP32-C3 o piezoeléctricos son antecedentes. No
validan los cinco nodos ESP32 con pulsador del diseño actual.

## Plantilla de evidencia

Registrar para cada ensayo:

- fecha y responsable;
- commit o versión de archivos;
- placa, componentes y conexiones reales;
- herramientas y configuración;
- procedimiento y resultado esperado;
- resultado real, mediciones y errores;
- fotos, video o logs cuando correspondan.
