require 'game_controller'
require	'interface'
require 'board'
require 'computer_player'

describe GameController do
	let(:board) { Board.new(3) }
	let(:interface) { Interface.new }
	let(:computer) { ComputerPlayer.new(board) }
	let(:game) { GameController.new(interface, board, computer) }

	before(:each) do
		interface.stub(gets: "3\n")
		game.stub(:puts)
	end

	it "should create a board of the right size" do
		new_game = GameController.new(interface)
		new_game.stub(:puts)
		new_game.create_board
		new_game.board.tiles.should == "---------"
	end

	it "should create a computer player with the already existing board" do
		new_game = GameController.new(interface, board)
		new_game.stub(:puts)
		new_game.create_computer_player
		new_game.computer.board == board
	end

	it "should randomly choose who gets the first move" do
		["X","O"].should include(game.coin_toss)
	end

	it "should execute a coin toss to determine 'next move' upon game creation" do
		["X","O"].should include(game.next_player)
	end

	it "should show the board" do
		board.stub(tied?: true)
		game.should_receive(:show_board)
		game.play
	end

	it "should execute a computer move when computer has 'next move'" do
		game.instance_variable_set(:@next_player, "O")
		game.should_receive(:computer_move)
		game.move
	end

	it "should execute a human move when human has 'next move'" do
		game.instance_variable_set(:@next_player, "X")
		game.should_receive(:human_move)
		game.move
	end

	it "should update the 'next player' after a human move" do
		game.instance_variable_set(:@next_player, "X")
		game.update_next_player
		game.instance_variable_get(:@next_player).should == "O"
	end

	it "should update the 'next player' after a computer move" do
		game.instance_variable_set(:@next_player, "O")
		game.update_next_player
		game.instance_variable_get(:@next_player).should == "X"
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

	it "should print tile-number-diagram with board" do
		interface.should_receive(:tile_number_diagram)
		game.show_board
	end

	# it "should get user's pick of board size" do
	# 	pending "board needs the size upon creation as of now" # game.get_board_size.
	# end
end
