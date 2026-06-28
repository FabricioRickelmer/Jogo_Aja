extends Node2D

var mobs_vivos: int
var cena_espada_item = preload("res://Itens/32x32/Arma.png") 

func _ready():
	# Conta quantos inimigos existem dentro deste nó
	var mobs = get_children()
	mobs_vivos = mobs.size()
	
	# Conecta o sinal de morte de cada um deles
	for mob in mobs:
		if mob.has_node("Componente_Vida"):
			var vida = mob.get_node("Componente_Vida")
			# O .bind() passa qual mob morreu para podermos pegar a posição dele
			vida.morreu.connect(_on_mob_morreu.bind(mob))

func _on_mob_morreu(mob_morto: Node2D):
	mobs_vivos -= 1
	
	if mobs_vivos <= 0:
		dropar_espada(mob_morto.global_position)

func dropar_espada(posicao_final: Vector2):
	var espada = cena_espada_item.instantiate()
	espada.global_position = posicao_final
	# Adiciona a espada no mapa (parente da Arena) para ela não sumir
	get_parent().call_deferred("add_child", espada)
