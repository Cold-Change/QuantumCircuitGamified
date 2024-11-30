extends StaticBody3D

@onready var sprite_3d = $Sprite3D

var attatched_to_circuit = false
var gate_type = "Identity"

signal removeGate(gate_position)

func _ready():
	if sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/SmallGates-Sheet.png"):
		gate_type = "Small"
	elif sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/MediumGates-Sheet.png"):
		gate_type = "Medium"
	elif sprite_3d.texture == preload("res://WorldObjects/Gates/GateGraphics/LargeGates-Sheet.png"):
		gate_type = "Large"

func _process(_delta):
	pass

func _on_area_3d_area_entered(_area):
	if attatched_to_circuit == false:
		print("Add to circuit")
	else:
		removeGate.emit(name)
