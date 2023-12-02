extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("nw").pressed.connect(self.Newgame)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func Newgame():
	get_tree().change_scene_to_file("res://escena1.tscn")
	
	

