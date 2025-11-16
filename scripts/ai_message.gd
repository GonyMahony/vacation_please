extends Control

@onready var text_label = $PanelContainer/VBoxContainer/RichTextLabel
@onready var overview = $PanelContainer/VBoxContainer/Overview
var customer = 0

@export var client_name = ""
@export var client_condition = ""
@export var client_price = 0
@export var client_species = ""
@export var client_is_insured = true
@export var client_is_lying = false
@export var client_lie = ""
@export var client_text = ""

func _ready():
	await get_tree().process_frame


func boss_text(text):
	
	text_label.text = ""
	print("Hello")
	overview.text = "YOUR BOSS:"
	text_label.text = str(text)
	
	

func generate_text():
	
	#update current customer & variables
	customer = Global.current_customer
	print(str(customer) + " for AI")
	client_name = Global.client_dict[customer].name
	client_species = Global.client_dict[customer].species
	client_condition = Global.client_dict[customer].condition
	client_price = Global.client_dict[customer].price
	client_is_lying = Global.client_dict[customer].is_lying
	client_lie = Global.client_dict[customer].lie
	client_is_insured = Global.client_dict[customer].insured
	client_text = Global.client_dict[customer].text
	
	print(client_name)
	print(client_species)
	
	overview.text = ""
	text_label.text = ""
	overview.text = "Name: " + client_name + "\nSpecies: " + client_species + "\nCondition: " + client_condition + "\nClaim: " + str(client_price)
	text_label.text = client_text
	

func delete_text():
	overview.text = ""
	text_label.text = ""
