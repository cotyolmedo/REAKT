const fs = require("fs");
const path = require("path");

const outDir = __dirname;
const objPath = path.join(outDir, "reakt_modulo_hexagonal_v1.obj");
const mtlPath = path.join(outDir, "reakt_modulo_hexagonal_v1.mtl");

let vertices = [];
let faces = [];
let currentMaterial = "blue";

function v(x, y, z) {
  vertices.push([x, y, z]);
  return vertices.length;
}

function use(mat) {
  currentMaterial = mat;
}

function f(indices) {
  faces.push({ mat: currentMaterial, indices });
}

function hexPoints(r, rotDeg = 30) {
  return Array.from({ length: 6 }, (_, i) => {
    const a = (Math.PI / 180) * (rotDeg + 60 * i);
    return [r * Math.cos(a), r * Math.sin(a)];
  });
}

function prism(pts, z0, z1) {
  const bottom = pts.map(([x, y]) => v(x, y, z0));
  const top = pts.map(([x, y]) => v(x, y, z1));
  f([...bottom].reverse());
  f(top);
  for (let i = 0; i < pts.length; i++) {
    const j = (i + 1) % pts.length;
    f([bottom[i], bottom[j], top[j], top[i]]);
  }
}

function ringHex(rOuter, rInner, z0, z1) {
  const outer = hexPoints(rOuter);
  const inner = hexPoints(rInner);
  const ob = outer.map(([x, y]) => v(x, y, z0));
  const ot = outer.map(([x, y]) => v(x, y, z1));
  const ib = inner.map(([x, y]) => v(x, y, z0));
  const it = inner.map(([x, y]) => v(x, y, z1));
  for (let i = 0; i < 6; i++) {
    const j = (i + 1) % 6;
    f([ob[i], ob[j], ot[j], ot[i]]);
    f([ib[j], ib[i], it[i], it[j]]);
    f([ot[i], ot[j], it[j], it[i]]);
    f([ob[j], ob[i], ib[i], ib[j]]);
  }
}

function box(cx, cy, cz, sx, sy, sz) {
  const x0 = cx - sx / 2, x1 = cx + sx / 2;
  const y0 = cy - sy / 2, y1 = cy + sy / 2;
  const z0 = cz, z1 = cz + sz;
  const ids = [
    v(x0, y0, z0), v(x1, y0, z0), v(x1, y1, z0), v(x0, y1, z0),
    v(x0, y0, z1), v(x1, y0, z1), v(x1, y1, z1), v(x0, y1, z1),
  ];
  f([ids[0], ids[1], ids[2], ids[3]]);
  f([ids[4], ids[7], ids[6], ids[5]]);
  f([ids[0], ids[4], ids[5], ids[1]]);
  f([ids[1], ids[5], ids[6], ids[2]]);
  f([ids[2], ids[6], ids[7], ids[3]]);
  f([ids[3], ids[7], ids[4], ids[0]]);
}

const outerR = 78;
const innerR = 66;
const floorR = 62;

use("blue");
prism(hexPoints(floorR), 0, 4);
use("dark_blue");
ringHex(outerR, innerR, 0, 18);
ringHex(outerR, outerR - 6, 17, 21);
use("red");
ringHex(58, 46, 4, 14);
use("dark_red");
ringHex(58, 53, 14, 17);

use("slot_light");
for (let side = 0; side < 6; side++) {
  const pts = hexPoints(outerR - 6);
  const a = pts[side];
  const b = pts[(side + 1) % 6];
  for (let i = 0; i < 10; i++) {
    const t = (i + 0.5) / 10;
    box(a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, 5, 3, 2, 10);
  }
}

const mtl = `newmtl blue
Kd 0.08 0.20 0.55
newmtl dark_blue
Kd 0.04 0.12 0.34
newmtl red
Kd 0.86 0.02 0.06
newmtl dark_red
Kd 0.74 0.01 0.05
newmtl slot_light
Kd 0.92 0.95 0.93
`;

let obj = "# REAKT modulo hexagonal estilo referencia - unidades mm\n";
obj += "mtllib reakt_modulo_hexagonal_v1.mtl\n";
for (const [x, y, z] of vertices) obj += `v ${x.toFixed(4)} ${y.toFixed(4)} ${z.toFixed(4)}\n`;
let lastMat = "";
for (const face of faces) {
  if (face.mat !== lastMat) {
    obj += `usemtl ${face.mat}\n`;
    lastMat = face.mat;
  }
  obj += `f ${face.indices.join(" ")}\n`;
}

fs.writeFileSync(objPath, obj, "utf8");
fs.writeFileSync(mtlPath, mtl, "utf8");
console.log(objPath);
