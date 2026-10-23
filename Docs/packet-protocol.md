# Protocolo de paquetes REAKT

## Estado

Arquitectura conceptual; no existe todavía un formato v1 definitivo. Ningún
campo de esta página autoriza una codificación concreta.

## Direcciones

- App → gateway: configuración y órdenes.
- Gateway → nodos: órdenes y estímulos.
- Nodos → gateway: eventos del pulsador y estado.
- Gateway → app: eventos, diagnósticos y resultados.

## Campos candidatos

| Campo | Función | Estado |
|---|---|---|
| `version` | Compatibilidad del formato | `TBD` |
| `type` | Orden, evento o estado | `TBD` |
| `mode` | Modo de entrenamiento | `TBD` |
| `node_id` | Identidad lógica | `TBD` |
| `timestamp` | Referencia temporal local | `TBD` |
| `sequence` | Orden y detección de duplicados | `TBD` |
| `payload` | Datos específicos del mensaje | `TBD` |

Antes de implementar se deben definir tipos, tamaños, rangos, endianness,
serialización, longitud máxima y reglas de compatibilidad.

## Evento de pulsador

Representa una activación digital validada. No contiene fuerza ni amplitud de
impacto. Debe decidirse si transmite el primer flanco observado o el instante de
confirmación del antirrebote.

## Temporización

Una marca local del nodo no equivale al reloj del gateway ni de Flutter. La
referencia del estímulo, sincronización, latencia y compensación deben definirse
y ensayarse antes de publicar métricas entre dispositivos.

## Validación mínima de v1

- Mensaje válido y longitudes límite.
- Versión o tipo desconocido.
- ID de nodo o modo inválido.
- Duplicados y mensajes fuera de orden.
- Pérdidas, reintentos y timeouts.
- Compatibilidad gateway ↔ nodos ↔ app.

No incluir secretos en los paquetes. Si se requiere autenticidad o integridad,
documentar primero el modelo de amenazas.
