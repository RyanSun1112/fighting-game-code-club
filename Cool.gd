extends CharacterBody2D

@export var hitbox: PackedScene
var selfState



var jump_squat = 3
var lag_frames = 0
var landing_frames = 0





@onready var GroundL = get_node("Raycasts/GroundL")
@onready var GroundR = get_node("Raycasts/GroundLR")



var dash_duration = 10

var RUNSPEED = 340
var DASHSPEED = 390
var WALKSPEED = 200
var GRAVITY = 1800
var JUMPFORCE = 500
var MAX_JUMPFORCE = 800
var DOUBLEJUMPFORCE = 1000
var MAXAIRSPEED = 300
var AIR_ACCEL = 25
var FALLSPEED = 60
var FALLINGSPEED = 900
var MAXFALLSPEED = 900
var TRACTION = 40
var ROLL_DISTANCE = 350
var air_dodge_speed = 500
var UP_B_LAUNCHSPEED = 700

@onready var states = $State

var frame = 0
func updateframes(delta):
	frame += 1

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	$Sprite.set_flip_h(direction)

func _frame():
	frame = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _physics_process(delta):
	$Frame.text = str(frame)
	selfState = states.text
	
