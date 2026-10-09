# Protocolo de paquetes REAKT

## Estado
Arquitectura conceptual, **sin formato v1 definitivo**. Todos los nodos actuales son ESP32 y su entrada principal es un pulsador NA.

## Direcciones
- App → gateway: configuración y órdenes.
- Gateway → nodos: estímulos luminosos y órdenes.
- Nodos → gateway: eventos de pulsador y estados.
- Gateway → app: eventos, diagnósticos y resultados.

## Campos candidatos (no implementarlos sin acuerdo)
| Campo | Función | Estado |
|---|---|---|
| `type` | Orden/evento/estado | TBD |
| `mode` | Modo de entrenamiento | TBD |
| `node_id` | Identidad lógica de nodo | TBD |
| `timestamp` | Instante local del evento y referencia temporal | TBD |
| `sequence` | Detección de duplicados | TBD |
| `payload` | Datos específicos del evento/modo | TBD |
| `version` | Compatibilidad del formato | TBD |

## Evento de accionamiento
Representa una **activación digital** tras validar el pulsador. No incluye fuerza ni amplitud de impacto. Decidir si se transmite la marca temporal del primer flanco confirmado o el instante de confirmación del antirrebote.

## Medición de tiempos
La marca local de un nodo no equivale directamente al reloj del gateway ni al de Flutter. Definir sincronización, referencia de estímulo y compensación de latencia antes de publicar métricas de reacción entre dispositivos.

## Validación
Comprobar tamaños, serialización, IDs, orden, duplicados, retransmisiones, timeouts y compatibilidad en ambos extremos antes de declarar v1 estable.
