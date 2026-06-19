extends HSlider

# Diz para qual canal de áudio esse slider vai mandar a informação
@export var bus_name: String = "Master"
var bus_index: int

func _ready():
	# Descobre qual é o número do canal de áudio da Godot
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Conecta o movimento da barra à nossa função de alterar o volume
	value_changed.connect(_on_value_changed)
	
	# Ajusta a posição da barra para o volume atual do jogo quando o menu abrir
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(novo_valor: float):
	# Transforma o valor da barra em Decibéis (dB) e aplica no jogo
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(novo_valor))
	
	# TRAVA DE SEGURANÇA: Se o jogador arrastar tudo para o zero, muta o canal completamente
	if novo_valor == 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
