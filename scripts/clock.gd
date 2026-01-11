extends Label

# --- SETTINGS ---
@export var total_night_duration : float = 600

var current_hour : int = 12

func _ready() -> void:
	var seconds_per_hour = total_night_duration / 6.0
	
	#print("Night Length: ", total_night_duration, "s. One hour is: ", seconds_per_hour, "s.")
	
	$Timer.wait_time = seconds_per_hour
	$Timer.start() # Start the timer with the new calculated time
	
	text = "12 AM"
	
	if not $Timer.timeout.is_connected(_on_timer_timeout):
		$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	current_hour += 1
	
	if current_hour > 12:
		current_hour = 1
	
	text = str(current_hour) + " AM"
	
	if current_hour == 6:
		game_won()

func game_won() -> void:
	print("6 AM! YOU SURVIVED!")
	get_tree().paused = true
	$"../../fan noise".stop()
	$"../../left switch/light noise".stop()
	$"../../right switch/light noise".stop()
	$"../../LightOut/muscibox".stop()
	$"../../LightOut/powerdown noise".stop()
	$Timer.stop()
	
	# Stop all AI
	$"../../BonnieAI/MoveTimer".stop()
	$"../../ChicaAI/MoveTimer".stop()
	
	$"../winningscene".visible = true
	$"../fadewinning".play("fadewin")
	$"../winningscene/AnimationPlayer".play("sliding")
	$"../winningscene/schoolbell".play()
	await get_tree().create_timer(3).timeout
	$"../winningscene/yay".play()
	await get_tree().create_timer(7).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title.tscn")
	
