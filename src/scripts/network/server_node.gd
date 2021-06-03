extends Node


const SERVER_PORT := 63214
const MAX_PLAYERS := 4

onready var player_manager := $PlayerManager


func _ready():
	connect_signals()
	create_server()

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func connect_signals():
	if get_tree().connect("network_peer_connected", self, "_on_player_connected") != OK:
		Log.error("Failed to connect signal.")
	if get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected") != OK:
		Log.error("Failed to connect signal.")

func _on_player_connected(id: int):
	player_manager.server_new_player(id)

func _on_player_disconnected(id: int):
	player_manager.server_remove_player(id)
