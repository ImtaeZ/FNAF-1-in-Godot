extends Node

@export var ai_level : int = 20
const gameover_scene : String = "res://scenes/gameover.tscn"

# 1. EXPANDED STATES (Chica's Path - Right Side)
enum State { 
	SHOW_STAGE,       # Cam 1A
	DINING_AREA,      # Cam 1B
	RESTROOMS,        # Cam 7
	KITCHEN,          # Cam 6 (Audio Only usually)
	EAST_HALL,        # Cam 4A
	EAST_HALL_CORNER, # Cam 4B (Final spot)
	OFFICE            # Attack
}

var current_state = State.SHOW_STAGE

@onready var door_sprite = $"../right door" 
@onready var main_script = $".." 
@onready var camera_button = $"../WinningTimer/cambutton" 

func _ready() -> void:
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
	var previous_state = current_state
	
	# --- CHICA'S PATHING LOGIC ---
	match current_state:
		State.SHOW_STAGE:
			current_state = State.DINING_AREA
			
		State.DINING_AREA:
			# Randomly go to Restrooms or Kitchen
			if randf() > 0.5: current_state = State.RESTROOMS
			else: current_state = State.KITCHEN
				
		State.RESTROOMS:
			current_state = State.KITCHEN
			
		State.KITCHEN:
			# Go to East Hall
			current_state = State.EAST_HALL
			# TODO: Stop playing "Pots and Pans" noise if leaving Kitchen
			
		State.EAST_HALL:
			# Randomly go forward to Corner or retreat to Dining
			if randf() > 0.6: 
				current_state = State.EAST_HALL_CORNER
			else:
				current_state = State.DINING_AREA
				
		State.EAST_HALL_CORNER:
			if is_door_closed():
				print("Chica blocked! Retreating.")
				current_state = State.EAST_HALL # She often steps back just one room
				# TODO: Play window knocking sound
			else:
				current_state = State.OFFICE
				ChicaJumpscare()

	# --- CHECK IF PLAYER CAUGHT HER MOVING ---
	if current_state != previous_state:
		print("Chica moved from ", State.keys()[previous_state], " to ", State.keys()[current_state])
		
		var previous_cam_name = get_camera_name(previous_state)
		
		# Check: Camera Up AND Player looking at old room
		if camera_button.camstate == -1 and $"../WinningTimer/map".current_camera == previous_cam_name:
			print("Player saw Chica move on camera!")
			
			# Trigger Static
			$"../WinningTimer/static2".visible = true
			$"../WinningTimer/static2/static sound".play()
			await get_tree().create_timer(1).timeout
			$"../WinningTimer/static2".visible = false
			$"../WinningTimer/static2/static sound".stop()
		
		# Force Visual Update
		if camera_button.camstate == -1:
			$"../WinningTimer/map".update_camera_view($"../WinningTimer/map".current_camera)

# Helper function for Chica's Rooms
func get_camera_name(state: State) -> String:
	match state:
		State.SHOW_STAGE: return "CAM1A"
		State.DINING_AREA: return "CAM1B"
		State.RESTROOMS: return "CAM7"
		State.KITCHEN: return "CAM6"
		State.EAST_HALL: return "CAM4A"
		State.EAST_HALL_CORNER: return "CAM4B"
		_: return ""

func is_door_closed() -> bool:
	return door_sprite.frame != 0

func stop_ai() -> void:
	print("Chica deactivating...")
	$MoveTimer.stop()

func ChicaJumpscare() -> void:
	$"../WinningTimer/clock/Timer".stop()
	$MoveTimer.stop()
	$"../BonnieAI/MoveTimer".stop()
	
	# Force Camera Down
	if camera_button.camstate != 1:
		$"../WinningTimer/static".visible = false
		$"../WinningTimer/whiterect".visible = false
		$"../WinningTimer/RedDot".visible = false
		$"../WinningTimer/map".visible = false
		
		camera_button.camstate = 1 
		
		$"../WinningTimer/CameraFlip".visible = true
		$"../WinningTimer/CameraFlip".play_backwards()
		$"../WinningTimer/CameraFlip/flipnoise".play()
		await $"../WinningTimer/CameraFlip".animation_finished
		$"../WinningTimer/CameraFlip".visible = false
		$"../WinningTimer/CameraFlip/flipnoise".stop()
		$"../WinningTimer/cambutton/cam".visible = false
	
	$"../main office/Camera2D".lock_to_center()
	$"../JumpScare noise".play()
	$"../ChicaJumpscare".visible = true
	$"../ChicaJumpscare".play()
	
	await get_tree().create_timer(1.0, true).timeout
	
	$"../JumpScare noise".stop()
	$"../ChicaJumpscare".visible = false
	$"../ChicaJumpscare".stop()
	$"../main office/Camera2D".set_process(true)
	
	get_tree().change_scene_to_file(gameover_scene)
