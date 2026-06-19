extends CharacterBody2D

@export var velocidade: float = 40.0
@onready var anim = $AnimatedSprite2D
@onready var timer = $TimerAcao

var direcao_atual: Vector2 = Vector2.ZERO
var em_movimento: bool = false

func _ready() -> void:
	# Assim que o NPC nasce, ele já toma a primeira decisão
	escolher_nova_acao()

func _physics_process(_delta: float) -> void:
	if em_movimento:
		velocity = direcao_atual * velocidade
		move_and_slide()
		atualizar_animacao()
	else:
		velocity = Vector2.ZERO
		anim.stop() # Para a animação se não estiver andando

func escolher_nova_acao() -> void:
	# Sorteia aleatoriamente (50% de chance) se vai andar ou ficar parado
	em_movimento = randi() % 2 == 0
	
	if em_movimento:
		# Gera um vetor de direção aleatório (x e y entre -1.0 e 1.0)
		direcao_atual = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		
	# Define um tempo aleatório para a próxima decisão (ex: entre 1 e 3 segundos)
	timer.start(randf_range(1.0, 3.0))

func atualizar_animacao() -> void:
	# Compara qual eixo tem o maior movimento para decidir qual animação tocar
	if abs(direcao_atual.x) > abs(direcao_atual.y):
		if direcao_atual.x > 0:
			anim.play("andar_direita")
		else:
			anim.play("andar_esquerda")
	else:
		if direcao_atual.y > 0:
			anim.play("andar_baixo")
		else:
			anim.play("andar_cima")

func _on_timer_acao_timeout() -> void:
	# Quando o tempo acaba, ele escolhe o que fazer de novo
	escolher_nova_acao()
