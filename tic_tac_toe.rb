require './interface'
require './board'
require './computer_player'
require './game_controller'

interface = Interface.new
board = Board.new
computer = ComputerPlayer.new(board)
game = GameController.new(board, interface, computer)

game.play
