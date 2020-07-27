extends Area2D

signal hit

export var speed = 400
export var bullet_offset = 25
onready var screen_size = get_viewport_rect().size

var Bullet = preload("res://src/Bullet.tscn")
var started = false
var canShoot = true

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
	
	if started and canShoot and Input.is_action_just_pressed("click"):
		shoot()
	

func shoot():
	canShoot = false
	$ShootCooldown.start()
	var bullet = Bullet.instance()
	var dir = get_global_mouse_position() - global_position
	var spawn_pos = global_position + bullet_offset * dir.normalized()
	var angle = dir.angle()
	bullet.start(spawn_pos, angle)
	get_parent().add_child(bullet)
        

func _on_Player_body_entered(_body):
	started = false
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	started = true
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_ShootCooldown_timeout():
	canShoot = true
