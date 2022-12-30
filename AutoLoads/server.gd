extends Node

@rpc
func request_color_change(target_id, requester_id, color):
	rpc_id(1,"request_color_change",target_id, requester_id, color)
	
@rpc(call_remote)
func get_color_change(target_id, requester_id, color):
	get_tree().get_root().get_node("Main").get_node(str(target_id)).change_color(color)
