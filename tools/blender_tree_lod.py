"""
Blender script to automatically create LOD levels for tree models
Usage: Open trees.blend, then run this script from Blender's Text Editor
"""

import bpy

# LOD configuration
LOD_RATIOS = {
    "LOD0": 1.0,    # Full detail (original)
    "LOD1": 0.4,    # 40% - Medium distance
    "LOD2": 0.15,   # 15% - Far distance
    "LOD3": 0.05,   # 5%  - Very far (simplified billboard-like)
}

# Distance thresholds for each LOD (in meters)
LOD_DISTANCES = {
    "LOD0": 0,      # 0-20m
    "LOD1": 20,     # 20-50m
    "LOD2": 50,     # 50-100m
    "LOD3": 100,    # 100m+
}


def create_lod_for_mesh(base_mesh_name):
    """Create all LOD levels for a given mesh"""

    # Get base mesh
    if base_mesh_name not in bpy.data.objects:
        print(f"Warning: {base_mesh_name} not found")
        return

    base_obj = bpy.data.objects[base_mesh_name]

    # Clear existing LODs
    for lod_name in [f"{base_mesh_name}_{lod}" for lod in LOD_RATIOS.keys()]:
        if lod_name in bpy.data.objects:
            bpy.data.objects.remove(bpy.data.objects[lod_name], do_unlink=True)

    # Create LOD0 (rename original)
    base_obj.name = f"{base_mesh_name}_LOD0"

    # Create other LOD levels
    for lod_level, ratio in list(LOD_RATIOS.items())[1:]:  # Skip LOD0
        # Duplicate base mesh
        lod_obj = base_obj.copy()
        lod_obj.data = base_obj.data.copy()
        lod_obj.name = f"{base_mesh_name}_{lod_level}"
        bpy.context.collection.objects.link(lod_obj)

        # Add decimate modifier
        decimate = lod_obj.modifiers.new(name="Decimate", type='DECIMATE')
        decimate.ratio = ratio
        decimate.use_collapse_triangulate = True

        # Apply modifier
        bpy.context.view_layer.objects.active = lod_obj
        bpy.ops.object.modifier_apply(modifier="Decimate")

        print(f"Created {lod_obj.name} with {ratio*100}% polygons")


def main():
    """Main function to create LODs for all tree meshes"""

    # List of tree meshes to process (adjust to your actual mesh names)
    tree_meshes = [
        "tree_01",
        "tree_02",
        # Add more tree names here if you have them
    ]

    for tree_name in tree_meshes:
        print(f"\n=== Creating LODs for {tree_name} ===")
        create_lod_for_mesh(tree_name)

    print("\n=== LOD Creation Complete ===")
    print("Now export each tree with all LOD meshes selected")


# Run the script
if __name__ == "__main__":
    main()
