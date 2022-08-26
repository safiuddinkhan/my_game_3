extends KinematicBody2D

export var speed = 100
var screen_size = Vector2.ZERO
var attack = 0
var pc_dir = 0
var direction = Vector2.ZERO
var ret_vel
var state = 0
var label2
export var strength = 5
var change_scene
var enemy_collision = {}
#var enemy_character


func _ready():
	screen_size = get_viewport_rect().size
	var tree = get_tree()
	label2 = tree.get_nodes_in_group("label2")[0]
#	enemy_character = tree.get_nodes_in_group("enemy_character")[0]
	state = 0
#	Navigation2DServer.agent_set_map($NavigationObstacle2D.get_rid(),get_world_2d().navigation_map)

func check_ani_direction():
#	$hitbox_player/CollisionShape2D.shape.extents = Vector2(0,0)
#	$hitbox_player/CollisionShape2D.position = Vector2(0,0)
	$hitbox_player/CollisionShape2D.disabled = true
	if $AnimatedSprite.animation == "walk_left":
		pc_dir = 1
#		$hitbox_player.rotation_degrees = 180
	elif $AnimatedSprite.animation == "walk_right":
		pc_dir = 2
#		$hitbox_player.rotation_degrees = 0
	elif $AnimatedSprite.animation == "walk_up":
		pc_dir = 3
#		$hitbox_player.rotation_degrees = 270
	elif $AnimatedSprite.animation == "walk_down":
		pc_dir = 4
#		$hitbox_player.rotation_degrees = 90

func _physics_process(_delta):
	direction = Vector2.ZERO
#	var distance = 0
	label2.text = "frame animation:\""+$AnimatedSprite.animation+"\" frame_count:"+str($AnimatedSprite.frame)+" state:"+str(state)
	label2.text = "player 1 strength:"+str(strength)
	if Input.is_action_just_pressed("ui_attack"):
		state = 1
	
	if strength <= 0:
		state = 2
	
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


	elif state == 1:
		$hitbox_player/CollisionShape2D.disabled = false
		if pc_dir == 1:
			$AnimatedSprite.play("attack_left")
			$hitbox_player/CollisionShape2D.position = Vector2(-46,-26)
#			$hitbox_player/CollisionShape2D.shape.extents = Vector2(33,14)
		elif pc_dir == 2:
			$AnimatedSprite.play("attack_right")
#			$hitbox_player/CollisionShape2D.shape.extents = Vector2(33,14)
			$hitbox_player/CollisionShape2D.position = Vector2(46,-26)
		elif pc_dir == 3:
#			$hitbox_player/CollisionShape2D.shape.extents = Vector2(40,21)
			$hitbox_player/CollisionShape2D.position = Vector2(0,-56)
			$AnimatedSprite.play("attack_up")
		elif pc_dir == 4:
#			$hitbox_player/CollisionShape2D.shape.extents = Vector2(40,21)
			$hitbox_player/CollisionShape2D.position = Vector2(0,16)
			$AnimatedSprite.play("attack_down")
	
	elif state == 2:
		$AnimatedSprite.play("dead")

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
	elif state == 2:
		change_scene = get_tree().change_scene("res://game_over.tscn")






func _on_hitbox_area_entered(area):
	print("Area Entered:",area.name)


func _on_hitbox_body_entered(_body):
	pass
#	print("Body Entered:",body.name)
#	if body.is_in_group("enemy_character"):
#		body.strength = body.strength - 1
#		body.hit_highlight()
#		print("name:",body.name," strength:",body.strength)




func _on_hitbox_player_area_entered(area):
	var enemy_name
	print("area:",area.name)
	if area.name == "hurtbox_enemy":
		var body = area.get_parent()
		if body.name in enemy_collision:
			if enemy_collision[body.name] == 1:
				enemy_name = 1
			else:
				enemy_name = 0
		else:
			enemy_name = 0
		if body.strength > 0 and enemy_name == 1:
			body.strength = body.strength - 1
			body.hit_highlight()
			print("name:",body.name," strength:",body.strength)
	elif area.name == "hitbox_enemy":
		print("player:miss")


func hit_highlight():
	$AnimatedSprite.modulate = Color( 1, 0, 0, 1 )
	$Timer.start(0.1)
	


func _on_Timer_timeout():
	$AnimatedSprite.modulate = Color( 1, 1, 1, 1 )


func _on_range_body_entered(body):
	if body.is_in_group("enemy_character"):
		enemy_collision[body.name] = 1


func _on_range_body_exited(body):
	if body.is_in_group("enemy_character"):
		enemy_collision[body.name] = 0
