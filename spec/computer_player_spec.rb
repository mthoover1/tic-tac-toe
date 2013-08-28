require './computer_player'
require './board'

describe ComputerPlayer do
	let(:board) { Board.new }
	let(:computer) { ComputerPlayer.new(board) }

	it "should make a random move" do
		board.stub(tiles: "XOX------")
		(4..9).to_a.should include(computer.random_move)
	end

	it "should win if possible" do
		board.stub(tiles: "XXOX--O--")
		computer.try_to_win.should == 5
	end

	it "should block if possible" do
		board.stub(tiles: "-X--XO---")
		computer.try_to_block.should == 8
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

		board.stub(tiles: "-X--O----", move_count: 2)
		[7,9].should include(computer.strategic_move)

		board.stub(tiles: "--X-O----", move_count: 2)
		computer.strategic_move.should == 7

		board.stub(tiles: "X---OX--O", move_count: 4)
		computer.strategic_move.should == 7

		board.stub(tiles: "--X-O-OX-", move_count: 4)
		computer.strategic_move.should == 1
	end

	it "should make a hopeful move that requires a block" do
		board.stub(tiles: "--XXO-OX-")
		[1,9].should include(computer.hopeful_move)
	end

	it "should take the center if it is open" do
		board.stub(tiles: "---------")
		computer.center_move.should == 5
	end
end
