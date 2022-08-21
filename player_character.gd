extends KinematicBody2D

export var speed = 100
var screen_size = Vector2.ZERO
var attack = 0
var pc_dir = 0
var direction = Vector2.ZERO
var ret_vel
var goto_loc = Vector2.ZERO
var char_ang
var line2d
var next_location
var nav_path
var state


func _ready():
	screen_size = get_viewport_rect().size
	var tree = get_tree()
	line2d = tree.get_nodes_in_group("line2d1")[0]
	state = 0
	$NavigationAgent2D.path_max_distance = 1


func navigate():
	next_location = $NavigationAgent2D.get_next_location()
	direction = global_position.direction_to(next_location)
	var pos1 = next_location - global_position
	var curr_path = [Vector2.ZERO,pos1]
	line2d.points = curr_path



func _unhandled_input(event):
	if not event.is_action_pressed("click"):
		return
	goto_loc = Navigation2DServer.map_get_closest_point($NavigationAgent2D.get_navigation_map(), get_global_mouse_position())
	nav_path = Navigation2DServer.map_get_path($NavigationAgent2D.get_navigation_map(),global_position,goto_loc,false)
	nav_path.remove(0)
	print("nav path:",nav_path)
	$NavigationAgent2D.set_target_location(goto_loc)
	if $NavigationAgent2D.is_target_reachable():
		print("target reachable")
	else:
		print("target not reachabe")	
	state = 1


func move_char_ani():
	var sprite_dir
	char_ang = ceil(rad2deg(direction.angle()))
	sprite_dir = int(char_ang / 60.0)
	if abs(sprite_dir) >= 2:
		$AnimatedSprite.play("walk_left")
	elif abs(sprite_dir) == 0:
		$AnimatedSprite.play("walk_right")
	elif sprite_dir == 1:
		$AnimatedSprite.play("walk_down")
	elif sprite_dir == -1:
		$AnimatedSprite.play("walk_up")




func _physics_process(_delta):
#	direction = Vector2.ZERO
#	var distance = 0

	if state == 1:
		navigate()
		move_char_ani()
		ret_vel = move_and_slide(direction * speed)
#		$NavigationAgent2D.set_velocity(direction*speed)


		
#			ret_vel = move_and_slide(direction * speed)
#			for i in get_slide_count():
#				var collision = get_slide_collision(i)
#				print("I collided with ", collision.collider.name)
#				if(collision.collider.name == "walls" or collision.collider.name == "pillar" or collision.collider.name == "pillar2"):
#					state = 0
#					$AnimatedSprite.stop()


#	if state == 1:
#		direction = global_position.direction_to(nav_path[0])
#		distance = int(global_position.distance_to(nav_path[0]))
		
#		if distance <= 1:
#			print("new nav path:", nav_path[0])
		
#		print("distance:",distance)

	
#		direction = global_position.direction_to(goto_loc)
#		var pos1 = goto_loc - global_position
#		var curr_path = [Vector2.ZERO,pos1]
#		line2d.points = curr_path

#		move_char_ani()

		#$NavigationAgent2D.set_velocity(direction*speed)

#		if int(global_position.distance_to(nav_path[0])) <= 1:
#			nav_path.pop_front()

		
	#$NavigationAgent2D.set_velocity(direction*speed)


		
#		ret_vel = move_and_slide(direction * speed)
		
#		print("vel:",ret_vel," angle:",char_ang," magnitude:",global_position.distance_to(goto_loc))





func _on_AnimatedSprite_animation_finished():
	pass




func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	ret_vel = move_and_slide(safe_velocity)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.collider.name)
#		if(collision.collider.name == "enemy_character"):
#			state = 0
#			$AnimatedSprite.stop()



	
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.collider.name)
#		if(collision.collider.name == "walls"):
#			state = 0
#			$AnimatedSprite.stop()







func _on_NavigationAgent2D_target_reached():
	state = 0
	$AnimatedSprite.stop()


func _on_NavigationAgent2D_navigation_finished():
	state = 0
	$AnimatedSprite.stop()



func _on_Area2D_body_entered(body):
	print(body.name," entered in player character area")
	if body.name == "enemy_character":
		state = 0
		$AnimatedSprite.stop()



func _on_Area2D_body_exited(body):
	print(body.name," exited in player character area")

