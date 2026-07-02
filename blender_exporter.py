import bpy

### Wurde von KI geschrieben (Gemini) ###

# Get all currently selected objects
selected_objects = bpy.context.selected_objects

output = ""
var_names = []

for obj in selected_objects:
    if obj and obj.type == 'MESH':
        mesh = obj.data
        
        # Replace '.' with '_' and make the name lowercase
        var_name = obj.name.replace(".", "_").lower()
        var_names.append(var_name)
        
        # Vertices (Y-Up)
        points = [f"Vector3({v.co.x:.4f}, {v.co.z:.4f}, {v.co.y:.4f})" for v in mesh.vertices]
        # Faces
        faces = [list(p.vertices) for p in mesh.polygons]

        # Format as a GDScript Dictionary
        output += f"var {var_name} = {{\n"
        output += f"    'points': [{', '.join(points)}],\n"
        output += f"    'faces': {faces}\n"
        output += "}\n"

# Add the final array of all exported variable names at the bottom
if var_names:
    output += "\n[" + ", ".join(var_names) + "]"

# Write to Blender Text Editor
text_name = "Exported_Data"
out_text = bpy.data.texts.get(text_name) or bpy.data.texts.new(text_name)
out_text.clear()
out_text.write(output)