extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	# Vamos imprimir o nome de quem encostou para você ver no console
	print("Algo encostou na espada: ", body.name)
	
	# Usamos 'is CharacterBody2D' para garantir que foi um personagem
	# E checamos se o nome é exatamente "Aja" (como está na sua árvore de nós)
	if body.name == "Aja":
		Global.tem_espada = true
		print("SUCESSO: Aja coletou a espada!")
		queue_free()
