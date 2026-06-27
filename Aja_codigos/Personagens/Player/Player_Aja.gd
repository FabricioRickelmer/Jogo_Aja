extends CharacterBody2D

const VELOCIDADE = 300.0
enum Estados {NORMAL, ATACANDO, ATIRANDO}
var estado_atual = Estados.NORMAL

# Variável atualizada para controlar o nome da animação ao invés de números soltos
var animacao_direcao = "andar_baixo" 
var direcao_disparo = Vector2.DOWN

# Nova variável para lembrar onde o jogo começou
var posicao_inicial: Vector2

@onready var som_passos = $SomPassos
@onready var sprite = $AnimatedSprite2D
@onready var health_comp = $Componente_Vida
@export var textura_flecha = preload("res://Combate/Projetil.png")
@onready var cena_flecha = preload("res://Testes/Projetil.tscn")
@onready var som_cura = $SomCura

func _ready() -> void:
	# Grava a coordenada exata em que a Aja nasceu no mapa
	posicao_inicial = global_position

func _physics_process(_delta: float) -> void:
	match estado_atual:
		Estados.NORMAL:
			processar_movimento()
			checar_ataque()
			checar_cura()
		Estados.ATACANDO, Estados.ATIRANDO:
			velocity = Vector2.ZERO
	move_and_slide()
	
	# Se estiver se movendo, verifica se o som já está tocando. Se não estiver, toca.
	if velocity != Vector2.ZERO:
		if not som_passos.playing:
			som_passos.play()

func processar_movimento():
	var entrada := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if entrada != Vector2.ZERO:
		velocity = entrada * VELOCIDADE
		atualizar_animacao_por_direcao(entrada)
		# Toca a animação correspondente (ex: "andar_direita")
		sprite.play(animacao_direcao)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, VELOCIDADE)
		sprite.stop()
		# Força o frame 0 (Aja parada) quando não há movimento
		sprite.frame = 0 

func atualizar_animacao_por_direcao(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animacao_direcao = "andar_direita"
			direcao_disparo = Vector2.RIGHT
		else:
			animacao_direcao = "andar_esquerda"
			direcao_disparo = Vector2.LEFT
	else:
		if dir.y > 0:
			animacao_direcao = "andar_baixo"
			direcao_disparo = Vector2.DOWN
		else:
			animacao_direcao = "andar_cima"
			direcao_disparo = Vector2.UP

func checar_ataque():
	if Input.is_action_just_pressed("ataque_arco"):
		atirar_arco()

func atirar_arco():
	if not cena_flecha: return
	
	estado_atual = Estados.ATIRANDO
	var flecha = cena_flecha.instantiate()
	
	flecha.e_do_inimigo = false
	flecha.global_position = global_position
	flecha.direcao = direcao_disparo
	
	# 1. Configura a RAIZ da flecha para se destruir ao bater em Inimigos (Hurtbox na Layer 5)
	flecha.collision_mask = 0 
	flecha.set_collision_mask_value(5, true) 
	
	# 2. Configura a HITBOX interna da flecha para causar dano como Player (Layer 3)
	var hitbox = flecha.get_node_or_null("Componente_Hitbox") 
	if hitbox:
		hitbox.collision_layer = 0
		hitbox.set_collision_layer_value(3, true) 
		hitbox.collision_mask = 0
	
	if flecha.has_method("configurar_visual"):
		flecha.configurar_visual(textura_flecha)
	
	get_tree().current_scene.add_child(flecha)
	
	await get_tree().create_timer(0.4).timeout
	estado_atual = Estados.NORMAL

func checar_cura():
	if Input.is_action_just_pressed("usar_pocao"):
		# 1. Verifica se tem poção na mochila E se a vida precisa ser curada
		if Global.pocao > 0 and health_comp.vida_atual < health_comp.vida_maxima:
			
			# 2. Gasta uma poção do inventário
			Global.pocao -= 1 
			
			# 3. Cura os 3 pontos (que equivalem a 1,5 corações)
			health_comp.curar(3) 
			som_cura.play()
			
			print("Curou! Poções restantes: ", Global.pocao)
		elif Global.pocao <= 0:
			print("Sem poções no inventário!")
		else:
			print("A vida já está cheia!")

# Nova função que roda assim que o Componente_Vida zera e emite o sinal "morreu"
func _on_componente_vida_morreu() -> void:
	# 1. Teleporta a Aja de volta para o ponto inicial
	global_position = posicao_inicial
	
	# 2. Encontra o componente de vida e restaura a saúde dela
	var vida = $Componente_Vida
	vida.vida_atual = vida.vida_maxima
	
	# 3. Emite o sinal de que a vida mudou (Isso avisa a barrinha/corações 
	# da interface na tela que ela voltou a ficar cheia)
	vida.vida_mudou.emit(vida.vida_atual)
