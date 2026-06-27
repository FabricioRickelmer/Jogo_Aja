extends HitboxComponent

func _ready():
	# Define o valor do dano que a espada vai causar. 
	# (Se a variável "damage" já estiver declarada lá no seu script original 
	# do HitboxComponent, essa linha apenas altera o valor dela para a espada)
	damage = 5

func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
