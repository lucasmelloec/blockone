extends Node


export(PackedScene) var server_node: PackedScene
export(PackedScene) var client_node: PackedScene
export(PackedScene) var player_node: PackedScene


func _ready():
    var is_singleplayer: bool = ProjectSettings.get_setting("application/config/singleplayer")

    if is_singleplayer or OS.has_feature("Server"):
        server_or_singleplayer(is_singleplayer)
    else:
        client_only()

    cleanup()

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
