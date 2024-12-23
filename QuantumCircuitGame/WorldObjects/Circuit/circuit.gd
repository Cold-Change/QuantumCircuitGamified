extends StaticBody3D

@onready var gates = $Gates
@onready var gate_refractory_timer = $GateRefractoryTimer
@onready var final_vector_label = $Sprite3D/FinalVector

var can_remove_gate = true

const GATE_POSITION_ARRAY = {
"Q0C0": Vector3(-5.12, .48, 0), "Q0C1": Vector3(-4.16, .48, 0), "Q0C2": Vector3(-3.20, .48, 0), "Q0C3": Vector3(-2.24, .48, 0), "Q0C4": Vector3(-1.28, .48, 0), "Q0C5": Vector3(-0.32, .48, 0),  "Q0C6": Vector3(.64, .48, 0), "Q0C7": Vector3(1.60, .48, 0), "Q0C8": Vector3(2.56, .48, 0), "Q0C9": Vector3(3.52, .48, 0), "Q0C10": Vector3(4.48, .48, 0), "Q0C11": Vector3(5.44, .48, 0),
"Q1C0": Vector3(-5.12, -.16, 0), "Q1C1": Vector3(-4.16, -.16, 0), "Q1C2": Vector3(-3.20, -.16, 0), "Q1C3": Vector3(-2.24, -.16, 0), "Q1C4": Vector3(-1.28, -.16, 0), "Q1C5": Vector3(-0.32, -.16, 0),  "Q1C6": Vector3(.64, -.16, 0), "Q1C7": Vector3(1.60, -.16, 0), "Q1C8": Vector3(2.56, -.16, 0), "Q1C9": Vector3(3.52, -.16, 0), "Q1C10": Vector3(4.48, -.16, 0), "Q1C11": Vector3(5.44, -.16, 0),
"Q2C0": Vector3(-5.12, -.8, 0), "Q2C1": Vector3(-4.16, -.8, 0), "Q2C2": Vector3(-3.20, -.8, 0), "Q2C3": Vector3(-2.24, -.8, 0), "Q2C4": Vector3(-1.28, -.8, 0), "Q2C5": Vector3(-0.32, -.8, 0),  "Q2C6": Vector3(.64, -.8, 0), "Q2C7": Vector3(1.60, -.8, 0), "Q2C8": Vector3(2.56, -.8, 0), "Q2C9": Vector3(3.52, -.8, 0), "Q2C10": Vector3(4.48, -.8, 0), "Q2C11": Vector3(5.44, -.8, 0)
}

const ZERO_VECTOR = [
[1],
[0],
[0],
[0],
[0],
[0],
[0],
[0],
]

const IDENTITY_MATRIX_ARRAY = {
0: [
[1,0],
[0,1]
],
1: [
[1,0,0,0],
[0,1,0,0],
[0,0,1,0],
[0,0,0,1]
],
2: [
[1,0,0,0,0,0,0,0],
[0,1,0,0,0,0,0,0],
[0,0,1,0,0,0,0,0],
[0,0,0,1,0,0,0,0],
[0,0,0,0,1,0,0,0],
[0,0,0,0,0,1,0,0],
[0,0,0,0,0,0,1,0],
[0,0,0,0,0,0,0,1]
]
}

const SMALL_GATE_MATRIX_ARRAY = {
-1: [[1,0],[0,1]], #Identity
0: [[1,1],[1,-1]], #Hadamard
1: [[0,1],[1,0]], #X
2: [[0,-1],[1,0]], #Y
3: [[1,0],[0,-1]] #Z
}

func _ready():
	resetCircuit()
	updateVector()

func _process(delta):
	pass

func resetCircuit():
	for gate in gates.get_children():
		gate.free()
	for item in GATE_POSITION_ARRAY:
		var new_blank = load("res://WorldObjects/Circuit/blank.tscn").instantiate()
		new_blank.position = GATE_POSITION_ARRAY[item]
		new_blank.name = item
		new_blank.attatched_to_circuit = true
		new_blank.removeGate.connect(removeGate)
		gates.add_child(new_blank)

