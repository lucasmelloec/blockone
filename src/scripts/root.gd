extends Node


export(PackedScene) var server_node: PackedScene
export(PackedScene) var client_node: PackedScene
export(PackedScene) var player_node: PackedScene

onready var chunk := $Chunk


func _ready():
    var is_singleplayer: bool = ProjectSettings.get_setting("application/config/singleplayer")

    if is_singleplayer or OS.has_feature("Server"):
        server_or_singleplayer(is_singleplayer)
    else:
        client_only()

    cleanup()
    # create_chunks()

func server_or_singleplayer(is_singleplayer = false):
    if is_singleplayer:
        add_child(player_node.instance())
    else:
        var network_node: Node = server_node.instance()
        network_node.name = 'NetworkNode'
        add_child(network_node)

func client_only():
    var network_node: Node = client_node.instance()
    network_node.name = 'NetworkNode'
    add_child(network_node)

func cleanup():
    server_node = null
    client_node = null
    player_node = null

func create_chunks():
    for x in range(11):
        for z in range(11):
            if x == 0 and z == 0:
                continue
            var newchunk = chunk.duplicate()
            newchunk.translate(Vector3((x) * 16, 0, (z) * 16))
            add_child(newchunk)

            var newchunk2 = chunk.duplicate()
            newchunk2.translate(Vector3(-(x) * 16, 0, -(z) * 16))
            add_child(newchunk2)

            var newchunk3 = chunk.duplicate()
            newchunk3.translate(Vector3(-(x) * 16, 0, (z) * 16))
            add_child(newchunk3)

            var newchunk4 = chunk.duplicate()
            newchunk4.translate(Vector3((x) * 16, 0, -(z) * 16))
            add_child(newchunk4)
