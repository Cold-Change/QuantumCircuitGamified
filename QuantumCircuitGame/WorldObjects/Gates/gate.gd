extends StaticBody3D

@onready var sprite_3d = $Sprite3D

var attatched_to_circuit = false
var gate_type = "Identity"

signal removeGate(gate_position)

func _ready():
	if sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/SmallGates-Sheet.png"):
		gate_type = "Small"
	elif sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/MediumGates-Sheet.png") or sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/MediumGatesShow-Sheet.png"):
		gate_type = "Medium"
	elif sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/LargeGates-Sheet.png") or sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/LargeGatesShow-Sheet.png"):
		gate_type = "Large"

func _process(_delta):
	pass

func _on_area_3d_area_entered(_area):
	if attatched_to_circuit == false:
		Globals.gate_type_selected = gate_type
		Globals.gate_index_selected = sprite_3d.frame
	else:
		removeGate.emit(name)
