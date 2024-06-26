extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -600.0
const form = ["frog", "cat", "dog", "bird", "rat"]
const DG = ["Gato: Hahaha, meu dono nunca me
deixava em paz, mas desde que fugi,
estou livre para aproveitar o mundo
da forma que eu quero. ;3","Você: Não se sente sózinho?","Gato: Um pouco, mas prefiro ser 
solitário a perder minha liberdade.","Você: Que tal explorar-mos o mundo 
juntos?"]
const DP = ["Pombo: Hum... Ah, oi.
Eu tava pensando. Preciso passar 
por cima daquela casa ali ó, mas 
aquele cachorro ta mó bravo comigo.", "Pombo:Pq sempre q eu vou por lá 
eu faço cocô no telhado...","Você: Acho q posso te ajudar... 
Vem comigo...","Pombo: Séro?! Valeu cara!", "Pombo: AAAAAHHH!
UM GATO CARALHO!
FOGE MULEQUE!"]
const DD = ["Cachorro: Bom dia! 
Posso ser seu amigo?", "Você:...","Cachorro: Como tu tem coragem!  
Vaza daqui seu pombo safado!","Cachorro: GRRRRRRRR!!!"]
const DR = ["Rato: Eu não iria nessa direção 
se eu fosse você...", 
"Você: Mas eu preciso! 
Minha... casa fica pra lá.","Rato: Você não duraria um dia 
caminhando. O lixo é toxico 
para qualquer tipo de animal...","Você: Eu terei que arriscar...", 
"Rato: É realmente tão importante 
assim para você? 
Arriscaria a vida só 
para voltar pra casa?", "Rato: Tem ao menos alguem te 
esperando lá?", "Você: Se estão me esperando ou não. 
Eu não sei, mas sinto a falta deles...", "Rato: ... *suspiro* Acho que deveria 
te acompanhar então..."]
const DM = ["Urg, n consigo nadar...
 
melhor tentar outra forma...", 
"O dono não ficou feliz em me ver...

melhor tentar outra forma...",
"Caramba, que fedor insuportavel...

melhor tentar outra forma...",
"... Será que realmente... 
esperam por mim?"]
var current_form = 0
var d=[0,0,0,0]
var DJump = 1
var in_water = false
var in_house = false
var in_esgoto = false
var in_fin = false
var in_fin2 = false
var transition = false
@onready var s2 = get_node("Inv_UI/NinePatchRect/GridContainer/inv_UI_slot2")
@onready var s3 = get_node("Inv_UI/NinePatchRect/GridContainer/inv_UI_slot3")
@onready var s4 = get_node("Inv_UI/NinePatchRect/GridContainer/inv_UI_slot4")
@onready var s5 = get_node("Inv_UI/NinePatchRect/GridContainer/inv_UI_slot5")
@onready var s6 = get_node("Inv_UI/NinePatchRect/GridContainer/inv_UI_slot6")


@onready var sprite_2d = $Sprite2D
@onready var collision_shape = $CollisionShape2D

@export var inv: Inv

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_area_2d_body_entered(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_water = true


func _on_area_2d_body_exited(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_water = false


func _physics_process(delta):
	var g= gravity
	if transition:
		%M1.volume_db -= 0.1
		if %M1.volume_db < 0 and %M2.volume_db < 24:
			%M2.volume_db += 0.1
	
	if form[current_form]=='cat':
		if not in_esgoto and not in_fin and not in_fin2:
			SPEED=400
		JUMP_VELOCITY=-800
	elif form[current_form]=='frog':
		if not in_esgoto and not in_fin and not in_fin2:
			SPEED=300
		JUMP_VELOCITY=-600
	elif form[current_form]=='bird':
		if not in_esgoto and not in_fin and not in_fin2:
			SPEED=300
		JUMP_VELOCITY=-200
	elif form[current_form]=='dog':
		if not in_esgoto and not in_fin and not in_fin2:
			SPEED=450
		JUMP_VELOCITY=-500
	elif form[current_form]=='rat':
		if not in_fin2:
			SPEED=500
			JUMP_VELOCITY=-250
	
	#Animations
	if (velocity.x > 1 || velocity.x < -1 ):
		sprite_2d.animation =form[current_form]+"_running"
	else:
		sprite_2d.animation = form[current_form]+"_idle"
	
	# Add the gravity.
	if not is_on_floor():
		if form[current_form]=='bird':
			g=gravity/2
			sprite_2d.animation =form[current_form]+"_running"
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY
		else:
			g=gravity
			sprite_2d.animation = form[current_form]+"_jumping"
		if in_water:
			velocity.y += g/9.8 * delta
			velocity.y = clamp(velocity.y, -350, 350)
		else:
			velocity.y += g * delta
		if Input.is_action_just_pressed("jump") and form[current_form]=='cat' and DJump==1:
			velocity.y = JUMP_VELOCITY
			DJump=0
	else:
		DJump=1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if in_water:
			velocity.y = JUMP_VELOCITY/2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		if not in_water:
			velocity.x = direction * SPEED
		else:
			velocity.x = direction * SPEED/2
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	move_and_slide()
	_update_collision_shape()
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

func _ready():
	%M2.volume_db = -10
	var invent = get_node("Inv_UI")
	invent.slot_clicked.connect(_on_slot_clicked)
	_update_collision_shape()
	%DialogoGato.visible=false
	%DialogoPombo.visible=false
	%DialogoCachorro.visible=false
	%DialogoRato.visible=false
	%TextoGato.text=DG[d[0]%4]
	%TextoPombo.text=DP[d[1]%4]
	%TextoCachorro.text=DD[d[2]%2]
	%TextoRato.text=DR[d[3]%8]
	var s1 = get_node("Inv_UI/NinePatchRect/GridContainer/inv_UI_slot")
	s2.visible=false
	s3.visible=false
	s4.visible=false
	s5.visible=false
	s6.visible=false


func _on_slot_clicked(slot):
	var prefix = "inv_UI_slot"
	var c = int(str(slot)[prefix.length()])
	if (c>0):
		c-=1
	current_form=c
	if(form[current_form]=="dog"):
		position.y-=5

func _update_collision_shape():
	if Input.is_action_just_pressed("t") and %DialogoGato.visible and d[0]<3:
		d[0]=d[0]+1
	elif Input.is_action_just_pressed("t") and d[0]==3:
		s2.visible=true
		%CatNPC.visible=false
		%DialogoGato.visible=false
	%TextoGato.text=DG[d[0]%4]
	if Input.is_action_just_pressed("t") and %DialogoPombo.visible and form[current_form]!="cat" and d[1]<3:
		d[1]=d[1]+1
	elif Input.is_action_just_pressed("t") and d[1]==3:
		s4.visible=true
		%BirdNPC.visible=false
		%DialogoPombo.visible=false
	if form[current_form]!="cat":
		%TextoPombo.text=DP[d[1]%4]
	else:
		%TextoPombo.text=DP[4]
	if Input.is_action_just_pressed("t") and %DialogoCachorro.visible and d[2]<1 and form[current_form]!="cat" and form[current_form]!="bird":
		d[2]=d[2]+1
	elif Input.is_action_just_pressed("t") and d[2] == 1:
		s3.visible=true
		%DogNPC.visible=false
		%DialogoCachorro.visible=false
	if form[current_form]=="cat":
		%TextoCachorro.text=DD[3]
	elif form[current_form]=="bird":
		%TextoCachorro.text=DD[2]
	else:
		%TextoCachorro.text=DD[d[2]%2]
	if Input.is_action_just_pressed("t") and %DialogoRato.visible and d[3]<7:
		d[3]=d[3]+1
		if d[3]==7:
			s5.visible=true
			%RatNPC.visible=false
			%DialogoRato.visible=false
	%TextoRato.text=DR[d[3]%8]
	if (form[current_form]=="cat" and velocity.x!=0):
		var shape = collision_shape.shape
		shape.extents = Vector2(30, 20)
	elif (form[current_form]=="dog"):
		var shape = collision_shape.shape
		shape.extents = Vector2(30, 35)
		if(velocity.x!=0):
			shape.extents = Vector2(30, 39)
	elif (form[current_form]=="rat" or form[current_form]=="bird"):
		var shape = collision_shape.shape
		shape.extents = Vector2(25, 16)
	else:
		var shape = collision_shape.shape
		shape.extents = Vector2(30, 30)
	if Input.is_action_just_pressed("t"):
		%DialogoMC.visible=false
		if in_fin2:
			%DialogoRato2.visible=false
			%Fim.position.x-=20
			%Fim.text="The real end"
			%Fim.visible=true
			%BFim.visible=true
	_ambient_controll()

func _ambient_controll():
	if in_water and form[current_form]!='frog':
		%MC.position.x=2050
		%MC.position.y=300
		%TextoMC.text=DM[0]
		%DialogoMC.visible=true
	if in_house and form[current_form]!='dog':
		%MC.position.x=4800
		%MC.position.y=300
		%TextoMC.text=DM[1]
		%DialogoMC.visible=true
	if in_esgoto and form[current_form]!='rat':
		SPEED=50
		%TextoMC.text=DM[2]
		%DialogoMC.visible=true
	if in_fin:
		SPEED=0
		JUMP_VELOCITY=0
		%TextoMC.text=DM[3]
		if Input.is_action_just_pressed("t"):
			%DialogoMC.visible=false
			%Fim.visible=true
			%BFim.visible=true
	elif not in_fin2:
		%Fim.visible=false
		%BFim.visible=false

func _on_area_2d_2_body_entered(body):
	if body == self and d[0]<3: 
		%DialogoGato.visible = true


func _on_area_2d_2_body_exited(body):
	if body == self:
		%DialogoGato.visible = false


func _on_area_d_pombo_body_entered(body):
	if body == self and d[1]<3: 
		%DialogoPombo.visible = true


func _on_area_d_pombo_body_exited(body):
	if body == self:
		%DialogoPombo.visible = false


func _on_area_d_cachorro_body_entered(body):
	if body == self and d[2]<1:
		%DialogoCachorro.visible = true


func _on_area_d_cachorro_body_exited(body):
	if body == self:
		%DialogoCachorro.visible = false


func _on_area_d_rato_body_entered(body):
	if body == self and d[3]<7:
		%DialogoRato.visible = true


func _on_area_d_rato_body_exited(body):
	if body == self:
		%DialogoRato.visible = false


func _on_area_d_esgoto_body_entered(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_esgoto = true


func _on_area_d_esgoto_body_exited(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_esgoto = false


func _on_area_d_casa_body_entered(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_house = true


func _on_area_d_casa_body_exited(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_house = false
		transition=true


func _on_area_d_fim_body_entered(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_fin = true
		%DialogoMC.visible=true


func _on_button_pressed():
	get_tree().quit()


func _on_area_d_fim_body_exited(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_fin = false


func _on_area_d_fim_2_body_entered(body):
	if body == self:  # Verifica se o corpo é o personagem
		in_fin2 = true
		SPEED=0
		JUMP_VELOCITY=0
		%DialogoRato2.visible=true
		if Input.is_action_just_pressed("t"):
			%DialogoRato2.visible=false
			%Fim.position.x-=20
			%Fim.text="The real end"
			%Fim.visible=true
			%BFim.visible=true
