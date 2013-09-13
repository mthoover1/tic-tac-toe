require 'board'
require 'spec_helper'

describe Board do
  let(:board) { Board.new(3) }

  def make_moves(board, moves)
    SpecHelper.make_moves(board, moves)
  end

  it "should have the appropriate number of tiles" do
    board.tiles.length.should == 9
    Board.new(4).tiles.length.should == 16
  end

  it "should set the win-length based on board size" do
    board.win_length.should == 3
    board = Board.new(4)
    board.win_length.should == 4
    board = Board.new(5)
    board.win_length.should == 4
  end

  it "should format the board for printing to screen" do
    board.to_s.should == "- - -\n- - -\n- - -\n\n"
    Board.new(4).to_s.should == "- - - -\n- - - -\n- - - -\n- - - -\n\n"
  end

  it "should know if a tile is open" do
    make_moves(board, ["---",
                       "X-O",
                       "---"])
    board.tile_open?(5).should == true
    board.tile_open?(4).should == false
  end

  it "should update a tile for a move" do
    board.update(1, "X")
    board.tiles.should == "X--------"
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
    make_moves(board, ["XOX",
                       "OXO",
                       "OXO"])
    board.full?.should == true
  end

  it "should know when there is a winner" do
    make_moves(board, ["OXO",
                       "-X-",
                       "-X-"])
    board.won?.should == true
    board = Board.new(3)
    make_moves(board, ["OX-",
                       "-X-",
                       "OX-"])
    board.won?.should == true

  end

  it "should know when there is not a winner" do
    make_moves(board, ["-X-",
                       "---",
                       "OXO"])
    board.won?.should == false
  end

  it "should know when the game is a tie" do
    make_moves(board, ["XOX",
                       "OXO",
                       "OXO"])
    board.tied?.should == true
    board = Board.new(3)
    make_moves(board, ["OXO",
                       "XOX",
                       "XOX"])
    board.tied?.should == true
  end

  it "should know when a game is not a tie" do
    make_moves(board, ["XOO",
                       "XOX",
                       "XXO"])
    board.tied?.should == false
  end

  it "should build the board depending on size" do
    board.build_board(3).should == "---------"
    board.build_board(4).should == "----------------"
  end


  context "Generating winning possibilities" do
    it "should generate the winning possibilities" do
      board.generate_winning_possibilities(3).should == [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
      board = Board.new(4)
      board.generate_winning_possibilities(4).should == [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15],[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15],[0,5,10,15],[3,6,9,12]]
    end

    it "should generate horizontal winning possibilities" do
      board.generate_horizontals(3).should == [[0,1,2],[3,4,5],[6,7,8]]
      board.generate_horizontals(4).should == [[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]]
      board.generate_horizontals(6).should == [[0,1,2,3],[1,2,3,4],[2,3,4,5],[6,7,8,9],[7,8,9,10],[8,9,10,11],[12,13,14,15],[13,14,15,16],[14,15,16,17],[18,19,20,21],[19,20,21,22],[20,21,22,23],[24,25,26,27],[25,26,27,28],[26,27,28,29],[30,31,32,33],[31,32,33,34],[32,33,34,35]]
    end

    it "should generate vertical winning possibilities" do
      board.generate_verticals(3).should == [[0,3,6],[1,4,7],[2,5,8]]
      board.generate_verticals(4).should == [[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15]]
      board.generate_verticals(5).should == [[0,5,10,15],[5,10,15,20],[1,6,11,16],[6,11,16,21],[2,7,12,17],[7,12,17,22],[3,8,13,18],[8,13,18,23],[4,9,14,19],[9,14,19,24]]
    end

    it "should generate diagonal winning possibilities" do
      tests = [ [3, [[0,4,8],[2,4,6]]],
                [4, [[0,5,10,15],[3,6,9,12]]],
                [6, [[0,7,14,21],[1,8,15,22],[2,9,16,23],[3,8,13,18],[4,9,14,19],[5,10,15,20],[6,13,20,27],[7,14,21,28],[8,15,22,29],[9,14,19,24],[10,15,20,25],[11,16,21,26],[12,19,26,33],[13,20,27,34],[14,21,28,35],[15,20,25,30],[16,21,26,31],[17,22,27,32]]]
              ]
      tests.each do |test|
        board = Board.new(test[0])
        board.generate_diagonals(test[0]).should == (test[1])#, "Size of #{test[0]} should output #{test[1]}"
      end
    end
  end


  it "should generate the tile locations of its corners" do
    board.generate_corner_tile_numbers(4).should == [1,4,13,16]
    board.generate_corner_tile_numbers(7).should == [1,7,43,49]
  end

  it "should know when a cat's game is inevitable" do
    make_moves(board, ["---",
                       "X-O",
                       "---"])
    board.future_cats_game?.should == false
    board = Board.new(4)
    make_moves(board, ["XXXO",
                       "-OX-",
                       "XOOX",
                       "OOXO"])
    board.future_cats_game?.should == true
  end
end
