require './game_controller'
require	'./interface'
require './board'
require './computer_player'

describe GameController do
	let(:board) { Board.new }
	let(:interface) { Interface.new }
	let(:computer) { ComputerPlayer.new(board) }
	let(:game) { GameController.new(board, interface, computer) }

	it "should randomly choose who gets the first move" do
		["H","C"].should include(game.coin_toss)
	end
end
