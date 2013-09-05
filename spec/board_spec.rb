require 'board'

describe Board do
	let(:board) { Board.new(3) }

	it "should have the appropriate number of tiles" do
		board.tiles.length.should == 9
		Board.new(4).tiles.length.should == 16
	end

	it "should format the board for printing to screen" do
		board.to_s.should == "- - -\n- - -\n- - -\n\n"
		Board.new(4).to_s.should == "- - - -\n- - - -\n- - - -\n- - - -\n\n"
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
		board.stub(tiles: "OX--X-OX-")
		board.won?.should == true

	end

	it "should know when there is not a winner" do
		board.stub(tiles: "-X----OXO")
		board.won?.should == false
	end

	it "should know when the game is a tie" do
		board.stub(tiles: "XOXOXOOXO")
		board.tied?.should == true
		board.stub(tiles: "OXOXOXXOX")
		board.tied?.should == true
	end

	it "should know when a game is not a tie" do
		board.stub(tiles: "XOOXOXXXO")
		board.tied?.should == false
	end

	it "should build the board depending on size" do
		board.build_board(3).should == "---------"
		board.build_board(4).should == "----------------"
	end

	it "should generate the winning possibilities" do
		board.generate_winning_possibilities(3).should == [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
		board.generate_winning_possibilities(4).should == [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15],[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15],[0,5,10,15],[3,6,9,12]]
	end

	it "should generate horizontal winning possibilities" do
		board.generate_horizontals(3).should == [[0,1,2],[3,4,5],[6,7,8]]
		board.generate_horizontals(4).should == [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]]
	end

	it "should generate vertical winning possibilities" do
		board.generate_verticals(2).should == [[0,2],[1,3]]
		board.generate_verticals(4).should == [[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15]]
	end

	it "should generate diagonal winning possibilities" do
		board.generate_diagonals(2).should == [[0,3],[1,2]]
		board.generate_diagonals(4).should == [[0,5,10,15],[3,6,9,12]]
	end

	it "should generate the tile locations of its corners" do
		board.generate_corner_tile_numbers(4).should == [1,4,13,16]
		board.generate_corner_tile_numbers(7).should == [1,7,43,49]
	end
end
