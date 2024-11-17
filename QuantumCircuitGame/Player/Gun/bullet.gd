extends Node3D

var speed = 120
var damage = 20
var collisionMade = false

@onready var clear_timer = $ClearTimer

signal entityTakeDamage(entity,damage)

func _process(delta):
	position += transform.basis * Vector3(0, 0, speed) * delta

func destroyBullet():
	queue_free()

func _on_clear_timer_timeout():
	destroyBullet()

func _on_hit_box_body_entered(body):
	if body.has_method("takeDamage") and !collisionMade:
		body.takeDamage(damage)
	collisionMade = true
	destroyBullet()
