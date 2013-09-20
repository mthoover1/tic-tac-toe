require 'game_controller'

describe GameController do
	let(:board) { Board.new(3) }
	let(:interface) { Interface.new }
	let(:computer) { ComputerPlayer.new(board) }
	let(:game) { GameController.new(interface, board) }

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
		game.coin_toss
		[HumanPlayer,ComputerPlayer].should include(game.player1.class)
	end

	it "should show the board" do
		board.stub(tied?: true)
		game.should_receive(:show_board)
		game.play
	end

	it "should update the 'next player' after a human move" do
		game.instance_variable_set(:@next_player, game.player1)
		game.update_next_player
		game.instance_variable_get(:@next_player).should == game.player2
	end

	it "should update the 'next player' after a computer move" do
		game.instance_variable_set(:@next_player, game.player2)
		game.update_next_player
		game.instance_variable_get(:@next_player).should == game.player1
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
