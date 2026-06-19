extends Node2D

@export var tipos_de_npcs: Array[PackedScene]
@export var quantidade_total: int = 15

# Conecta a pasta de pontos seguros ao código
@onready var pontos_seguros = $PontosSeguros

func _ready() -> void:
	gerar_npcs()

func gerar_npcs() -> void:
	if tipos_de_npcs.is_empty():
		print("Nenhum NPC adicionado à lista do gerador!")
		return
		
	# Cria uma lista com todos os Marker2D que você espalhou no mapa
	var lista_de_pontos = pontos_seguros.get_children()
	
	if lista_de_pontos.is_empty():
		print("Você esqueceu de colocar Marker2D dentro do nó Pontos_Seguros!")
		return

	for i in range(quantidade_total):
		var cena_escolhida = tipos_de_npcs.pick_random()
		if cena_escolhida == null:
			continue
			
		var npc = cena_escolhida.instantiate()
		
		# Sorteia aleatoriamente um dos seus marcadores espalhados
		var ponto_sorteado = lista_de_pontos.pick_random()
		
		# Coloca o NPC na posição do marcador escolhido
		npc.position = ponto_sorteado.global_position
		
		# Adiciona um pequeno desvio aleatório (+- 20 pixels) para 
		# que os NPCs não fiquem exatamente um em cima do outro se
		# o gerador sortear o mesmo marcador duas vezes
		npc.position.x += randf_range(-20.0, 20.0)
		npc.position.y += randf_range(-20.0, 20.0)
		
		add_child(npc)
