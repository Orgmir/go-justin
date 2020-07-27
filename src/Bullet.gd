class_name Bullet
extends KinematicBody2D


export var speed = 400
export (int) var push = 100

var velocity = Vector2()
var rotation_offset := deg2rad(90)


func start(pos: Vector2, dir: float):
	rotation = dir + rotation_offset
	position = pos
	velocity = Vector2(speed, 0).rotated(dir)


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta, false)
	if collision and collision.collider.is_in_group("enemies"):
		collision.collider.apply_central_impulse(velocity.normalized() * push)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
