require './game_controller'
require	'./interface'
require './board'
require './computer_player'

describe GameController do
	let(:board) { Board.new }
	let(:interface) { Interface.new }
	let(:computer) { ComputerPlayer.new(board) }
	let(:game) { GameController.new(board, interface, computer) }

	before(:each) do
		game.stub(:puts)
	end

	it "should randomly choose who gets the first move" do
		["H","C"].should include(game.coin_toss)
	end

	it "should execute a coin toss to determine 'next move' upon game creation" do
		["H","C"].should include(game.next_move)
	end

	it "should show the board" do
		board.stub(tied?: true)
		game.should_receive(:show_board)
		game.play
	end

	it "should execute a computer move when computer has 'next move'" do
		game.next_move = "C"
		game.should_receive(:computer_move)
		game.move
	end

	it "should execute a human move when human has 'next move'" do
		game.next_move = "H"
		game.should_receive(:human_move)
		game.move
	end

	it "should update the 'next move' after a human move" do
		game.next_move = "C"
		game.update_next_move
		game.next_move.should == "H"
	end

	it "should update the 'next move' after a computer move" do
		game.next_move = "H"
		game.update_next_move
		game.next_move.should == "C"
	end

	it "should not make a move if game is won" do
		board.stub(won?: true)
		board.stub(tied?: false)
		game.should_not_receive(:move)
		game.play
	end

	it "should not make a move if game is tied" do
		board.stub(won?: false)
		board.stub(tied?: true)
		game.should_not_receive(:move)
		game.play
	end

	it "should display results when game is won" do
		board.stub(won?: true)
		board.stub(tied?: false)
		interface.should_receive(:display_results)
		game.play
	end

	it "should display results when game is tied" do
		board.stub(won?: false)
		board.stub(tied?: true)
		interface.should_receive(:display_results)
		game.play
	end

	it "should clear screen before showing board" do
		interface.should_receive(:clear_screen)
		game.show_board
	end

	it "should print instructions with board" do
		interface.should_receive(:instructions)
		game.show_board
	end
end
