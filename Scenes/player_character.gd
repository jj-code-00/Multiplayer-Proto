extends CharacterBody2D

var speed = 250

@export
var attacking = false
@export
var motion = Vector2()
@export
var meditating = false

var facing = Vector2.ZERO

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var health_bar = $GUI/MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/CenterContainer/VBoxContainer/Health
@onready var ki_bar = $GUI/MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/CenterContainer/VBoxContainer/Ki
@onready var stat_menu = $GUI/MarginContainer/CenterContainer/TabContainer

func _ready():
	facing = motion
	animation_state.travel("Idle")
	if str(name).is_valid_int():
		set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		$Camera2D.current = true
		$GUI.visible = true

func _process(delta):
	select_animation()

func _physics_process(delta):
	if is_multiplayer_authority():
		motion.y = Input.get_axis("i_up","i_down")
		motion.x = Input.get_axis("i_left","i_right")
		Server.get_movement(str(name),motion)
		if motion != Vector2.ZERO:
			setBlendPos()
			facing = motion

func _input(event):
	if is_multiplayer_authority():
		if event.is_action_pressed("i_attack") && !attacking:
			Server.get_inputs(str(name),"i_attack")
			attacking = true
			# replace this with getting cd from server
			$"Timers/Attack Animation CD".start(.2)
		if event.is_action_pressed("i_stat_menu"):
			if !stat_menu.visible:
				stat_menu.visible = true
			else : stat_menu.visible = false
		if event.is_action_pressed("i_meditate"):
			Server.get_inputs(str(name),"i_meditate")
			if !meditating:
				meditating = true
				
			else:
				meditating = false

func setBlendPos():
	animation_tree.set("parameters/Idle/blend_position", motion)
	animation_tree.set("parameters/Walk/blend_position", motion)
	animation_tree.set("parameters/Attack/blend_position", motion) 

func select_animation():
	if meditating: animation_state.travel("i_meditate")
	elif attacking: animation_state.travel("Attack")
	elif(motion == Vector2.ZERO):
			animation_state.travel("Idle")
	else: animation_state.travel("Walk")

func _on_attack_animation_cd_timeout():
	attacking = false

func set_ki_bar(value):
	ki_bar.value = value

func set_health_bar(value):
	health_bar.value = value

func _on_ready():
	Server.client_ready(str(name).to_int())
