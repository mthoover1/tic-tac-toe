require './board'

describe Board do
	let(:board) { Board.new }

	it "should have nine tiles" do
		board.tiles.length.should == 9
	end

	it "should format the board for printing to screen" do
		board.to_s.should == "- - -\n- - -\n- - -\n\n"
	end

	it "should know if a tile is open" do
		board.stub(tiles: "---X-O---")
		board.tile_open?(5).should == true
		board.tile_open?(4).should == false
	end

	it "should update a tile for a move" do
		board.update(1, "X")
		board.tiles.should == 'X--------'
	end

	it "should increment the move-count after a move" do
		board.update(1, "X")
		board.update(2, "O")
		board.move_count.should == 2
	end

	it "should update the last-player after a move" do
		board.update(1, "X")
		board.last_player.should == "X"
		board.update(2, "O")
		board.last_player.should == "O"
	end

	it "should know when board is full" do
		board.stub(tiles: "XOXOXOOXO")
		board.full?.should == true
	end

	it "should know when there is a winner" do
		board.stub(tiles: "OXO-X--X-")
		board.won?.should == true
	end

	it "should know when the game is a tie" do
		board.stub(tiles: "XOXOXOOXO")
		board.tied?.should == true
	end
end
