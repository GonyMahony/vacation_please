extends Node2D


@onready var catalogue = $catalogue

var current_customer
var instance
var boss_portrait = load("res://Assets/animalsprites/boss.png")
var is_boss= false


@export var COMMISSION_PERCENTAGE = 0.15
@export var BONUS_PERCENTAGE = 0.4
@export var COURT_COST = 2000
@export var LYER_REWARD = 10
@export var LIE_COMING_OUT_PERCENTAGE = .5
@export var WRONG_CUSTOMER_FINE = 100
var boss_text = " "

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if Global.instance_loaded == true:
		instance = load("res://scenes/AI Message.tscn").instantiate()
		add_child(instance)
		new_customer()
		await get_tree().create_timer(1.0).timeout
	else:
		instance = load("res://scenes/AI Message.tscn").instantiate()
		add_child(instance)
		instance.boss_text("Hello ... Papa Seal, I hope I said that correctly. So when a client comes in you give them no more money than our maximum payout. You can see that in the conditions table. If you catch a liar they will not get any money. Have fun.")
		Global.instance_loaded = true
		$AnimalSprite.texture = boss_portrait
		$AnimationPlayer.play("customer_new")
		await get_tree().create_timer(1.0).timeout
		is_boss = true

func new_customer():
	Global.next_customer()
	current_customer = Global.client_dict[Global.current_customer]
	print(Global.current_customer)
	$AnimalSprite.texture = current_customer.portrait
	$AnimationPlayer.play("customer_new")
	instance.delete_text()
	instance.generate_text()

func show_boss(text):
	$AnimationPlayer.play("customer_leave")
	await get_tree().create_timer(1.0).timeout
	$AnimalSprite.texture = boss_portrait
	$AnimationPlayer.play("customer_new")
	instance.boss_text(text)
	print(text)
	await get_tree().create_timer(1.0).timeout
	is_boss = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	#turn off the catalogue if it is open
	if catalogue.openCatalogue.visible == true && event.is_pressed():
		catalogue.closeCanvas()
	
	#get rid of boss and load new customer
	if is_boss && event.is_pressed():
		is_boss = false
		$AnimationPlayer.play("customer_leave")
		await get_tree().create_timer(1.0).timeout
		new_customer()

#-------------------------------------------------------------------------------
# calculation outcomes
#-------------------------------------------------------------------------------

func commission(money):
	return money * COMMISSION_PERCENTAGE

func bonus(money):
	return money * BONUS_PERCENTAGE

func _on_main_ui_money_sent(customer: CustomerResource, amount: float) -> void:
	#first check if its the right customer
	if customer != current_customer:
		#if not get a fine
		Global.currency -= WRONG_CUSTOMER_FINE
		boss_text = "That was not the right customer! Shelly now has to fix your mistake and I`m making you pay for it."
	else:
		#if yes just continue
		if customer.is_lying: #if hes lying
			print("is lying")
			if amount <= 0:
				#we sused out the liar and get little money
				print("sussed out")
				boss_text = "We aint giving money to liars! Great that you sused that one out! Here is a little reward"
				Global.currency += LYER_REWARD
				show_boss(boss_text)
				return
			#50% chance of lie gets out
			elif randf() < LIE_COMING_OUT_PERCENTAGE:
				print("lie came out and we pay")
				#we pay everything
				Global.currency -= amount
				boss_text = "You pay for that liar from your own pocket!"
		print("lie didnt come out")
		#handeled customer well
		if amount == customer.max_payout : 
			if !customer.is_lying:
				Global.currency += commission(amount)
			print("customer handled well")
			boss_text = "Customer well handeled, heres the commission"
			#pay out of own pocket
		if amount > customer.max_payout:
			Global.currency -= (amount - customer.max_payout)
			print("gave too much money")
			boss_text = "No commission for you and you are paying everything over our max payout from your own pocket!"
			#get bonus since we save money
		if amount < customer.max_payout: 
			Global.currency += commission(amount) + bonus(customer.max_payout - amount)
			print("bonus")
			boss_text = "Nice you saved us some money, here is a bonus for the good work!"
			
			#the less we give them the higher the chance of being sued
			if amount < customer.price:
				if randf() < (customer.max_payout - amount) / customer.max_payout:
					if customer.is_lying:
						boss_text = "That liar tried to sue you, but the legal department handeled that, dont worry."
					else:
						print("sued")
						#rest of what they could have gotten + court cost
						boss_text = ("you got sued and have to pay: %s" % (customer.max_payout - amount + COURT_COST))
						Global.currency -= customer.max_payout - amount + COURT_COST
	#showing the boss:
	show_boss(boss_text)
