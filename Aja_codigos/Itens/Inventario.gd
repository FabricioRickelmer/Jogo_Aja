extends Sprite2D

func _ready():
	print("O script do inventario esta rodando!")
	$".".visible = false

# A função _process roda o tempo todo enquanto o jogo está aberto
@warning_ignore("unused_parameter")
func _process(delta):
	
	# Verifica se a ação de aceitar (que por padrão é a tecla Enter ou Espaço) foi pressionada
	if Input.is_action_just_released("inventario"):
		print("Apertou o botao do inventario")
		if $".".visible == true:
			$".".visible = false
			print("Inventario FECHADO!")
			
		else:
			$".".visible = true
			print("Inventario ABERTO na tela!")
			
	$Pocao/Nomepocao.text=str(Global.pocao)
	$Flecha/QuantFlecha.text=str(Global.flecha)
	

	
	
	
