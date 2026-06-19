extends Control

# Referência ao container que você mostrou na imagem
@onready var barra_vida = $Barra_vida

# Carrega as texturas dos corações
var tex_cheio = preload("res://Interface/Coracao_cheio.png")
var tex_metade = preload("res://Interface/Coracao_metade.png")
var tex_vazio = preload("res://Interface/Coracao_vazio.png")

func _ready():
	# Aguarda um frame para garantir que a Aja nasceu no cenário
	await get_tree().process_frame
	conectar_ao_player()

func conectar_ao_player():
	var player = get_tree().current_scene.find_child("Aja", true, false)
	if player:
		var health_comp = player.get_node_or_null("Componente_Vida")
		if health_comp:
			# Conecta o sinal para atualizar sempre que a vida mudar
			health_comp.vida_mudou.connect(atualizar_vida)
			# Atualização inicial
			atualizar_vida(health_comp.vida_atual)
	else:
		# Se não achou, tenta novamente em 1 segundo
		await get_tree().create_timer(1.0).timeout
		conectar_ao_player()

func atualizar_vida(vida_atual: int):
	if not barra_vida: return
	
	# Pega todos os TextureRects (Coracao1, Coracao2, etc) que estão dentro da Barra_vida
	var coracoes = barra_vida.get_children()
	
	for i in range(coracoes.size()):
		# Cada coração vale 2 pontos (sistema tipo Zelda)
		var valor_base = i * 2
		
		if vida_atual >= valor_base + 2:
			coracoes[i].texture = tex_cheio
		elif vida_atual == valor_base + 1:
			coracoes[i].texture = tex_metade
		else:
			coracoes[i].texture = tex_vazio
