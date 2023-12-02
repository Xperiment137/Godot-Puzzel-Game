extends Node2D

var texture = null
var points = 0
var numbers = []
const fotos = 27
var tname = null
var Original = {}
var Nuevo = {}
var last

# Called when the node enters the scene tree for the first time.
func _ready():
	#DirAccess.remove_absolute("user://save_game.dat")
	#DirAccess.remove_absolute("user://points.dat")
	last = loadX("user://save_game.dat")
	points = loadX("user://points.dat")
	print(points)
	if points == null:
		points = 0
	points = int(points)
	get_node("Label2").set_text(str(points))
	get_node("next").pressed.connect(self.reload)
	for button in self.get_children():
		if button is Button:
			button.pressed.connect(on_pressed.bind(button))
	MakePuzle()
	RandomOrder()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func get_cropped_texture(texture : Texture, region : Rect2) -> AtlasTexture:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.set_atlas(texture)
	atlas_texture.set_region(region)
	return atlas_texture
	

func MakePuzle():
	var aux = 1
	texture = getRandPic()
	get_node("imgfinal").set_texture(texture)
	get_node("imgfinal").set_visible(false)
	get_node("next").set_visible(false)
	for i in range(4):
		for j in range(4):
			var region_to_crop := Rect2((174*j),(174*i), 174, 174)
			get_node("Button" + str(aux)).set_button_icon(get_cropped_texture(texture, region_to_crop))
			Nuevo["Button" + str(aux)] = null
			Original["Button" + str(aux)] = aux
			aux+=1
			
			
func RandomOrder():
	var aux 
	var aux1
	while(numbers.size() <= 15):
		aux = (randi() % 16) + 1
		aux1 = (randi() % 16) + 1
		if (numbers.find(aux) == -1 and numbers.find(aux1) == -1) and (aux != aux1):
				numbers.append(aux)
				numbers.append(aux1)
				var taux = get_node("Button" + str(aux)).get_button_icon()
				get_node("Button" + str(aux)).set_button_icon(get_node("Button" + str(aux1)).get_button_icon())
				get_node("Button" + str(aux1)).set_button_icon(taux)
				Nuevo["Button" + str(aux)] = aux1
				Nuevo["Button" + str(aux1)] = aux
	
	
	
	
	
	
func on_pressed(button):
	if tname == null:
		tname = button.name
	else:
		var tgen = get_node(NodePath(button.name)).get_button_icon()
		get_node(NodePath(button.name)).set_button_icon(get_node(NodePath(tname)).get_button_icon())
		get_node(NodePath(tname)).set_button_icon(tgen)
		var numaux = Nuevo[button.name]
		Nuevo[button.name] = Nuevo[tname]
		Nuevo[tname] = numaux
		tname = null
		if(Nuevo.hash() == Original.hash()):
			for buttonx in self.get_children():
				if buttonx is Button:
					buttonx.set_visible(false)
			get_node("imgfinal").set_visible(true)
			get_node("next").set_visible(true)
			points+=1
			save(str(points),"user://points.dat")
			get_node("Label2").set_text(str(points))


func xd():
	print("Original:")	
	for i in Original:
		print("%s : %d" % [i, Original[i]])
	print("-----------------------------")		
	print("Nuevo:")	
	for i in Nuevo:
		print("%s : %d" % [i, Nuevo[i]])


func save(content,arch):
	var file = FileAccess.open(arch, FileAccess.WRITE)
	file.store_string(content)

func loadX(arch):
	var file = FileAccess.open(arch, FileAccess.READ)
	if file != null:
		var content = file.get_as_text()
		return content
	else:
		return null
		
func getRandPic():
	var aux
	aux = last 
	if last != null:
		while last == str(aux):
			aux = (randi()%fotos)+1
		save(str(aux),"user://save_game.dat")
		return load("res://fotos/" + "foto" + str(aux) + ".png") 
	else:
		aux = (randi()%fotos)+1
		save(str(aux),"user://save_game.dat")
		return load("res://fotos/" + "foto" + str(aux) + ".png") 
		

func reload():
	get_tree().reload_current_scene()
