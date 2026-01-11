extends Node

@export var ai_level : int = 20
const gameover_scene : String = "res://scenes/gameover.tscn"

# 1. EXPANDED STATES (Freddy's Path - Right Side Linear)
enum State { 
	SHOW_STAGE,       # Cam 1A
	DINING_AREA,      # Cam 1B
	RESTROOMS,        # Cam 7
	KITCHEN,          # Cam 6 (Audio Only)
	EAST_HALL,        # Cam 4A
	EAST_HALL_CORNER, # Cam 4B (Attack spot)
	OFFICE            # Attack
}

var current_state = State.SHOW_STAGE

@onready var door_sprite = $"../right door" 
@onready var main_script = $".." 
@onready var camera_button = $"../WinningTimer/cambutton" 

# Freddy specific sound node (Make sure you add this AudioStreamPlayer as a child!)
#@onready var laugh_noise = $LaughNoise 

func _ready() -> void:
	add_to_group("Enemies") 
	$MoveTimer.timeout.connect(_on_move_opportunity)

func _on_move_opportunity() -> void:
	var roll = randi_range(1, 20)
	
	if roll <= ai_level:
		# --- FREDDY MECHANIC: THE WATCHER ---
		# If camera is UP (-1) AND player is looking at Freddy's current cam, he fails to move.
		if camera_button.camstate == -1:
			var my_cam = get_camera_name(current_state)
			if $"../WinningTimer/map".current_camera == my_cam and $"../WinningTimer/map".current_camera != "CAM6":
				print("Freddy frozen by camera!")
				
				$MoveTimer.stop()
				await get_tree().create_timer(10).timeout
				if ai_level > 0: # Only restart if he's actually active
					$MoveTimer.start()
					
				return # STOP HERE
		
		#print("Freddy Move Successful! (Rolled: ", roll, ")")
		handle_movement()
	else:
		#print("Freddy failed to move. (Rolled: ", roll, ")")
		pass

func handle_movement() -> void:
	var previous_state = current_state
	
	# --- FREDDY'S PATHING LOGIC (Linear) ---
	match current_state:
		State.SHOW_STAGE:
			current_state = State.DINING_AREA
			$"../Freddy1".play()
			
		State.DINING_AREA:
			current_state = State.RESTROOMS
				
		State.RESTROOMS:
			current_state = State.KITCHEN
			# Optional: Play kitchen sound if he enters
			$"../kitchensound".play()
			
		State.KITCHEN:
			current_state = State.EAST_HALL
			# Optional: Stop kitchen sound if he leaves
			$"../kitchensound".stop()
			
		State.EAST_HALL:
			current_state = State.EAST_HALL_CORNER
			$"../Freddy2".play()
				
		State.EAST_HALL_CORNER:
			if is_door_closed():
				#print("Freddy blocked! Returning to East Hall.")
				current_state = State.EAST_HALL 
				# TODO: Play window knocking sound
			else:
				current_state = State.OFFICE
				$"../Freddy3".play()
				await get_tree().create_timer(2.5).timeout
				$"../Freddy3".stop()
				FreddyJumpscare()

# --- CHECK IF PLAYER CAUGHT HIM MOVING (Leaving OR Arriving) ---
	if current_state != previous_state:
		print("Freddy moved from ", State.keys()[previous_state], " to ", State.keys()[current_state])
		
		var previous_cam_name = get_camera_name(previous_state) # Leaving
		var new_cam_name = get_camera_name(current_state)      # Arriving (NEW)
		var player_cam = $"../WinningTimer/map".current_camera   # What you are watching
		
		# Check: Is Camera Up (-1) AND (Looking at Old Room OR Looking at New Room)
		if camera_button.camstate == -1:
			if player_cam == previous_cam_name or player_cam == new_cam_name:
				
				# 1. Trigger Static
				$"../WinningTimer/static2".visible = true
				$"../WinningTimer/static2/static sound".play()
				$"../WinningTimer/map".update_camera_view(player_cam)
				await get_tree().create_timer(1).timeout
				$"../WinningTimer/static2".visible = false
				$"../WinningTimer/static2/static sound".stop()
		
		# Force Visual Update
		if camera_button.camstate == -1:
			$"../WinningTimer/map".update_camera_view($"../WinningTimer/map".current_camera)

# Helper function for Freddy's Rooms
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
	#print("Freddy deactivating...")
	$MoveTimer.stop()

func FreddyJumpscare() -> void:
	$"../WinningTimer/clock/Timer".stop()
	$MoveTimer.stop()
	$"../BonnieAI/MoveTimer".stop()
	$"../ChicaAI/MoveTimer".stop()
	
	$"../main office/Camera2D".lock_to_right()
	
	$"../JumpScare noise".play()
	$"../FreddyJumpscare".visible = true
	$"../FreddyJumpscare".play()
	
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
	
	
	await get_tree().create_timer(0.7, true).timeout
	
	$"../JumpScare noise".stop()
	$"../FreddyJumpscare".visible = false
	$"../FreddyJumpscare".stop()
	$"../main office/Camera2D".set_process(true)
	
	get_tree().change_scene_to_file(gameover_scene)
