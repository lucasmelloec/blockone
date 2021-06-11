extends Spatial


export(Resource) var block_data: Resource
export(Resource) var texture_material: Resource

var block_map := []


func _ready():
    generate()
    var mesh_data := create_blocks()
    generate_mesh(mesh_data[0], mesh_data[1])
    block_map = []

func generate():
    block_map.resize(block_data.CHUNK_SIZE.x)

    for x in block_data.CHUNK_SIZE.x:
        block_map[x] = []
        block_map[x].resize(block_data.CHUNK_SIZE.y)
        for y in block_data.CHUNK_SIZE.y:
            block_map[x][y] = []
            block_map[x][y].resize(block_data.CHUNK_SIZE.z)
            for z in block_data.CHUNK_SIZE.z:
                block_map[x][y][z] = true

func create_blocks() -> Array:
    var vertices := []
    var uvs := []

    for x in block_map.size():
        for y in block_map[x].size():
            for z in block_map[x][y].size():
                # Check if visible
                var face_check := check_transparent_neighbours(Vector3(x, y, z))
                if face_check.has(true):
                    add_block(vertices, uvs, Vector3(x, y, z), face_check)
    return [vertices, uvs]

func check_transparent_neighbours(pos: Vector3) -> Array:
    var has_back = is_block_transparent(pos + Vector3(0, 0, -1))
    var has_front = is_block_transparent(pos + Vector3(0, 0, 1))
    var has_top = is_block_transparent(pos + Vector3(0, 1, 0))
    var has_bottom = is_block_transparent(pos + Vector3(0, -1, 0))
    var has_left = is_block_transparent(pos + Vector3(-1, 0, 0))
    var has_right = is_block_transparent(pos + Vector3(1, 0, 0))
    
    return [has_back, has_front, has_top, has_bottom, has_left, has_right]

func is_block_transparent(pos: Vector3):
    if pos.x < 0 or pos.x >= block_data.CHUNK_SIZE.x or pos.z < 0 or pos.z >= block_data.CHUNK_SIZE.z or pos.y < 0 or pos.y >= block_data.CHUNK_SIZE.y:
        # For out of bounds lets still show the face
        return true
    else:
        return !block_map[pos.x][pos.y][pos.z]

func add_block(vertices, uvs, pos: Vector3, face_check: Array):
    for face_index in block_data.BLOCK_TRIS.size():
        var face = block_data.BLOCK_TRIS[face_index]
        if face_check[face_index]:
            for i in face.size():
                var index = face[i]
                uvs.append(block_data.BLOCK_UVS[i])
                vertices.append(block_data.BLOCK_VERTS[index] + pos)

func generate_mesh(vertices, uvs):
    var surface_tool := SurfaceTool.new()
    var mesh_instance := MeshInstance.new()

    surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
    surface_tool.set_material(texture_material)

    for i in vertices.size():
        surface_tool.add_uv(uvs[i])
        surface_tool.add_vertex(vertices[i])
       
    # surface_tool.index()
    surface_tool.generate_normals()
    surface_tool.generate_tangents()

    var mesh := surface_tool.commit()
    mesh_instance.mesh = mesh

    add_child(mesh_instance)
