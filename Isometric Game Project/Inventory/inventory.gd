extends Node2D

# ========================================================================================================
# makeing a constant that preloads the slod.gd script.
# 		- When resources are loaded before scene is playing/running, 
#		  this way of loading resources is called preloading.
#		  When resources are loaded while scene is already playing/running, 
#		  resources being loaded dynamically (this is what you call regular loading)
#		- Advantage of preloading resources is that you avoid freezes during gameplay 
#		  because of resource being loaded (parsed/converted to right format/etc),
#		  but the  scene loads for a longer time.
#		- When you use dynamic loading of resources, you save some memory and load stuff 
#		  you need only when you actually need it
# ========================================================================================================
const SLOT_CLASS = preload("res://Inventory/slot.gd")
# ========================================================================================================
# an onreavy variable that grabs the gridContainer node.
# 		- An onready var is assigned a value after the node and its siblings entered the tree. 
# 		  It's a shortcut for assigning variables in _ready().
# ========================================================================================================
onready var inventory_slots = $GridContainer
var holding_item = null

# ========================================================================================================
# Called when the node is "ready", i.e. when both the node and its children have entered the scene tree. 
# If the node has children, their _ready() callbacks get triggered first, 
# and the parent node will receive the ready notification afterwards.
# ========================================================================================================
func _ready():
	# ====================================================================================================
	# Looping over all of the chikd nodes in the grid container, the get_children() returns an array, 
	# containing all of the slot nodes.
	# ====================================================================================================
	for inv_slots in inventory_slots.get_children():
		# ========================================================================================================
		# self - Refers to current class instance
		# It serves essentially the same purpose as self or this in other object-oriented languages
		#
		# Specifically in GDScript, when used in a script, 
		# it's a reference to the object the script is attached to.
		#
		# It's used whenever you need a reference to the current node, for 
		# example when connecting a signal to a local function.
		# ========================================================================================================
		inv_slots.connect("gui_input", self, "slot_gui_input", [inv_slots])
		
# ========================================================================================================
# This fucntion is where most/all the functinality happans including:
#		- picking up and swaping items that are diffrent
#		- stacking items togeather
# ========================================================================================================
func slot_gui_input(event: InputEvent, slot: SLOT_CLASS):
	if event is InputEventMouseButton: # checking if the event is a mouse button is being pressed
		if event.button_index == BUTTON_LEFT and event.pressed: # checking of the pressed mouse button is a left click
			if holding_item != null: # checking if the theres an item being held
				if !slot.item: # place item into a slot, checking to see of the place where you want to place the slot is empty 
					slot.put_into_slot(holding_item)
					holding_item = null
				else: # swaping holding item with item in slot, checking to see if an item is in a slot 
					if holding_item.item_name != slot.item.item_name:
						var tmp_item = slot.item
						slot.pick_from_slot()
						tmp_item.global_position = event.global_position
						slot.put_into_slot(holding_item)
						holding_item = tmp_item
					else: # checking if it's the same item and if it can stack
						var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
						var able_to_stack = stack_size - slot.item.item_quantity
						if able_to_stack >= holding_item.item_quantity:
							slot.item.add_item_quantity(holding_item.item_quantity)
							holding_item.que_free()
							holding_item = null
						else:
							slot.item.add_item_quantity(able_to_stack)
							holding_item.decrease_item_quantity(able_to_stack)
			elif slot.item: # checking there is an item being held
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position()
				
func _input(event):# Called when there is an input event. The input event propagates up through the node tree until a node consumes it
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
