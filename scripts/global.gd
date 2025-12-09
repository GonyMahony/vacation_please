extends Node

@export var current_customer = 0
@export var last_customer = 7
var client_dict = {} #dictionary for clients showing up(same as below but randomized)
var clean_dict = {} #dictionary for buttons on pc
var scene
var first_call = true
var instance_loaded = false

var currency = 0



func _ready():
	client_list()
	
func client_list():
	load_and_randomize_clients()
	#next_customer()
	
func load_and_randomize_clients():
	var folder_path = "res://scripts/customers/"
	var clients: Array = []
	
	# Manually list all your .tres files
	var file_names = [
		"1.tres",
		"2.tres",
		"3.tres",
		"4.tres",
		"5.tres",
		"6.tres",
		"7.tres",
		"8.tres",
		"9.tres",
		"10.tres",
		"11.tres",
		"12.tres",
		"13.tres",
		"14.tres",
		"15.tres",
		"16.tres",
		"17.tres",
		"18.tres",
		"19.tres",
		"20.tres",
	]
	
	for file_name in file_names:
		var resource = load(folder_path + file_name)
		if resource:
			clients.append(resource)
	
	for i in range(clients.size()):
		clean_dict[i] = clients[i]
	
	clients.shuffle()
	
	for i in range(clients.size()):
		client_dict[i] = clients[i]
	
	print("Loaded ", client_dict.size(), " clients")


func get_all_customers_ordered() -> Array:
	return clean_dict.values()

func get_customer(index: int):
	return client_dict.get(index, null)

func get_all_customers() -> Array:
	return client_dict.values()

func next_customer():
	if current_customer >= last_customer:
		end_game()
	else:
		if first_call:
			first_call = false
			return get_customer(current_customer)
		current_customer += 1
		return get_customer(current_customer)

func end_game():
	print("Game Over")
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func reset():
	print("resetting")
	current_customer = 0
	first_call = true
	client_dict = {}
	clean_dict = {}
	client_list()
