extends Control
class_name HealthComponent

signal vida_mudou(vida_atual)
signal morreu

@export var vida_maxima: int = 20
@onready var vida_atual: int = vida_maxima
@onready var som_dano = get_node_or_null("SomDano")

func receber_dano(quantidade: int):
	vida_atual = clampi(vida_atual - quantidade, 0, vida_maxima)
	vida_mudou.emit(vida_atual)
	
	# Verifica se o nó de som realmente existe antes de tentar tocar!
	if som_dano != null:
		som_dano.play()
	
	if vida_atual <= 0:
		morreu.emit()
		
func curar(quantidade: int):
	# Só cura se a vida não estiver cheia
	if vida_atual < vida_maxima:
		# O clampi garante que a vida não passe do limite máximo
		vida_atual = clampi(vida_atual + quantidade, 0, vida_maxima)
		vida_mudou.emit(vida_atual)		
