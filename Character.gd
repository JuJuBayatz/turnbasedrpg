extends Node2D
class_name Character

@export var is_player: bool
@export var current_hp: int
@export var max_hp: int

@export var combat_actions : Array
@export var opponent : Node

@onready var health_bar : ProgressBar = get_node("HealthBar")
@onready var health_text : Label = get_node("HealthBar/HealthText")
@export var visual:Texture2D
@export var flip_visual:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = visual
	$Sprite.flip_h = flip_visual
	print(str("character_begin_turn trigger:"))
	if is_player:
		get_node("/root/BattleScene").character_begin_turn.connect(_on_character_begin_turn)
	health_bar.max_value = max_hp
	_update_health_bar()

func take_damage(damage):
	current_hp -= damage
	_update_health_bar()
	if current_hp <= 0:
		get_node("/root/BattleScene").character_died(self)
		#queue_free()

func heal(amount):
	current_hp += amount
	_update_health_bar()
	if current_hp >max_hp:
		current_hp = max_hp

func _update_health_bar():	
	health_bar.value = current_hp
	health_text.text = str(current_hp, " / ", max_hp)
	
func _on_character_begin_turn(character):
	print(str("combat_actions count :", len(combat_actions)))
	if is_player == false:
		print("_decide_combat_action")
		_decide_combat_action()
	
func cast_combat_action(action: CombatAction):
	print("cast_combat_action")
	if action.damage > 0:
		opponent.take_damage(action.damage)
	else:
		heal(action.heal)
		
	get_node("/root/BattleScene").end_current_turn()

func _decide_combat_action():
	var health_percent:float = float(current_hp)/max_hp
	
	for i in combat_actions:
		var action = i  as CombatAction 
		if action.heal > 0:
			if randf() > health_percent + 0.2:
				cast_combat_action(action)
				return	
			else:
				continue
		else:
			#pass
			cast_combat_action(action)	
		
	if health_percent<20:
		pass
	else:
		pass
	
