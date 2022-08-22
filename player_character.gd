extends KinematicBody2D

export var speed = 100
var screen_size = Vector2.ZERO
var attack = 0
var pc_dir = 0
var direction = Vector2.ZERO
var ret_vel
var state = 0
var label2
#var enemy_character


func _ready():
	screen_size = get_viewport_rect().size
	var tree = get_tree()
	label2 = tree.get_nodes_in_group("label2")[0]
#	enemy_character = tree.get_nodes_in_group("enemy_character")[0]
	state = 0


func check_ani_direction():
	if $AnimatedSprite.animation == "walk_left":
		pc_dir = 1
	elif $AnimatedSprite.animation == "walk_right":
		pc_dir = 2
	elif $AnimatedSprite.animation == "walk_up":
		pc_dir = 3
	elif $AnimatedSprite.animation == "walk_down":
		pc_dir = 4

func _physics_process(_delta):
	direction = Vector2.ZERO
#	var distance = 0
	label2.text = "frame animation:\""+$AnimatedSprite.animation+"\" frame_count:"+str($AnimatedSprite.frame)+" state:"+str(state)
	if Input.is_action_just_pressed("ui_attack"):
		state = 1
	
	if state == 0:
		check_ani_direction()
		if Input.is_action_pressed("ui_left"):
			$AnimatedSprite.play("walk_left")
#			$CollisionShape2D.shape.extents = Vector2(16, 8)
			direction.x = direction.x - 1
			if Input.is_action_pressed("ui_up"):
				direction.y = direction.y - 1
			elif Input.is_action_pressed("ui_down"):
				direction.y = direction.y + 1

		elif Input.is_action_pressed("ui_right"):
#			$CollisionShape2D.shape.extents = Vector2(16, 8)
			$AnimatedSprite.play("walk_right")
			direction.x = direction.x + 1
			if Input.is_action_pressed("ui_up"):
				direction.y = direction.y - 1
			elif Input.is_action_pressed("ui_down"):
				direction.y = direction.y + 1

	
		elif Input.is_action_pressed("ui_up"):
#			$CollisionShape2D.shape.extents = Vector2(18, 8)
			$AnimatedSprite.play("walk_up")
			direction.y = direction.y - 1

	
		elif Input.is_action_pressed("ui_down"):
#			$CollisionShape2D.shape.extents = Vector2(18, 8)
			$AnimatedSprite.play("walk_down")
			direction.y = direction.y + 1

		else:
			$AnimatedSprite.stop()


	if state == 1:
		if pc_dir == 1:
			$AnimatedSprite.play("attack_left")
		elif pc_dir == 2:
			$AnimatedSprite.play("attack_right")
		elif pc_dir == 3:
			$AnimatedSprite.play("attack_up")
		elif pc_dir == 4:
			$AnimatedSprite.play("attack_down")
			

	if direction.length() > 1:
		direction = direction.normalized()

	ret_vel = move_and_slide(direction * speed)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.collider.name)





func _on_AnimatedSprite_animation_finished():
	if state == 1:
		$AnimatedSprite.stop()
		state = 0
