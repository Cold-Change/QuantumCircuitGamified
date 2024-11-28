extends StaticBody3D

@onready var sprite_3d = $Sprite3D

var attatched_to_circuit = true

func _process(_delta):
	pass

func _on_area_3d_area_entered(_area):
	if attatched_to_circuit == false:
		print("Add to circuit")
	else:
		queue_free()
