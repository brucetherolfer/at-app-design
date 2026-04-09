"""
Blender 5.1 render script — AT App Torus UI
Produces: torus_loop.mp4 (1080x1080, 30fps, 6 second seamless loop)
Run with:
  /Applications/Blender.app/Contents/MacOS/blender --background --python render_torus.py
"""

import bpy
import bmesh
import math
import os

print("\n=== AT Torus Render — Starting ===\n")

# ── Reset to empty scene ──────────────────────────────────────
bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene

# ── Render settings ───────────────────────────────────────────
scene.render.engine = 'BLENDER_EEVEE'
scene.render.resolution_x = 1080
scene.render.resolution_y = 1080
scene.render.fps = 30
scene.frame_start = 1
scene.frame_end = 180   # frames 1-180 = perfect 6-second loop (181 = same as 1)

FRAMES_DIR = '/Users/kathefaraci/Documents/GitHub/AT APP/general-public-app/torus-ui/render/frames/'
os.makedirs(FRAMES_DIR, exist_ok=True)
scene.render.filepath = FRAMES_DIR + 'frame_'
scene.render.image_settings.file_format = 'PNG'
scene.render.image_settings.color_mode = 'RGB'
scene.render.image_settings.compression = 15  # fast, not maximum compression

# Motion blur adds trailing glow to the light streaks
scene.render.use_motion_blur = True
scene.render.motion_blur_shutter = 0.4

print("Render settings: OK")

# ── World: pure black ─────────────────────────────────────────
world = bpy.data.worlds.new('World')
scene.world = world
world.use_nodes = True
bg = world.node_tree.nodes['Background']
bg.inputs[0].default_value = (0, 0, 0, 1)
bg.inputs[1].default_value = 0.0

# ── Camera ────────────────────────────────────────────────────
# Position: slightly above and in front → ring appears as ellipse
bpy.ops.object.camera_add(location=(0, -5.2, 4.8))
cam = bpy.context.active_object
cam.rotation_euler = (math.radians(47), 0, 0)
cam.data.lens = 52
cam.data.clip_start = 0.1
cam.data.clip_end = 100.0
scene.camera = cam

print("Camera: OK")

# ── Emission material factory ─────────────────────────────────
def make_emit(name, r, g, b, strength):
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    nt = mat.node_tree
    nt.nodes.clear()
    out = nt.nodes.new('ShaderNodeOutputMaterial')
    em  = nt.nodes.new('ShaderNodeEmission')
    em.inputs['Color'].default_value    = (r, g, b, 1.0)
    em.inputs['Strength'].default_value = strength
    nt.links.new(em.outputs[0], out.inputs[0])
    return mat

# ── Full torus ────────────────────────────────────────────────
# rot_y tilts each trail slightly off-axis → gives 3D wound-light look
def add_torus(major_r, minor_r, rot_y, mat, name):
    bpy.ops.mesh.primitive_torus_add(
        major_radius    = major_r,
        minor_radius    = minor_r,
        major_segments  = 256,
        minor_segments  = 32,
        location        = (0, 0, 0),
        rotation        = (math.pi / 2, rot_y, 0)
    )
    obj = bpy.context.active_object
    obj.name = name
    obj.data.materials.clear()
    obj.data.materials.append(mat)
    return obj

# ── Partial torus (arc) ───────────────────────────────────────
# Deletes faces outside the arc angle range (in local mesh space)
def add_arc(major_r, minor_r, arc_angle, mat, name):
    bpy.ops.mesh.primitive_torus_add(
        major_radius    = major_r,
        minor_radius    = minor_r,
        major_segments  = 256,
        minor_segments  = 32,
        location        = (0, 0, 0),
        rotation        = (math.pi / 2, 0, 0)
    )
    obj = bpy.context.active_object
    obj.name = name
    obj.data.materials.clear()
    obj.data.materials.append(mat)

    # Trim to arc — in local mesh space (before rotation applied),
    # the torus ring is in the XY plane, so angle = atan2(y, x)
    bm = bmesh.new()
    bm.from_mesh(obj.data)
    bm.faces.ensure_lookup_table()

    to_delete = []
    for face in bm.faces:
        c = face.calc_center_median()
        angle = math.atan2(c.y, c.x)
        if angle < 0:
            angle += math.pi * 2
        if angle > arc_angle:
            to_delete.append(face)

    bmesh.ops.delete(bm, geom=to_delete, context='FACES')
    bm.to_mesh(obj.data)
    bm.free()
    return obj

# ── Parent empty: all objects attach here for group rotation ──
bpy.ops.object.empty_add(type='PLAIN_AXES', location=(0, 0, 0))
ring_group = bpy.context.active_object
ring_group.name = 'RingGroup'

