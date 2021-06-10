extends Spatial


export(Resource) var block_data: Resource
export(Resource) var texture_material: Resource

var surface_tool := SurfaceTool.new()


func _ready():
	var mesh_instance := MeshInstance.new()

	
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_material(texture_material)
	
	for face in block_data.BLOCK_TRIS:
		for i in face.size():
			surface_tool.add_uv(block_data.BLOCK_UVS[i])
			var index = face[i]
			surface_tool.add_vertex(block_data.BLOCK_VERTS[index])


	surface_tool.index()
	surface_tool.generate_normals()

	var mesh := surface_tool.commit()
	mesh_instance.mesh = mesh

	add_child(mesh_instance)
