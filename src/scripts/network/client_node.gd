extends Node


const SERVER_IP := "127.0.0.1"
const SERVER_PORT := 63214
const MAX_PLAYERS := 4


func _ready():
	connect_signals()
	create_client()

func create_client():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

func connect_signals():
	if get_tree().connect("connected_to_server", self, "_on_connected_to_server") != OK:
		Log.error("Failed to connect signal.")
	if get_tree().connect("connection_failed", self, "_on_connection_failed") != OK:
		Log.error("Failed to connect signal.")
	if get_tree().connect("server_disconnected", self, "_on_server_disconnected") != OK:
		Log.error("Failed to connect signal.")

func _on_connected_to_server():
	print("Connection successful.")

func _on_connection_failed():
	print("Connection failed.")

func _on_server_disconnected():
	print("Server disconnected.")
