extends Node

signal mouse_moved
signal mouse_pressed
signal mouse_released

signal start_battle

signal card_hovered
signal card_hovered_off

signal player_turn_started
signal player_turn_ended
signal enemy_turn_started
signal enemy_turn_ended
signal left_mouse_button_pressed_on_card(card: Card)
signal left_mouse_button_pressed_on_deck
signal left_mouse_button_released

signal enemy_is_dead(enemy_card: EnemyCard)
signal enemy_card_clicked
