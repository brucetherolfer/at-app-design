"""Quick single-frame test — renders frame 1 as a PNG to check the scene."""
import bpy, bmesh, math, os

bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene
scene.render.engine = 'BLENDER_EEVEE'
scene.render.resolution_x = 1080
scene.render.resolution_y = 1080

OUTPUT = '/Users/kathefaraci/Documents/GitHub/AT APP/general-public-app/torus-ui/render/test_frame'
os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
scene.render.filepath = OUTPUT
scene.render.image_settings.file_format = 'PNG'
scene.render.use_motion_blur = False  # off for test speed

world = bpy.data.worlds.new('World')
scene.world = world
world.use_nodes = True
world.node_tree.nodes['Background'].inputs[0].default_value = (0,0,0,1)
world.node_tree.nodes['Background'].inputs[1].default_value = 0.0

bpy.ops.object.camera_add(location=(0, -5.6, 2.1))
cam = bpy.context.active_object
cam.rotation_euler = (math.radians(69), 0, 0)
cam.data.lens = 52
scene.camera = cam

def make_emit(name, r, g, b, s):
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    nt = mat.node_tree; nt.nodes.clear()
    out = nt.nodes.new('ShaderNodeOutputMaterial')
    em  = nt.nodes.new('ShaderNodeEmission')
    em.inputs['Color'].default_value = (r,g,b,1.0)
    em.inputs['Strength'].default_value = s
    nt.links.new(em.outputs[0], out.inputs[0])
    return mat

def add_torus(R, r, ry, mat, name):
    bpy.ops.mesh.primitive_torus_add(major_radius=R, minor_radius=r,
        major_segments=128, minor_segments=16,
        location=(0,0,0), rotation=(math.pi/2, ry, 0))
    obj = bpy.context.active_object
    obj.name = name
    obj.data.materials.clear(); obj.data.materials.append(mat)
    return obj

def add_arc(R, r, arc_angle, mat, name):
    bpy.ops.mesh.primitive_torus_add(major_radius=R, minor_radius=r,
        major_segments=128, minor_segments=16,
        location=(0,0,0), rotation=(math.pi/2, 0, 0))
    obj = bpy.context.active_object
    obj.name = name
    obj.data.materials.clear(); obj.data.materials.append(mat)
    bm = bmesh.new(); bm.from_mesh(obj.data); bm.faces.ensure_lookup_table()
    to_del = [f for f in bm.faces if
              (lambda a: a if a >= 0 else a + math.pi*2)(math.atan2(f.calc_center_median().y, f.calc_center_median().x)) > arc_angle]
    bmesh.ops.delete(bm, geom=to_del, context='FACES')
    bm.to_mesh(obj.data); bm.free()
    return obj

bpy.ops.object.empty_add(type='PLAIN_AXES', location=(0,0,0))
rg = bpy.context.active_object; rg.name = 'RingGroup'

for i,(mr,r,g,b,s,ry) in enumerate([
    (0.010,0.56,0.45,0.96,14.0,0.000),(0.009,0.51,0.41,0.91,10.5,0.016),
    (0.009,0.51,0.41,0.91,10.5,-0.016),(0.007,0.39,0.29,0.79,6.5,0.050),
    (0.007,0.39,0.29,0.79,6.5,-0.050),(0.005,0.26,0.18,0.61,3.5,0.092),
    (0.005,0.26,0.18,0.61,3.5,-0.092),(0.003,0.13,0.08,0.38,1.2,0.142),
    (0.003,0.13,0.08,0.38,1.2,-0.142),
]):
    obj = add_torus(1.60,mr,ry,make_emit(f'B{i}',r,g,b,s),f'T{i}')
    obj.parent = rg

for i,(mr,af,r,g,b,s) in enumerate([
    (0.030,0.42,0.55,0.18,0.01,6.0),(0.013,0.32,1.00,0.58,0.04,16.0),
    (0.004,0.12,1.00,0.96,0.60,30.0),
]):
    obj = add_arc(1.60,mr,af*math.pi*2,make_emit(f'G{i}',r,g,b,s),f'G{i}')
    obj.parent = rg

# Compositor bloom
scene.render.use_compositing = True
cg = bpy.data.node_groups.new('Compositor','CompositorNodeTree')
scene.compositing_node_group = cg
rl = cg.nodes.new('CompositorNodeRLayers')
gl = cg.nodes.new('CompositorNodeGlare')
ot = cg.nodes.new('NodeGroupOutput')
gl.inputs['Type'].default_value = 'Bloom'
gl.inputs['Threshold'].default_value = 0.0
gl.inputs['Strength'].default_value = 1.8
gl.inputs['Size'].default_value = 0.65
cg.interface.new_socket('Image', in_out='OUTPUT', socket_type='NodeSocketColor')
cg.links.new(rl.outputs['Image'], gl.inputs['Image'])
cg.links.new(gl.outputs['Image'], ot.inputs['Image'])

print("Rendering test frame...")
bpy.ops.render.render(write_still=True)
print(f"Done: {OUTPUT}.png")
