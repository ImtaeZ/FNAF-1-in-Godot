extends AnimatedSprite2D

func _ready() -> void:
	$rest.connect("timeout", restTimeout)
	$twitch.connect("timeout", twitchTimeout)
	$fade.connect("timeout", fadeTimeout)
	restStert()

# freddy twicthing
func restTimeout() -> void:
	frame = randi_range(1,3)
	twitchStart()
	
func twitchTimeout() -> void:
	frame = 0
	restStert()
	
func restStert() -> void:
	$rest.wait_time = randf_range(0.3, 4.0)
	$rest.start()

func twitchStart() -> void:
	$twitch.wait_time = randf_range(0.02, 0.07)
	$twitch.start()

# freddy fade
func fadeTimeout() -> void:
	modulate.a = randf_range(0.3, 1.0)
	$"../static".material.set_shader_parameter("alpha", randf_range(0.4, 0.6))