func removeGate(gate_position):
	var gate_to_remove = gates.get_node(NodePath(gate_position))
	if can_remove_gate:
		if gate_to_remove.gate_type == "Identity":
			gate_to_remove.name = "GATE_TO_REMOVE"
			gate_to_remove.queue_free()
			addGate(gate_position, Globals.gate_type_selected, Globals.gate_index_selected)
			can_remove_gate = false
		else:
			gate_to_remove.name = "GATE_TO_REMOVE"
			gate_to_remove.queue_free()
			addGate(gate_position)
			can_remove_gate = false
		gate_refractory_timer.start()
		updateVector()

func addGate(gate_position, gate_type = "Identity", gate_index = 0):
	var new_gate
	if gate_type == "Identity":
		new_gate = load("res://WorldObjects/Circuit/blank.tscn").instantiate()
	elif gate_type == "Small":
		new_gate = preload("res://WorldObjects/Gates/small_gate.tscn").instantiate()
	elif gate_type == "Medium":
		new_gate = preload("res://WorldObjects/Gates/medium_gate.tscn").instantiate()
	else:
		new_gate = preload("res://WorldObjects/Gates/large_gate.tscn").instantiate()
	
	new_gate.position = GATE_POSITION_ARRAY[gate_position]
	new_gate.name = gate_position
	new_gate.attatched_to_circuit = true
	new_gate.removeGate.connect(removeGate)
	gates.add_child(new_gate)
	new_gate.sprite_3d.frame = gate_index

func updateVector():
	var final_vector = ZERO_VECTOR
	var cumulative_matrix = IDENTITY_MATRIX_ARRAY[2]
	for col in range(12):
		var matrices_to_multiply = []
		for row in range(2,-1,-1):
			var gate_to_add = gates.get_node("Q" + str(row) + "C" + str(col))
			if gate_to_add.gate_type == "Identity":
				matrices_to_multiply.append(-1)
			elif gate_to_add.gate_type == "Small":
				matrices_to_multiply.append(gate_to_add.sprite_3d.frame)
		var current_matrix = tensorProduct3(matrices_to_multiply)
		cumulative_matrix = matrixMultiplication(cumulative_matrix, current_matrix)
	final_vector = matrixMultiplication(cumulative_matrix, final_vector)
	final_vector_label.text = str(final_vector[0][0]) + "\n" + str(final_vector[1][0]) + "\n" + str(final_vector[2][0]) + "\n" + str(final_vector[3][0]) + "\n" + str(final_vector[4][0]) + "\n" + str(final_vector[5][0]) + "\n" + str(final_vector[6][0]) + "\n" + str(final_vector[7][0])

func zeroMatrix(nX, nY):
	var matrix = []
	for x in range(nX):
		matrix.append([])
		for y in range(nY):
			matrix[x].append(0)
	return matrix

func matrixMultiplication(matrix1, matrix2):
	var matrix = zeroMatrix(matrix1.size(), matrix2[0].size())
	
	for i in range(matrix1.size()):
		for j in range(matrix2[0].size()):
			for k in range(matrix1[0].size()):
				matrix[i][j] = matrix[i][j] + matrix1[i][k] * matrix2[k][j]
	return matrix

func tensorProduct3(matrices):
	var matrix3 = zeroMatrix(8, 8)
	var matrix2 = zeroMatrix(4, 4)
	var matrices_to_tensor = []
	
	for m in matrices:
		matrices_to_tensor.append(SMALL_GATE_MATRIX_ARRAY[m])
	
	for i in range(4):
		for j in range(4):
			matrix2[i][j] = matrices_to_tensor[0][i/2][j/2] * matrices_to_tensor[1][i%2][j%2]
	
	for i in range(8):
		for j in range(8):
			matrix3[i][j] = matrix2[i/2][j/2] * matrices_to_tensor[2][i%2][j%2]
	
	return matrix3

func _on_gate_refractory_timer_timeout():
	can_remove_gate = true
