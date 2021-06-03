extends Node


export(PackedScene) var server_node: PackedScene
export(PackedScene) var client_node: PackedScene
export(PackedScene) var player_node: PackedScene

onready var gridmap = $GridMap


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
	
	# create_chunks()

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
			var newgridmap = gridmap.duplicate()
			newgridmap.translate(Vector3((x) * 32, 0, (z) * 32))
			add_child(newgridmap)

			var newgridmap2 = gridmap.duplicate()
			newgridmap2.translate(Vector3(-(x) * 32, 0, -(z) * 32))
			add_child(newgridmap2)

			var newgridmap3 = gridmap.duplicate()
			newgridmap3.translate(Vector3(-(x) * 32, 0, (z) * 32))
			add_child(newgridmap3)

			var newgridmap4 = gridmap.duplicate()
			newgridmap4.translate(Vector3((x) * 32, 0, -(z) * 32))
			add_child(newgridmap4)
