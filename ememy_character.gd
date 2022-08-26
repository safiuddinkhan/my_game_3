extends KinematicBody2D

export var speed = 40
#export var start_pos:Vector2 = Vector2.ZERO
#export var end_pos:Vector2 = Vector2.ZERO
var leader_state = 0
var screen_size = Vector2.ZERO
var direction = Vector2.ZERO
var player_character
var ret_vel
var state = 0
export var walk:bool = false
var walk_state = 0
var line2d
var char_ang
var nav_path
var label
var label3
var req_state
var new_state
var player_pos
var enemy_dir
export var strength = 5
var path_to_go:PoolVector2Array
var path_count



#var frame_count = 0



func _ready():
	screen_size = get_viewport_rect().size
	var tree = get_tree()
	player_character = tree.get_nodes_in_group("player_character")[0]
	line2d = $Line2D
#	label = tree.get_nodes_in_group("label1")[0]
#	label3 = tree.get_nodes_in_group("label3")[0]
	state = 0
	req_state = 0
	new_state = 0
	leader_state = 0
	enemy_dir = 0
	#path_count = 1
	

	
	
	if walk == true:
		state = -1

#		player_pos = path_to_go[path_count]
#		walk_state = 0

#	$NavigationAgent2D.path_max_distance = 1

func set_follow_path(polygon:PoolVector2Array):
	path_to_go = polygon
	path_count = 1
	player_pos = path_to_go[path_count]
	state = 0
	for i in polygon:
		print(self.name,": ",i)
	
	
	

func walk_mode(toggle):
	if toggle:
		walk = 1
	else:
		walk = 0



func navigate():
	var next_location
	
	if walk == false:
		player_pos = player_character.global_position
		
	$NavigationAgent2D.set_target_location(Navigation2DServer.map_get_closest_point($NavigationAgent2D.get_navigation_map(),player_pos))
#	nav_path = Navigation2DServer.map_get_path($NavigationAgent2D.get_navigation_map(),global_position,player_pos,true)
#	print($NavigationAgent2D.get_nav_path())
	next_location = $NavigationAgent2D.get_next_location()
	direction = global_position.direction_to(next_location)
	
	####
#	var pos1 = nav_path - global_position
	####

func get_direction(ang):
	var ver_dir = -1
	if ang < 0:
		ver_dir = 3
	else:
		ver_dir = 4
	
	
	var step = 60

	
	if abs(ang) >= 0 and abs(ang) <= 90-step:
		return 2
	elif abs(ang) >= 90+step and abs(ang) <= 180:
		return 1
	elif abs(ang) >= (90-step) and abs(ang) <= (90+step):
		return ver_dir



func hit_highlight():
	$AnimatedSprite.modulate = Color( 1, 0, 0, 1 )
	$Timer.start(0.1)

func _physics_process(_delta):

#	if frame_count == 0:
#		update_pc_location()

#	var sprite_dir
	if strength <= 0:
		state = 2



	if state == 0:
#		$hitbox_enemy/CollisionShape2D.shape.extents = Vector2(0,0)
#		$hitbox_enemy/CollisionShape2D.position = Vector2(0,0)
		$hitbox_enemy/CollisionShape2D.disabled = true
		navigate()

		char_ang = floor(rad2deg(direction.angle()))
#		$Area2D.rotation_degrees = char_ang
#		sprite_dir = int(char_ang / 60.0)
#		print("sprite_dir:", char_ang / 60.0," rounded:", sprite_dir, " raw ang:",rad2deg(direction.angle()))
#		label.text = "frame animation:\""+$AnimatedSprite.animation+"\" frame_count:"+str($AnimatedSprite.frame)+" state_req_reg: "+str(req_state)+" curr state:"+str(state)

#		if abs(sprite_dir) >= 2:
		var dir1 = get_direction(char_ang)
#		label3.text = "char_ang:"+str(char_ang)+"dir:"+str(dir1)
		if dir1 == 1:
			$AnimatedSprite.play("walk_left")
#			$Area2D.position = Vector2(-16,0)
			enemy_dir = 1
		elif dir1 == 2:
#		elif abs(sprite_dir) == 0:
			$AnimatedSprite.play("walk_right")
#			$Area2D.position = Vector2(16,0)
			enemy_dir = 2
		elif dir1 == 3:
#		elif sprite_dir == -1:
			$AnimatedSprite.play("walk_up")
#			$Area2D.position = Vector2(0,-8)
			enemy_dir = 3
		elif dir1 == 4:
#		elif sprite_dir == 1:
			$AnimatedSprite.play("walk_down")
#			$Area2D.position = Vector2(0,8)
			enemy_dir = 4
#		ret_vel = self.move_and_slide(direction * speed)


#		print("name:",self.name," collision count:",get_slide_count())


#			if(collision.collider.name == "player_character"):
#				state = 0
		$NavigationAgent2D.set_velocity(direction * speed)
	elif state == 1:
