extends Node2D

var pocao_cena = preload("res://objeto_pocao.tscn")
var flecha_cena = preload("res://flechas.tscn")

func _ready():
	randomize() #Pra criar posições aleatórias 
	
	
	gerar_itens(pocao_cena, 10)
	gerar_itens(flecha_cena, 20)

@onready var lista_de_pontos = $LocaisSeguros.get_children()

func gerar_itens(cena_do_item, quantidade: int):
	for i in range(quantidade):
		var novo_item = cena_do_item.instantiate()
		var ponto_sorteado = lista_de_pontos.pick_random()
		
		# Define a posição do item exatamente em cima da cruz do Marker2D escolhido
		novo_item.position = ponto_sorteado.global_position
		
		add_child(novo_item)
