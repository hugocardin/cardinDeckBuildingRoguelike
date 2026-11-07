extends Node2D

func _ready() -> void:
	for character_name in CharacterDatabase.CHARACTERS:
		var button = Button.new()
		button.text = character_name.capitalize()
		button.pressed.connect(_on_character_selected.bind(character_name))
		$VBoxContainer.add_child(button)

func _on_character_selected(character_name: String):
	GameState.set_character(character_name)
	
	SceneManager.go_to_map()
