extends Node

@onready var main = get_tree().get_root().get_node("Main")

@rpc
func kick(player_id):
	pass

@rpc(call_remote)
func kick_client(player_id):
	get_tree().quit()

@rpc
func request_color_change(target_id, requester_id, color):
	rpc_id(1,"request_color_change",target_id, requester_id, color)
	
@rpc(call_remote)
func get_color_change(target_id, requester_id, color):
	main.get_node(str(target_id)).get_node("Sprite2D").modulate = color

@rpc
func get_inputs(requester_id,event):
	rpc_id(1,"get_inputs",requester_id,event)

@rpc(unreliable)
func get_movement(requester, movement_vector):
	rpc_id(1,"get_movement",requester, movement_vector)

@rpc(call_remote)
func update_position(target_id,client_position):
	pass

@rpc(call_remote, unreliable)
func update_position_client(target_id, client_position):
	main.get_node(str(target_id)).global_position = client_position

@rpc
func update_GUI(target_id, health_percent, ki_percent):
	pass

@rpc(call_remote)
func update_GUI_client(target_id, health_percent, ki_percent):
	main.get_node(str(target_id)).set_ki_bar(ki_percent)
	main.get_node(str(target_id)).set_health_bar(health_percent)

@rpc
func client_ready(client_id):
	rpc_id(1,"client_ready",client_id)

@rpc
func get_stats(player_id):
	rpc_id(1,"get_stats",player_id)

@rpc(call_remote)
func receive_stats(player_id,stats):
	main.get_node(str(player_id)).get_node("GUI").stats = stats.duplicate()
