require './game_controller'

describe GameController do
	let(:board) { Board.new }
	let(:interface) { Interface.new }
	let(:computer) { ComputerPlayer.new(board) }
	let(:game) { GameController.new(board, interface, computer) }


end
