require 'computer_player'
require 'board'

describe ComputerPlayer do
	let(:board) { Board.new(3) }
	let(:computer) { ComputerPlayer.new(board) }

	it "should make a random move" do
		board.stub(tiles: "XOX------")
		(4..9).to_a.should include(computer.random_move)
	end

	it "should win if possible" do
		board.stub(tiles: "XXOX--O--")
		computer.should_receive(:look_for_opening).with("O")
		computer.try_to_win
	end

	it "should block if possible" do
		board.stub(tiles: "-X--XO---")
		computer.should_receive(:look_for_opening).with("X")
		computer.try_to_block
	end

	it "should find an opening where 1 more play makes a winning combo" do
		board.stub(tiles: "X-XOO----")
		computer.look_for_opening("X").should == 2
		board.stub(tiles: "X-XOO----")
		computer.look_for_opening("O").should == 6
	end

	it "should cycle through different move types" do
		board.stub(tiles: "XXOX--O--", move_count: 5) #win
		computer.move.should == 5
		board.stub(tiles: "-X--XO---", move_count: 3) #block
		computer.move.should == 8
		board.stub(tiles: "X---O----", move_count: 2) #strategic
		computer.move.should == 9
		board.stub(tiles: "X---OX-XO", move_count: 5) #hopeful
		[3,7].should include(computer.move)
		board.stub(tiles: "---------", move_count: 0) #center
		computer.move.should == 5
	end

	it "should make strategic moves" do
		board.stub(tiles: "----X----", move_count: 1)
		computer.strategic_move.should == 1

		board.stub(tiles: "---X-----", move_count: 1)
		computer.strategic_move.should == 5

		board.stub(tiles: "O---X---X", move_count: 3)
		[3,7].should include(computer.strategic_move)

		board.stub(tiles: "X---O---X", move_count: 3)
		[2,4,6,8].should include(computer.strategic_move)

		board.stub(tiles: "--XXO----", move_count: 3)
		computer.strategic_move.should == 1

		board.stub(tiles: "--X-O--X-", move_count: 3)
		computer.strategic_move.should == 9

		board.stub(tiles: "-X--O----", move_count: 2)
		[7,9].should include(computer.strategic_move)

		board.stub(tiles: "--X-O----", move_count: 2)
		computer.strategic_move.should == 7

		board.stub(tiles: "X---OX--O", move_count: 4)
		computer.strategic_move.should == 7

		board.stub(tiles: "--X-O-OX-", move_count: 4)
		computer.strategic_move.should == 1
	end

	it "should make a hopeful move that moves towards a win" do
		board.stub(tiles: "--XXO-OX-")
		[1,9].should include(computer.hopeful_move)
		board = Board.new(4)
		computer = ComputerPlayer.new(board)
		board.stub(tiles: "-XX----X-O-OXO--")
		[9,11].should include(computer.hopeful_move)
	end

	it "should make the hopeful move with the most promise (most O's)" do
		board = Board.new(4)
		computer = ComputerPlayer.new(board)
		board.stub(tiles: "X---X----O--O---")
		[4,7].should include(computer.hopeful_move)
	end

	it "should take the center if it is open" do
		board.stub(tiles: "---------")
		computer.center_move.should == 5
		board = Board.new(7)
		computer = ComputerPlayer.new(board)
		computer.center_move.should == 25
	end

	it "should take a corner on the first move on a board bigger than 3x3" do
		board = Board.new(4)
		computer = ComputerPlayer.new(board)
		board.stub(tiles:"----------------", move_count: 0)
		[1,4,13,16].should include(computer.strategic_move)
		board.stub(tiles:"---X------------", move_count: 1)
		[1,13,16].should include(computer.strategic_move)
	end
end
