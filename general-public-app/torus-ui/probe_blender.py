import bpy
bpy.ops.wm.read_factory_settings(use_empty=True)
node_group = bpy.data.node_groups.new("C", "CompositorNodeTree")
nt = node_group
glare = nt.nodes.new('CompositorNodeGlare')
type_input = glare.inputs['Type']
for val in ['Fog Glow', 'FOG_GLOW', 'Bloom', 'BLOOM', 'Simple Star', 'SIMPLE_STAR', 'Ghosts', 'GHOSTS', 'Streaks', 'STREAKS']:
    try:
        type_input.default_value = val
        print(f"OK: '{val}' -> {type_input.default_value}")
    except Exception as e:
        print(f"FAIL: '{val}' -> {e}")