# ── Blue/indigo wound light trails ───────────────────────────
# Each pair has a ±rot_y offset — they diverge slightly,
# giving the organic multi-strand wound look from the reference
trail_defs = [
    # minor_r,   R,    G,    B,   strength,  rot_y
    (0.010,   0.56, 0.45, 0.96,   14.0,   0.000),   # bright core
    (0.009,   0.51, 0.41, 0.91,   10.5,   0.016),
    (0.009,   0.51, 0.41, 0.91,   10.5,  -0.016),
    (0.008,   0.45, 0.35, 0.85,    8.0,   0.032),
    (0.008,   0.45, 0.35, 0.85,    8.0,  -0.032),
    (0.007,   0.39, 0.29, 0.79,    6.5,   0.050),
    (0.007,   0.39, 0.29, 0.79,    6.5,  -0.050),
    (0.006,   0.33, 0.23, 0.71,    5.0,   0.070),
    (0.006,   0.33, 0.23, 0.71,    5.0,  -0.070),
    (0.005,   0.26, 0.18, 0.61,    3.5,   0.092),
    (0.005,   0.26, 0.18, 0.61,    3.5,  -0.092),
    (0.004,   0.19, 0.13, 0.50,    2.2,   0.116),
    (0.004,   0.19, 0.13, 0.50,    2.2,  -0.116),
    (0.003,   0.13, 0.08, 0.38,    1.2,   0.142),
    (0.003,   0.13, 0.08, 0.38,    1.2,  -0.142),
]

for i, (mr, r, g, b, s, ry) in enumerate(trail_defs):
    mat = make_emit(f'Blue_{i}', r, g, b, s)
    obj = add_torus(1.60, mr, ry, mat, f'Trail_{i}')
    obj.parent = ring_group

print(f"Blue trails: {len(trail_defs)} created")

# ── Gold arc — layered glow falloff ──────────────────────────
# Each layer: slightly different arc span + colour for depth
gold_defs = [
    # minor_r, arc_frac,   R,    G,    B,  strength
    (0.022,    0.32,    0.50, 0.15, 0.01,   5.0),   # deep outer glow — narrower
    (0.014,    0.28,    0.80, 0.32, 0.02,   9.0),   # mid orange
    (0.009,    0.22,    1.00, 0.55, 0.04,  14.0),   # bright amber core
    (0.005,    0.14,    1.00, 0.80, 0.18,  18.0),   # warm gold
    (0.003,    0.08,    1.00, 0.94, 0.55,  24.0),   # white-hot highlight
]

for i, (mr, arc_frac, r, g, b, s) in enumerate(gold_defs):
    mat = make_emit(f'Gold_{i}', r, g, b, s)
    arc_angle = arc_frac * math.pi * 2
    obj = add_arc(1.60, mr, arc_angle, mat, f'Gold_{i}')
    obj.parent = ring_group

print(f"Gold arc: {len(gold_defs)} layers created")

# ── Animate: full spin over 180 frames → seamless loop ────────
# Rotate around Y axis (torus axis of symmetry after X rotation)
ring_group.rotation_euler = (0, 0, 0)
ring_group.keyframe_insert('rotation_euler', frame=1)
ring_group.rotation_euler = (0, math.pi * 2, 0)
ring_group.keyframe_insert('rotation_euler', frame=181)

# Linear interpolation = constant speed = perfect seamless loop
# Blender 5.1 moved fcurves into a layered action structure
action = ring_group.animation_data.action
try:
    fcurves = action.fcurves
except AttributeError:
    fcurves = []
    for layer in action.layers:
        for strip in layer.strips:
            for channelbag in strip.channelbags:
                fcurves.extend(channelbag.fcurves)
for fc in fcurves:
    for kp in fc.keyframe_points:
        kp.interpolation = 'LINEAR'

print("Animation keyframes: OK")

# ── Compositor: Bloom via Glare node ─────────────────────────
scene.render.use_compositing = True
cg = bpy.data.node_groups.new('Compositor', 'CompositorNodeTree')
scene.compositing_node_group = cg

rl    = cg.nodes.new('CompositorNodeRLayers')
glare = cg.nodes.new('CompositorNodeGlare')
out   = cg.nodes.new('NodeGroupOutput')

# Bloom settings
glare.inputs['Type'].default_value       = 'Bloom'
glare.inputs['Threshold'].default_value  = 0.0    # glow everything above 0
glare.inputs['Strength'].default_value   = 1.2    # bloom intensity
glare.inputs['Size'].default_value       = 0.45   # bloom spread — tighter, black bg preserved
glare.inputs['Smoothness'].default_value = 0.5
glare.inputs['Maximum'].default_value    = 10.0

# Add output socket + wire everything up
cg.interface.new_socket('Image', in_out='OUTPUT', socket_type='NodeSocketColor')
cg.links.new(rl.outputs['Image'],    glare.inputs['Image'])
cg.links.new(glare.outputs['Image'], out.inputs['Image'])

print("Compositor bloom: OK")

# ── Render ────────────────────────────────────────────────────
print(f"\nRendering 180 frames to:\n  {FRAMES_DIR}\n")
bpy.ops.render.render(animation=True)
print(f"\n=== Frames done. Stitching MP4... ===\n")

import subprocess
MP4_OUT = '/Users/kathefaraci/Documents/GitHub/AT APP/general-public-app/torus-ui/render/torus_loop.mp4'
subprocess.run([
    '/opt/homebrew/bin/ffmpeg', '-y',
    '-framerate', '30',
    '-i', FRAMES_DIR + 'frame_%04d.png',
    '-c:v', 'libx264',
    '-preset', 'slow',
    '-crf', '18',
    '-pix_fmt', 'yuv420p',
    '-movflags', '+faststart',
    MP4_OUT
], check=True)
print(f"\n=== DONE — {MP4_OUT} ===\n")
