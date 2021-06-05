extends Node


export(PackedScene) var remote_player: PackedScene
export(PackedScene) var player: PackedScene

var players: PoolIntArray


func server_new_player(player_id: int):
	rpc_id(player_id, "client_spawn_multiple_players", players)
	players.append(player_id)

	rpc('client_spawn_player', player_id)

	var new_player := remote_player.instance()
	new_player.name = str(player_id)
	add_child(new_player)

func server_remove_player(player_id: int):
	rpc('client_despawn_player', player_id)
	
	for idx in range(players.size()):
		if players[idx] == player_id:
			players.remove(idx)
			break
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()

remote func client_spawn_player(player_id: int):
	var new_player: Node

	if get_tree().get_network_unique_id() == player_id:
		new_player = player.instance()
	else:
		new_player = remote_player.instance()

	new_player.name = str(player_id)
	add_child(new_player, true)

remote func client_spawn_multiple_players(players_ids: PoolIntArray):
	for player_id in players_ids:
		client_spawn_player(player_id)

remote func client_despawn_player(player_id: int):
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()
