extends Node

@export var ai_level : int = 20

# FIX 1: Use string path to avoid "Cyclic Dependency" error
const gameover_scene : String = "res://scenes/gameover.tscn"

enum State { AWAY, AT_DOOR, JUMPSCARE }
var current_state = State.AWAY

@onready var door_sprite = $"../right door" 
@onready var main_script = $".." 

# FIX 2: Store the NODE, not the value
@onready var camera_button = $"../WinningTimer/cambutton" 

func _ready() -> void:
	# Add to group so 6 AM clock can find us
	add_to_group("Enemies") 
	$MoveTimer.timeout.connect(_on_move_opportunity)

func _on_move_opportunity() -> void:
	var roll = randi_range(1, 20)
	
	if roll <= ai_level:
		print("Chica Move Successful! (Rolled: ", roll, ")")
		handle_movement()
	else:
		print("Chica failed to move. (Rolled: ", roll, ")")

func handle_movement() -> void:
	match current_state:
		State.AWAY:
			print("Chica moved to the Door!")
			current_state = State.AT_DOOR
			
		State.AT_DOOR:
			if is_door_closed():
				print("Chica blocked! Returning to start.")
				current_state = State.AWAY
				# Optional: Play window knocking sound here?
			else:
				print("JUMPSCARE!")
				current_state = State.JUMPSCARE
				ChicaJumpscare()

func is_door_closed() -> bool:
	if door_sprite.frame == 0:
		return false # Door is OPEN
	else:
		return true # Door is CLOSED

# FIX 3: Added this function so the 6 AM clock can stop her
func stop_ai() -> void:
	print("Chica deactivating...")
	$MoveTimer.stop()

func ChicaJumpscare() -> void:
	# 1. Stop the clock
	$"../WinningTimer/clock/Timer".stop()
	
	# 3. Stop Logic
	$MoveTimer.stop()
	$"../BonnieAI/MoveTimer".stop()
	
	# 4. Jumpscare Sequence
	$"../main office/Camera2D".lock_to_center()
	$"../JumpScare noise".play()
	$"../ChicaJumpscare".visible = true
	$"../ChicaJumpscare".play()
	
	if camera_button.camstate != 1:
		$"../WinningTimer/static".visible = false
		$"../WinningTimer/whiterect".visible = false
		$"../WinningTimer/RedDot".visible = false
		$"../WinningTimer/map".visible = false
		camera_button.camstate = 1 
		$"../WinningTimer/CameraFlip".visible = true
		$"../WinningTimer/CameraFlip".play_backwards()
		await $"../WinningTimer/CameraFlip".animation_finished
		$"../WinningTimer/CameraFlip".visible = false
		$"../WinningTimer/cambutton/cam".visible = false
		
	await get_tree().create_timer(1.0, true).timeout
	
	$"../JumpScare noise".stop()
	$"../ChicaJumpscare".visible = false
	$"../ChicaJumpscare".stop()
	$"../main office/Camera2D".set_process(true)
	
	# 5. Change Scene (Using String path)
	get_tree().change_scene_to_file(gameover_scene)
