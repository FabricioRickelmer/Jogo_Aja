extends CharacterBody2D

@export var cena_projetil = preload("res://Testes/Projetil.tscn")
@export var textura_projetil: Texture2D 
@export var velocidade = 60.0
@export var range_agressividade = 400.0
@export var range_ataque = 200.0

@onready var sprite = $AnimatedSprite2D
@onready var health_comp = $Componente_Vida
@onready var player = get_tree().current_scene.find_child("Aja", true, false)

func _ready():
	add_to_group("inimigos")
	if health_comp:
		health_comp.morreu.connect(queue_free)

func _physics_process(_delta):
	if player and sprite:
		var distancia = global_position.distance_to(player.global_position)
		if distancia < range_agressividade and distancia > range_ataque:
			var direcao = global_position.direction_to(player.global_position)
			velocity = direcao * velocidade
			move_and_slide()
			atualizar_animacao_direcional(direcao)
		else:
			velocity = Vector2.ZERO
			sprite.stop()

func atualizar_animacao_direcional(dir: Vector2):
	sprite.play("movimentacao") 
	if abs(dir.x) > abs(dir.y):
		sprite.frame = 3 if dir.x > 0 else 1
	else:
		sprite.frame = 0 if dir.y > 0 else 2

func _on_timer_timeout():
	if player:
		var distancia = global_position.distance_to(player.global_position)
		if distancia <= range_ataque:
			atirar()

func atirar():
	if not cena_projetil or not player: return
	
	var proj = cena_projetil.instantiate()
	proj.e_do_inimigo = true
	proj.global_position = global_position
	proj.direcao = (player.global_position - global_position).normalized()
	
	# 1. Configura a RAIZ do projétil para se destruir ao bater na Aja (Hurtbox na Layer 4)
	proj.collision_mask = 0 # Limpa tudo
	proj.set_collision_mask_value(4, true) 
	
	# 2. Configura a HITBOX interna para causar dano apenas como Inimigo (Layer 2)
	# ATENÇÃO: Verifique se "Componente_Hitbox" é o nome exato do nó dentro da cena Projetil.tscn
	var hitbox = proj.get_node_or_null("Componente_Hitbox") 
	if hitbox:
		hitbox.collision_layer = 0
		hitbox.set_collision_layer_value(2, true) 
		hitbox.collision_mask = 0
	
	if proj.has_method("configurar_visual"):
		proj.configurar_visual(textura_projetil)
		
	get_tree().current_scene.add_child(proj)
