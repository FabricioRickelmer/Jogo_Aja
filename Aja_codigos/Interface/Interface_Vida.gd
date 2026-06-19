extends TextureProgressBar

func _ready() -> void:
	# Aguarda um frame para garantir que a Aja foi instanciada no cenário
	await get_tree().process_frame
	
	# Encontra o player na cena atual
	var player = get_tree().current_scene.find_child("Aja", true, false)
	
	if player:
		var health_comp = player.get_node_or_null("Componente_Vida")
		if health_comp:
			# Configura os valores da barra com base no componente
			max_value = health_comp.vida_maxima
			value = health_comp.vida_atual
			
			# Conecta o sinal para atualizar sempre que a vida mudar
			health_comp.vida_mudou.connect(_on_vida_mudada)

func _on_vida_mudada(nova_vida: int) -> void:
	# Se quiser uma barra que "desliza" suavemente, você pode usar um Tween aqui.
	# Por enquanto, uma atualização direta:
	value = nova_vida
