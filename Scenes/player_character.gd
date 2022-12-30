extends CharacterBody2D

var speed = 250

@export
var synced_position := Vector2()

@export
var motion = Vector2()
var facing

var attacking = false

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	facing = motion
	animation_state.travel("Idle")
	position = synced_position
	$"HurtBox/HurtBox Collision Shape".disabled = true
	if str(name).is_valid_int():
		set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		$Camera2D.current = true

func _process(delta):
	if not attacking:
		select_animation()

func _physics_process(delta):
	if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
		synced_position = position
		motion.y = Input.get_axis("i_up","i_down")
		motion.x = Input.get_axis("i_left","i_right")
		if motion != Vector2.ZERO:
			setBlendPos()
			facing = motion
		
	else:
		position = synced_position
	motion = motion.normalized()
	velocity = motion * speed
	move_and_slide()

func _input(event):
	if is_multiplayer_authority():
		if event.is_action_pressed("i_attack") && !attacking:
			if (facing == Vector2.RIGHT || facing == Vector2.DOWN):
				animation_player.play("attack_right")
			else: animation_player.play("attack_left")
			$"HurtBox/HurtBox Collision Shape".disabled = false
			attacking = true

func setBlendPos():
	animation_tree.set("parameters/Idle/blend_position", motion)
	animation_tree.set("parameters/Walk/blend_position", motion)
	animation_tree.set("parameters/Attack/blend_position", motion)

func select_animation():
	if(velocity == Vector2.ZERO):
			animation_state.travel("Idle")
	else: animation_state.travel("Walk")

func _on_hurt_box_body_entered(body):
	if (body.is_in_group("players") && body.name != self.name):
		Server.request_color_change(str(body.name).to_int(), str(name).to_int(), Color.RED)

func change_color(color):
	$Sprite2D.modulate = color

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack_right" || anim_name == "attack_left":
		attacking = false
		$"HurtBox/HurtBox Collision Shape".disabled = true
