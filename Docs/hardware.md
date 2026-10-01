# REAKT Hardware

## Main hardware

Current planned architecture:

- 1 × ESP32 gateway
- 5 × ESP32-C3 nodes
- sensors/input devices according to each training mode
- LED/actuator feedback
- rechargeable battery-powered nodes where applicable

## ESP32 gateway

Role:

- central wireless coordinator
- communication bridge between application and nodes

Board-specific GPIO assignments must be documented here when finalized.

Current status:

- GPIO map: TBD
- power supply: TBD
- enclosure: TBD

## ESP32-C3 nodes

Each node is an independent training device.

Responsibilities may include:

- push-button input
- piezoelectric sensor
- LED output
- other mode-specific sensors/actuators

Existing development tests have used, where applicable:

- button: GPIO 4
- piezoelectric input: GPIO 5
- LED: GPIO 8

These pins must be verified against the actual board and final circuit before being treated as final.

## Power

Nodes may use rechargeable batteries and a charging circuit.

The final design must explicitly define:

- battery chemistry/type
- nominal voltage
- holder/connector
- charging module
- protection
- power-path behavior
- regulator requirements
- maximum current
- operating time target

Do not invent electrical ratings.

## Hardware documentation requirements

For every finalized circuit document:

- schematic
- GPIO table
- supply voltage
- current considerations
- sensor/actuator electrical interface
- protection components
- connector/pinout
- known risks

## Safety

Never assume a GPIO can directly drive a load without checking current and voltage requirements.

Document level shifting, transistor/MOSFET drivers, resistors and protection components where required.