#		$hitbox/CollisionShape2D.shape.length = 22
#		$hitbox_enemy/CollisionShape2D.disabled = false
#		$Timer2.start(0.01)
		#char_ang = floor(rad2deg(direction.angle()))
#		$Area2D.rotation_degrees = char_ang

		if $AnimatedSprite.frame == 3:
			$hitbox_enemy/CollisionShape2D.disabled = false
		elif $AnimatedSprite.frame == 5:
			$hitbox_enemy/CollisionShape2D.disabled = true

#		label.text = "frame animation:\""+$AnimatedSprite.animation+"\" frame_count:"+str($AnimatedSprite.frame)+" state_req_reg: "+str(req_state)+" curr state:"+str(state)
		if enemy_dir == 1:
			$hitbox_enemy/CollisionShape2D.position = Vector2(-46,-26)
#			$hitbox_enemy/CollisionShape2D.shape.extents = Vector2(33,14)
			$AnimatedSprite.play("attack_left")
		elif enemy_dir == 2:
#			$hitbox_enemy/CollisionShape2D.shape.extents = Vector2(33,14)
			$hitbox_enemy/CollisionShape2D.position = Vector2(46,-26)
			$AnimatedSprite.play("attack_right")
		elif enemy_dir == 3:
#			$hitbox_enemy/CollisionShape2D.shape.extents = Vector2(40,21)
			$hitbox_enemy/CollisionShape2D.position = Vector2(0,-56)
			$AnimatedSprite.play("attack_up")
		elif enemy_dir == 4:
#			$hitbox_enemy/CollisionShape2D.shape.extents = Vector2(40,21)
			$hitbox_enemy/CollisionShape2D.position = Vector2(0,16)
			$AnimatedSprite.play("attack_down")
		
#		if player_character.state == 1:
#			if v == 0 and check_hit_detection() == 1:
#				v = 1
#				strength = strength - 1
#				$AnimatedSprite.modulate = Color( 1, 0, 0, 1 )
#				$Timer.start(0.5)
#				print("enemy:",self.name," strength:",strength)
#				if strength == 0:
#					state = 2
#		elif player_character.state == 0:
#			v = 0
	elif state == 2:
		$AnimatedSprite.play("dead")
		req_state = 0
	elif state == -1:
		$AnimatedSprite.stop()


#		frame_count = frame_count + 1




#	if state == 0:
#		ret_vel = self.move_and_slide(direction*speed)















func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	ret_vel = self.move_and_slide(safe_velocity)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.collider.name)
#		if(collision.collider.name == "player_character"):
#			state = 0











func _on_Area2D_mouse_entered():
	if state == 1:
		print("Hello Mouse Entered")



func _on_AnimatedSprite_animation_finished():
#	if state == 1:
#		$hitbox_enemy/CollisionShape2D.shape.extents = Vector2(0,0)
#		$hitbox_enemy/CollisionShape2D.position = Vector2(0,0)
#		$hitbox_enemy/CollisionShape2D.disabled = true
#		print("name:",self.name," hitbox disabled")
	if state == 2:
		queue_free()



	if req_state == 1:
		print("State change requested. Changing to State ",new_state)
		req_state = 0
		state = new_state
	

#	pass








func _on_NavigationAgent2D_target_reached():
	if walk == true:
		if path_count == path_to_go.size()-1:
			path_count = 0
		else:
			path_count = path_count + 1
		player_pos = path_to_go[path_count]

#		if walk_state == 0:
#			walk_state = 1
#			player_pos = start_pos
#		elif walk_state == 1:
#			walk_state = 0
#			player_pos = end_pos


func _on_NavigationAgent2D_path_changed():
	nav_path = $NavigationAgent2D.get_nav_path()
	for i in nav_path.size():
		nav_path[i] = nav_path[i] - global_position
	line2d.points = nav_path







func _on_Timer_timeout():
	$AnimatedSprite.modulate = Color( 1, 1, 1, 1 )





func _on_hitbox_enemy_area_entered(area):
#	print("area:",area.name)
	if area.name == "hurtbox_player":
		var body = area.get_parent()
		if body.strength > 0:
			body.strength = body.strength - 1
			body.hit_highlight()
			print("name:",body.name," strength:",body.strength)
	elif area.name == "hitbox_player":
		print("enemy:miss")

func request_state(st):
	req_state = 1
	new_state = st


func _on_Timer2_timeout():
	print("timeout")
	if $hitbox_enemy/CollisionShape2D.disabled == true:
		$hitbox_enemy/CollisionShape2D.disabled = false
	else:
		$hitbox_enemy/CollisionShape2D.disabled = true


func _on_range_body_entered(body):
	if(body.name == "player_character"):
		request_state(1)



func _on_range_body_exited(body):
	if(body.name == "player_character"):
		request_state(0)
	#body.enemy_collision[self.name] = 0


func _on_NavigationAgent2D_navigation_finished():
	pass # Replace with function body.
