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
		big_board = Board.new(4)											#future block on 4x4
		big_computer = ComputerPlayer.new(big_board)
		big_board.stub(tiles: "--XX----X---XOOO", move_count: 7)
		big_computer.move.should == 1
	end



	context "Strategic Moves:" do
		it "should make strategic move for 3x3, human first, 1 move, center open" do
			board.stub(tiles: "-X-------", move_count: 1)
			computer.strategic_move.should == 5
		end

		it "should make strategic moves for 3x3, human first, 3 moves" do
			tests = [ ["O---X---X", [3,7]],
							  ["X---O---X", [2,4,6,8]],
							  ["--X-O-X--", [2,4,6,8]],
							  ["--XXO----", [1]],
							  ["---XO---X", [7]],
							  ["-X--O-X--", [1]],
							  ["-X--O---X", [3]],
							  ["X---OX---", [3]],
							  ["----OXX--", [9]],
							  ["X---O--X-", [7]],
							  ["--X-O--X-", [9]] 	]
			tests.each_with_index do |test, i|
				board.stub(tiles: test[0], move_count: 3)
				test[1].should include(computer.strategic_move), "Test ##{i+1}: #{test[0]} should = #{test[1]}"
			end
		end

		it "should make strategic moves for 3x3, computer first, 2 moves" do
			tests = [ ["-X--O----", [7,9]],
							  ["---XO----", [3,9]],
							  ["----OX---", [1,7]],
							  ["----O--X-", [1,3]],
							  ["X---O----", [9]],
							  ["--X-O----", [7]],
							  ["----O-X--", [3]],
							  ["----O---X", [1]]  ]
			tests.each do |test|
				board.stub(tiles: test[0], move_count: 2)
				test[1].should include(computer.strategic_move)
			end
		end

		it "should make strategic moves for 3x3, computer first, 4 moves" do
			tests = [ ["X---OX--O", 7],
								["X---O--XO", 3],
								["--XXO-O--", 9],
								["--X-O-OX-", 1],
								["--O-OXX--", 1],
								["-XO-O-X--", 9],
								["OX--O---X", 7],
								["O--XO---X", 3]  ]
			tests.each do |test|
				board.stub(tiles: test[0], move_count: 4)
				computer.strategic_move.should == test[1]
			end
		end

		it "should make strategic move for 4x4, first computer move, even sized board" do
			board = Board.new(4)
			computer = ComputerPlayer.new(board)
			board.stub(move_count: 0)
			board.corner_tile_numbers.should include(computer.strategic_move)
			board.stub(tiles: "X---------------", move_count: 1)
			board.corner_tile_numbers.should include(computer.strategic_move)
			board.tiles[0].should == "X"
		end

		it "should make a strategic_move for big boards, first computer move, even sized board" do
			board = Board.new(6)
			computer = ComputerPlayer.new(board)
			board.stub(tiles: "--------------------X---------------", move_count: 1)
			[15,16,22].should include(computer.strategic_move)
		end
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

	it "should prevent a move that sets up a human win scenario" do
		board = Board.new(4)
		computer = ComputerPlayer.new(board)
		board.stub(tiles: "XX---O---O-X-O-X", move_count: 7)
		computer.try_to_future_block.should == 4
	end

	it "should make a move that sets up two winning scenarios" do
		board = Board.new(4)
		computer = ComputerPlayer.new(board)
		board.stub(tiles: "XX-O---OXX--OO--", move_count: 8)
		computer.try_to_future_win.should == 16
	end

	it "should build a possibility when given a winning-combo and tiles" do
		board.stub(tiles: "X--------")
		computer.build_possibility([0,1,2], board.tiles).should == ["X","-","-"]
	end

	it "should know when a possibility is one move away from completion" do
		computer.one_move_away?(["X","X","-"],"X").should == true
		computer.one_move_away?(["X","X","-"],"O").should == false
	end
end
