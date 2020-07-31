extends Area2D

signal hit

export var speed = 400
export var bullet_offset = 25
export var can_shoot = true
export var min_scale = 1.0
export var max_scale = 2.0
export var scale_increment = 0.05

onready var screen_size = get_viewport_rect().size
var Bullet = preload("res://src/Bullet.tscn")
var started = false


func _ready():
	hide()


func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if started and can_shoot and Input.is_action_just_pressed("click"):
		shoot()


func start(pos):
	started = true
	position = pos
	show()
	$CollisionShape2D.disabled = false
	scale = Vector2(1.0, 1.0)
	$ScaleTimer.start()
	

func shoot():
	can_shoot = false
	$ShootCooldown.start()
	var bullet = Bullet.instance()
	var dir = get_global_mouse_position() - global_position
	var spawn_pos = global_position + bullet_offset * dir.normalized()
	var angle = dir.angle()
	bullet.start(spawn_pos, angle)
	get_parent().add_child(bullet)
	
	scale = scale - Vector2(0.1, 0.1)
        

func _on_Player_body_entered(_body):
	started = false
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func _on_ShootCooldown_timeout():
	can_shoot = true


func _on_ScaleTimer_timeout():
	var value = clamp(scale.x + scale_increment, min_scale, max_scale)
	scale = Vector2(value, value)
