extends Node

signal mouse_moved
signal mouse_pressed
signal mouse_released

signal card_hovered
signal card_hovered_off

signal left_mouse_button_pressed_on_card(card: Card)
signal left_mouse_button_pressed_on_deck

signal enemy_is_dead(enemy_card: EnemyCard)
signal enemy_card_clicked

signal character_selected(character_name: String)
signal node_selected(node: MapNode)
