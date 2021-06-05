extends KinematicBody


remote func server_move(transform: Transform):
    if get_tree().is_network_server():
        self.transform = transform
        for player in get_parent().players:
            if player != get_tree().get_rpc_sender_id():
                rpc_unreliable_id(player, "client_move", transform)

remote func client_move(transform: Transform):
    if not get_tree().is_network_server():
        self.transform = transform
