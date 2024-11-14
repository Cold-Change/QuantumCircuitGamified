extends Node

# Entity number -1 = Non Assigned, 1 = Player
func _ready():
	var player_num = 1
	for player in get_tree().get_nodes_in_group("Player"):
		if player.entity_num < 0:
			player.entity_num = player_num
		if player.has_node("PlayerModel/Armature/Skeleton3D/HandRAttatchment/Gun"):
			player.get_node("PlayerModel/Armature/Skeleton3D/HandRAttatchment/Gun").emitEntityDamage.connect(manageDamage)
			player.get_node("PlayerModel/Armature/Skeleton3D/HandRAttatchment/Gun").entity_num = player.entity_num
			player_num += 1

func manageDamage(entity_num,damage):
	for entity in get_tree().get_nodes_in_group("Player"):
		if entity_num == entity.entity_num:
			entity.takeDamage(damage)
