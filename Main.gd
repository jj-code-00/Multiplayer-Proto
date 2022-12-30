extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()

@onready var menu = $CenterContainer/Menu


func _on_join_pressed():
	multiplayer_peer.create_client(
		str($CenterContainer/Menu/IP.text),
		str($CenterContainer/Menu/Port.text).to_int())
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false
	
#func add_player_character(id=1):
#	var character = preload("res://Scenes/player_character.tscn").instantiate()
#	character.name = str(id)
#	add_child(character)
