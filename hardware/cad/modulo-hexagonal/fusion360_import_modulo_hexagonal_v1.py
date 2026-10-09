"""REAKT modulo hexagonal estilo referencia Tinkercad.

Ejecutar dentro de Autodesk Fusion 360 como script Python.
Estado: conceptual, no validado fisicamente.

Forma visual:
- base/piso hexagonal azul
- pared exterior azul alta
- ranuras claras alrededor
- aro interior rojo elevado
"""

import math
import adsk.core
import adsk.fusion


CM_PER_MM = 0.1


def mm(value):
    return value * CM_PER_MM


def point3d(x, y):
    return adsk.core.Point3D.create(mm(x), mm(y), 0)


def hex_points(radius_mm):
    pts = []
    for i in range(6):
        a = math.radians(60 * i + 30)
        pts.append((radius_mm * math.cos(a), radius_mm * math.sin(a)))
    return pts


def plane_at_z(root, z_mm):
    if abs(z_mm) < 0.0001:
        return root.xYConstructionPlane
    planes = root.constructionPlanes
    plane_input = planes.createInput()
    plane_input.setByOffset(root.xYConstructionPlane, adsk.core.ValueInput.createByReal(mm(z_mm)))
    return planes.add(plane_input)


def polygon_profile(root, name, points, z_mm):
    sketch = root.sketches.add(plane_at_z(root, z_mm))
    sketch.name = name
    lines = sketch.sketchCurves.sketchLines
    for i, p in enumerate(points):
        q = points[(i + 1) % len(points)]
        lines.addByTwoPoints(point3d(p[0], p[1]), point3d(q[0], q[1]))
    return sketch.profiles.item(0)


def hex_ring_profile(root, name, outer_radius, inner_radius, z_mm):
    sketch = root.sketches.add(plane_at_z(root, z_mm))
    sketch.name = name
    lines = sketch.sketchCurves.sketchLines
    for pts in [hex_points(outer_radius), hex_points(inner_radius)]:
        for i, p in enumerate(pts):
            q = pts[(i + 1) % len(pts)]
            lines.addByTwoPoints(point3d(p[0], p[1]), point3d(q[0], q[1]))

    profile = sketch.profiles.item(0)
    best_area = profile.areaProperties().area
    for i in range(1, sketch.profiles.count):
        candidate = sketch.profiles.item(i)
        area = candidate.areaProperties().area
        if area > best_area:
            profile = candidate
            best_area = area
    return profile


def extrude(root, profile, height_mm, name):
    distance = adsk.core.ValueInput.createByReal(mm(height_mm))
    feat = root.features.extrudeFeatures.addSimple(
        profile,
        distance,
        adsk.fusion.FeatureOperations.NewBodyFeatureOperation,
    )
    feat.name = name
    feat.bodies.item(0).name = name
    return feat.bodies.item(0)


def make_hex_plate(root, name, radius, z_mm, height_mm):
    return extrude(root, polygon_profile(root, name + "_sketch", hex_points(radius), z_mm), height_mm, name)


def make_hex_ring(root, name, outer_radius, inner_radius, z_mm, height_mm):
    return extrude(root, hex_ring_profile(root, name + "_sketch", outer_radius, inner_radius, z_mm), height_mm, name)


def make_box(root, name, cx, cy, z, sx, sy, sz):
    sketch = root.sketches.add(plane_at_z(root, z))
    sketch.name = name + "_sketch"
    sketch.sketchCurves.sketchLines.addTwoPointRectangle(
        point3d(cx - sx / 2, cy - sy / 2),
        point3d(cx + sx / 2, cy + sy / 2),
    )
    return extrude(root, sketch.profiles.item(0), sz, name)


def make_side_slots(root, side_index, outer_radius, z_base, slot_height):
    pts = hex_points(outer_radius - 6)
    a = pts[side_index]
    b = pts[(side_index + 1) % 6]
    dx = b[0] - a[0]
    dy = b[1] - a[1]
    length = math.hypot(dx, dy)
    ux = dx / length
    uy = dy / length
    nx = -uy
    ny = ux
    if a[0] * nx + a[1] * ny < 0:
        nx = -nx
        ny = -ny

    count = 10
    slot_w = 3.0
    slot_d = 2.0
    margin = 9
    for i in range(count):
        t = (i + 0.5) / count
        cx = a[0] + ux * (margin + t * (length - 2 * margin))
        cy = a[1] + uy * (margin + t * (length - 2 * margin))
        cx -= nx * 1.4
        cy -= ny * 1.4
        make_box(root, f"ranura clara lado {side_index + 1}-{i + 1}", cx, cy, z_base, slot_w, slot_d, slot_height)


def run(context):
    app = adsk.core.Application.get()
    ui = app.userInterface
    app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType)
    design = app.activeProduct
    if not isinstance(design, adsk.fusion.Design):
        ui.messageBox("Abrir un documento de diseño Fusion antes de ejecutar el script.")
        return

    root = design.rootComponent

    outer_radius = 78
    outer_inner_radius = 66
    floor_radius = 62
    red_outer = 58
    red_inner = 46

    make_hex_plate(root, "piso hexagonal azul", floor_radius, 0, 4)
    make_hex_ring(root, "pared exterior azul con forma hexagonal", outer_radius, outer_inner_radius, 0, 18)
    make_hex_ring(root, "borde superior azul", outer_radius, outer_radius - 6, 17, 4)
    make_hex_ring(root, "aro interior rojo elevado", red_outer, red_inner, 4, 10)
    make_hex_ring(root, "borde rojo superior", red_outer, red_outer - 5, 14, 3)

    for side in range(6):
        make_side_slots(root, side, outer_radius, 5, 10)

    ui.messageBox("Modelo REAKT creado segun la referencia: hexagono azul con ranuras y aro rojo interno.")
