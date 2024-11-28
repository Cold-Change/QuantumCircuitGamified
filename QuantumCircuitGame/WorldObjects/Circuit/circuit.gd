extends StaticBody3D

@onready var gates = $Gates

const GATE_POSITION_ARRAY = [
Vector3(-5.12, .48, 0), Vector3(-4.16, .48, 0), Vector3(-3.20, .48, 0), Vector3(-2.24, .48, 0), Vector3(-1.28, .48, 0), Vector3(-0.32, .48, 0),  Vector3(.64, .48, 0), Vector3(1.60, .48, 0), Vector3(2.56, .48, 0), Vector3(3.52, .48, 0), Vector3(4.48, .48, 0), Vector3(5.44, .48, 0),
Vector3(-5.12, -.16, 0), Vector3(-4.16, -.16, 0), Vector3(-3.20, -.16, 0), Vector3(-2.24, -.16, 0), Vector3(-1.28, -.16, 0), Vector3(-0.32, -.16, 0),  Vector3(.64, -.16, 0), Vector3(1.60, -.16, 0), Vector3(2.56, -.16, 0), Vector3(3.52, -.16, 0), Vector3(4.48, -.16, 0), Vector3(5.44, -.16, 0),
Vector3(-5.12, -.8, 0), Vector3(-4.16, -.8, 0), Vector3(-3.20, -.8, 0), Vector3(-2.24, -.8, 0), Vector3(-1.28, -.8, 0), Vector3(-0.32, -.8, 0),  Vector3(.64, -.8, 0), Vector3(1.60, -.8, 0), Vector3(2.56, -.8, 0), Vector3(3.52, -.8, 0), Vector3(4.48, -.8, 0), Vector3(5.44, -.8, 0)
]

func _ready():
	resetCircuit()

func _process(delta):
	pass

func resetCircuit():
	for gate in gates.get_children():
		gate.free()
	for pos in GATE_POSITION_ARRAY:
		var new_blank = load("res://WorldObjects/Circuit/blank.tscn").instantiate()
		new_blank.position = pos
		gates.add_child(new_blank)
	
