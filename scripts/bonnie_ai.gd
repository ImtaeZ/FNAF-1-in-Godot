extends Node

@export var ai_level : int = 20
const gameover_scene : String = "res://scenes/gameover.tscn"

enum State { 
	SHOW_STAGE,       # Cam 1A
	DINING_AREA,      # Cam 1B
	BACKSTAGE,        # Cam 5
	WEST_HALL,        # Cam 2A
	SUPPLY_CLOSET,    # Cam 3
	WEST_HALL_CORNER, # Cam 2B
	OFFICE            # Inside the room
}

var current_state = State.SHOW_STAGE

@onready var door_sprite = $"../left door" 
@onready var main_script = $".." 
@onready var camera_button = $"../WinningTimer/cambutton"

func _ready() -> void:
	add_to_group("Enemies")
	$MoveTimer.timeout.connect(_on_move_opportunity)

func _on_move_opportunity() -> void:
	var roll = randi_range(1, 20)
	
	if roll <= ai_level:
		#print("Bonnie Move Successful! (Rolled: ", roll, ")")
		handle_movement()
	else:
		#print("Bonnie failed to move. (Rolled: ", roll, ")")
		pass

func handle_movement() -> void:
	var previous_state = current_state
	
	# --- MOVEMENT LOGIC ---
	match current_state:
		State.SHOW_STAGE:
			current_state = State.DINING_AREA
		State.DINING_AREA:
			if randf() > 0.5: current_state = State.BACKSTAGE
			else: current_state = State.WEST_HALL
		State.BACKSTAGE:
			current_state = State.DINING_AREA
		State.WEST_HALL:
			if randf() > 0.5: current_state = State.SUPPLY_CLOSET
			else: current_state = State.WEST_HALL_CORNER
		State.SUPPLY_CLOSET:
			current_state = State.WEST_HALL_CORNER
		State.WEST_HALL_CORNER:
			if is_door_closed():
				#print("Bonnie blocked! Retreating.")
				current_state = State.DINING_AREA 
				# TODO: Play banging sound
			else:
				current_state = State.OFFICE
				BonnieJumpscare()

	# --- CHECK IF PLAYER CAUGHT HIM MOVING ---
	if current_state != previous_state:
		print("Bonnie moved from ", State.keys()[previous_state], " to ", State.keys()[current_state])
		
		# 1. Get the camera name for where Bonnie JUST WAS
		var previous_cam_name = get_camera_name(previous_state)
		
		# 2. Check: Is Camera Up (-1) AND Is Player looking at that specific camera?
		if camera_button.camstate == -1 and $"../WinningTimer/map".current_camera == previous_cam_name:
			#print("Player saw Bonnie move on camera!")
			
			$"../WinningTimer/static2".visible = true
			$"../WinningTimer/static2/static sound".play()
			await get_tree().create_timer(1).timeout
			$"../WinningTimer/static2".visible = false
			$"../WinningTimer/static2/static sound".stop()
		
		# Optional: Force update the visuals immediately so he disappears instantly
		#print("CURRENT CAM : ", $"../WinningTimer/map".current_camera)
		if camera_button.camstate == -1:
			$"../WinningTimer/map".update_camera_view($"../WinningTimer/map".current_camera)

# Helper function to map your States to Camera Names
func get_camera_name(state: State) -> String:
	match state:
		State.SHOW_STAGE: return "CAM1A"
		State.DINING_AREA: return "CAM1B"
		State.BACKSTAGE: return "CAM5"
		State.WEST_HALL: return "CAM2A"
		State.SUPPLY_CLOSET: return "CAM3"
		State.WEST_HALL_CORNER: return "CAM2B"
		_: return ""

func is_door_closed() -> bool:
	return door_sprite.frame != 0

func BonnieJumpscare() -> void:
	$"../WinningTimer/clock/Timer".stop()
	$MoveTimer.stop()
	$"../ChicaAI/MoveTimer".stop()
	
	$"../main office/Camera2D".lock_to_center()
	$"../JumpScare noise".play()
	$"../BonnieJumpscare".visible = true
	$"../BonnieJumpscare".play()
	
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
	
	await get_tree().create_timer(1.0, true).timeout
	$"../JumpScare noise".stop()
	$"../BonnieJumpscare".visible = false
	$"../BonnieJumpscare".stop()
	$"../main office/Camera2D".set_process(true)
	get_tree().change_scene_to_file(gameover_scene)
