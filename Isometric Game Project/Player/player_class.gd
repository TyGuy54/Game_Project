extends KinematicBody2D
class_name player

# player stats
export var health = 20
export var base_damage = 5
export var base_magic_damage = 3
export var attack_speed = 3
export var magic_cast_speed = 3
export var base_defense = 2
export var carry_cap = 100.0
export var equiped = false

# player level
var level = 0



	
# keeps track of the players current level
func player_levels():
	pass
	
# checks if a weapon is equipded or not 
func is_equiped():
	pass
# checks what weapon is  equied
func equiped_weapon():
	pass

# when the player hits spae bar they will make a sword 
# it doe nothing at the moment but thats what ill be workin on
# im goning to try to use this in the animation player
func player_summon_weapon(weapon_type):
	var sword = preload("res://weapons/sword_test.tscn")
	var weapon = sword.instance()
	weapon.position = position
	get_parent().add_child(weapon)
