import bpy

### Wurde von KI geschrieben (Gemini) ###

# Get all currently selected objects
selected_objects = bpy.context.selected_objects

output = ""
var_names = []

for obj in selected_objects:
    if obj and obj.type == 'MESH':
        mesh = obj.data
        
        # Force Blender to calculate triangles for the mesh (handles quads/n-gons)
        mesh.calc_loop_triangles()
        
        # Replace '.' with '_' and make the name lowercase
        var_name = obj.name.replace(".", "_").lower()
        var_names.append(var_name)
        
        # Vertices (Y-Up conversion)
        points = [f"Vector3({v.co.x:.4f}, {v.co.z:.4f}, {v.co.y:.4f})" for v in mesh.vertices]
        
        # Extract indices for each calculated triangle
        triangles = [list(loop_tri.vertices) for loop_tri in mesh.loop_triangles]

        # Format as a GDScript Dictionary
        output += f"var {var_name} = {{\n"
        output += f"    'points': [{', '.join(points)}],\n"
        output += f"    'triangles': {triangles}\n"
        output += "}\n\n"

# Add the final array of all exported variable names at the bottom
if var_names:
    output += "[" + ", ".join(var_names) + "]"

# Write to Blender Text Editor
text_name = "Exported_Data"
out_text = bpy.data.texts.get(text_name) or bpy.data.texts.new(text_name)
out_text.clear()
out_text.write(output)