# Cambios página REAKT

Fecha: 2026-10-09  
Objetivo: adaptar `REAKT_web.html` a una experiencia visual y de navegación más cercana a Apple en Safari para iPhone/iPad y en modo Home Screen.

## Auditoría previa

- La página estaba en `REAKT_web.html`; no existe una carpeta `/REAKT_web`.
- Ya utilizaba tipografía del sistema (`-apple-system`) y una estética oscura con tarjetas, por lo que se conservaron el contenido, la arquitectura visual y la identidad roja de REAKT.
- Faltaban `viewport-fit=cover`, metadatos Apple, manifest, variables de safe area y navegación persistente en móvil.
- La navegación de escritorio se ocultaba completamente por debajo de 900 px.
- No se agregaron iconos PNG ni splash screens porque el repositorio no contiene una pieza gráfica aprobada y no corresponde inventar un recurso de marca.

## Cambios aplicados

### 1. Metadatos para Safari/Home Screen — aplicado

- Se agregó `viewport-fit=cover`.
- Se agregaron `apple-mobile-web-app-capable`, `mobile-web-app-capable`, `apple-mobile-web-app-title` y `apple-mobile-web-app-status-bar-style`.
- Se agregó `theme-color` para el modo oscuro real de la página, evitando declarar un color claro que no coincide con el fondo implementado.
- Se vinculó `manifest.webmanifest`.

### 2. Manifest web — aplicado

- Se creó `manifest.webmanifest` con nombre, nombre corto, idioma, `start_url`, `scope`, modo `standalone` y colores coherentes con la página.
- La apariencia del icono de Home Screen queda pendiente hasta contar con un recurso PNG de marca aprobado.

### 3. Safe areas y layout edge-to-edge — aplicado

- Se centralizaron `safe-area-inset-top/right/bottom/left` en variables CSS.
- La barra superior suma el inset superior sin ocultar contenido.
- El ancho del contenido contempla los insets laterales.
- Se ajustaron el scroll padding y el espacio superior del hero.
- Se mantuvo un layout usable cuando el inset vale `0px`.

### 4. Interacción táctil y accesibilidad — aplicado

- Se agregó `touch-action: manipulation` a controles y enlaces interactivos.
- Se mantuvo el zoom y la selección de texto del cuerpo.
- Se agregaron estados `:focus-visible` visibles para teclado y navegación asistiva.
- Los botones principales alcanzan una altura mínima de 48 px.

### 5. Estética visual Apple — aplicado

- La barra superior usa translucencia, blur y saturación con prefijo WebKit.
- Los botones adoptan forma de píldora y el CTA principal tiene realce sutil.
- Se agregaron transiciones y hover únicamente para dispositivos que realmente soportan hover.
- No se modificó el contenido técnico ni se inventaron datos del sistema.

### 6. Navegación móvil y modo standalone — aplicado

- Se agregó una barra inferior móvil con accesos a Inicio, Sistema, Progreso y Equipo.
- La barra contempla el inset inferior y un área táctil mínima.
- Se agregó espacio inferior al contenido para que la barra no tape información.
- Esto aporta navegación interna cuando Safari oculta sus controles en modo standalone.
- La barra se activa hasta 900 px de ancho, cubriendo también tablets/iPad cuando se ocultan los enlaces de escritorio.

## Verificación

- Revisado estáticamente: etiquetas HTML, manifest, variables CSS de safe area, navegación móvil y ausencia de `user-scalable=no`/`maximum-scale=1`.
- Verificación en dispositivo físico iPhone/iPad: **Unverified**; no hay un dispositivo Apple disponible en este entorno.
- Icono real de Home Screen y splash screen: **Pendiente**, por falta de un asset de marca aprobado.
- No se ejecutó un servidor local ni una prueba visual en Safari durante este cambio.

## Pendientes explícitos

- Probar en Safari de iPhone y iPad, en vertical, horizontal y modo Home Screen.
- Comprobar que los colores de status bar y barra inferior coincidan con el modo claro/oscuro real.
- Incorporar un PNG opaco de 180×180 px y, si se decide usar splash screens, sus variantes verificadas por dispositivo.

## Actualización de información del proyecto — 2026-10-09

- Se reemplazaron las referencias a ESP32-C3 por la arquitectura vigente: un gateway ESP32 y cinco nodos ESP32.
- Se actualizó la adquisición a pulsador mecánico normalmente abierto (NA) y la salida visual a WS2812B.
- Se aclaró que el TP4056 USB-C es un cargador previsto, no un regulador ni una solución de power-path validada.
- Se marcó como TBD la interfaz Flutter↔gateway y se evitó afirmar una conexión directa del gateway con Supabase.
- Se actualizaron el flujo de datos, las etapas de desarrollo, las métricas textuales y los placeholders de hardware.
- Se actualizó la tabla curricular: la condición de sensor/adquisición quedó como `TBD` hasta confirmación docente.
- Se reemplazó la sección Equipo con: Chirino Olmedo Constantino, Mendez Mia, Palma Huenteleo Justino y Pereyra Mia. Los roles quedaron como “por definir” porque no fueron especificados.
