require './lib/interface'
require './lib/board'
require './lib/computer_player'
require './lib/game_controller'

interface = Interface.new
game = GameController.new(interface)

game.play
