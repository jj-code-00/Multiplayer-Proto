extends CanvasLayer

var stats

@onready var vitality_button = get_node("MarginContainer/CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/Upgrade Buttons/Vitality_Button")
@onready var spirit_button = get_node("MarginContainer/CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/Upgrade Buttons/Spirit_Button")
@onready var strength_button = get_node("MarginContainer/CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/Upgrade Buttons/Strength_Button")
@onready var agility_button = get_node("MarginContainer/CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/Upgrade Buttons/Agility_Button")
@onready var durability_button = get_node("MarginContainer/CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/Upgrade Buttons/Durability_Button")
@onready var force_button = get_node("MarginContainer/CenterContainer/TabContainer/Attributes/MarginContainer/HBoxContainer/Upgrade Buttons/Force_Button")

func _ready():
	Server.get_stats(get_parent().name)
	await get_tree().create_timer(1).timeout
	if(stats != null):
		vitality_button.text = str(stats.get("Vitality"))
		spirit_button.text = str(stats.get("Spirit"))
		strength_button.text = str(stats.get("Strength"))
		agility_button.text = str(stats.get("Agility"))
		durability_button.text = str(stats.get("Durability"))
		force_button.text = str(stats.get("Force"))
	
