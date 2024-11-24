extends StateMachine
@export var id = 1

func _ready():
	add_state('STAND')
	add_state('JUMP_SQUAT')
	add_state('SHORT_HOP')
	add_state('FULL_HOP')
	add_state('DASH')
	add_state('MOONWALK')
	add_state('WALK')
	add_state('CROUCH')
	add_state('AIR')


	call_deferred("set_state", states.STAND)

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)

func get_transition(delta):
	parent.move_and_slide_with_snap(parent.velocity*2,Vector2.ZERO,Vector2.UP)
	parent.states.text = str(state)
	
	if Landing() == true:
		parent._frame()
		return states.LANDING
	if Falling() == true:
		return states.AIR
	
	match state:
		states.STAND:
			if Input.get_action_strength("right_%s" % id) == 1:
				parent.velocity.x = parent.RUNSPEED
				parent._frame()
				parent.turn(false)
				return states.DASH
			if Input.get_action_strength("left_%s" % id) == 1:
				parent.velocity.x = -parent.RUNSPEED
				parent._frame()
				parent.turn(true)
				return states.DASH
			if parent.velocity.x > 0 and state == states.STAND:
				parent.velocity.x += -parent.TRACTION*1
				parent.velocity.x = clampf(parent.velocity.x,0,parent.velocity.x)
			elif parent.velocity.x < 0 and state == states.STAND:
				parent.velocity.x += parent.TRACTION*1
				parent.velocity.x = clampf(parent.velocity.x,parent.velocity.x,0)
		states.JUMP_SQUAT:
			if parent.frame == parent.jump_squat:
				if not Input.is_action_pressed("jump"):
					parent.velocity.x = lerpf(parent.celocity.x,0,0.08)
					parent._frame()
					return states.SHORT_HOP
				else:
					parent.velocity.x = lerpf(parent.celocity.x,0,0.08)
					parent._frame()
					return states.FULL_HOP
		states.SHORT_HOP:
			parent.velocity.y = -parent.JUMPFORCE
			parent._frame()
			return states.AIR
			
		states.FULL_HOP:
			parent.velocity.y = -parent.MAX_JUMPFORCE
			parent._frame()
			return states.AIR
			
		states.DASH:
			if Input.is_action_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent._frame()
				parent.velocity.x = -parent.DASHSPEED
			elif Input.is_action_pressed("right_%s" % id):
				if parent.velocity.x < 0:
					parent._frame()
				parent.velocity.x =parent.DASHSPEED
			else:
				if parent.frame >= parent.dash_duration-1:
					return states.STAND
							
		states.MOONWALK:
			pass
		states.WALK:
			pass
		states.CROUCH:
			pass
		states.AIR:
			AIRMOVEMENT()
		states.LANDING:
			if parent.frame <= parent.landing_frames + parent.lag_frames:
				if parent.frame >= 1:
					pass
				if parent.velocity.x > 0:
					parent.velocity.x -= parent.TRACTION/2
					parent.velocity.x = clampf(parent.velocity.x,0,parent.velocity.x)
				elif parent.velocity.x < 0:
					parent.velocity.x += parent.TRACTION/2
					parent.velocity.x = clampf(parent.velocity.x,parent.velocity.x,0)
				if Input.is_action_just_pressed("jump"):
					parent._frame()
					return states.JUMP_SQUAT
			else:
				if Input.is_action_pressed("down"):
					parent.lag_frames = 0
					parent._frame()
					return states.CROUCH
				else:
					parent._frame()
					parent.lag_frames = 0
					return states.STAND
				parent.lag_frames = 0
					
func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

func state_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false
	
func AIRMOVEMENT():
	if parent.velocity.y < parent.FALLINGSPEED:
		parent.velocity += parent.FALLSPEED
	if Input.is_action_pressed("down") and parent.down_buffer == 1 and parent.velocity.y > -150 and not parent.fastfall:
		parent.velocity.y = parent.MAXALLSPEED
		parent.fastfall = true
	if parent.fastfall == true:
		parent.set_collision_mask_bit(2,false)
		parent.velocity.y = parent.MAXALLSPEED
	if abs(parent.velocity.x) >= abs(parent.MAXAIRSPEED):
		if parent.velocity.x >0:
			if Input.is_action_pressed("left"):
				parent.velocity.x += -parent.AIR_ACCEL
			elif Input.is_action_pressed("right"):
				parent.velocity.x = parent.velocity.x
		if parent.velocity.x < 0:
			if Input.is_action_pressed("left"):
				parent.velocity.x = parent.velocity.x
			elif Input.is_action_pressed("right"):
				parent.velocity.x += parent.AIR_ACCEL
	elif abs(parent.velocity.x) < abs(parent.MAXAIRSPEED):
		if Input.is_action_pressed("left"):
			parent.velocity.x += -parent.AIR_ACCEL
		elif Input.is_action_pressed("right"):
			parent.velocity.x += parent.AIR_ACCEL
	
	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		if parent.velocity.x < 0:
			parent.velocity.x += parent.AIR_ACCEL / 5
		elif parent.velocity.x > 0:
			parent.velocity.x += -parent.AIR_ACCEL /5

func Landing():
	if state_includes([states.AIR]):
		if (parent.GroundL.is.colliding()) and parent.velocity.y >0:
			var collider = parent.GroundL.get_collider()
			parent.frame = 0
			if parent.velocity.y > 0:
				parent.velocity.y = 0
			parent.fastfall = false
			return true
		
		if (parent.GroundR.is.colliding()) and parent.velocity.y >0:
			var collider = parent.GroundR.get_collider()
			parent.frame = 0
			if parent.velocity.y > 0:
				parent.velocity.y = 0
			parent.fastfall = false
			return true
func Falling():
	if state_includes([states.RUN,states.WALK, states.STAND, states.CROUCH, states.LANDING, states.TURN, states.JUMP_SQUAT, states.MOONWALK, states.ROLL_RIGHT, states.ROLL_LEFT, states.PARRY]):
		if not parent.GROUNDL.is_colliding() and not parent.GroundR.is_colliding():
			return true   
