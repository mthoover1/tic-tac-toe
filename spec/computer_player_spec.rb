require 'computer_player'
require 'board'
require 'spec_helper'

describe ComputerPlayer do
  let(:board) { Board.new(3) }
  let(:computer) { ComputerPlayer.new(board) }

  before do
    Kernel.stub(:sleep)
  end

  def make_moves(board, moves)
    SpecHelper.make_moves(board, moves)
  end

  it "should make a random move" do
    make_moves(board, ["XOX",
                       "---",
                       "---"])
    (4..9).to_a.should include(computer.random_move)
  end

  it "should win if possible" do
    make_moves(board, ["XXO",
                       "X--",
                       "O--"])
    computer.should_receive(:look_for_opening).with("O")
    computer.try_to_win
  end

  it "should block if possible" do
    make_moves(board, ["-X-",
                       "-XO",
                       "---"])
    computer.should_receive(:look_for_opening).with("X")
    computer.try_to_block
  end

  it "should find an opening where 1 more play makes a winning combo" do
    make_moves(board, ["X-X",
                       "OO-",
                       "---"])
    computer.look_for_opening("X").should == 2
    board = Board.new(3)
    make_moves(board, ["X-X",
                       "OO-",
                       "---"])
    computer.look_for_opening("O").should == 6
  end

  xit "should cycle through different move types" do
    make_moves(board, ["XXO",
                       "X--",
                       "O--"]) #win
    computer.get_move.should eq(5)
    board = Board.new(3)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["-X-",
                       "-XO",
                       "---"]) #block
    computer.get_move.should eq(8)
    board = Board.new(3)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["X--",
                       "-O-",
                       "---"]) #strategic
    computer.get_move.should eq(9)
    board = Board.new(3)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["X--",
                       "-OX",
                       "-XO"]) #hopeful
    [3,7].should include(computer.get_move)
    board = Board.new(3)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["---",
                       "---",
                       "---"]) #center
    computer.get_move.should eq(5)
    big_board = Board.new(4)                      #future block on 4x4
    big_computer = ComputerPlayer.new(big_board)
    make_moves(big_board, ["--XX",
                           "----",
                           "X---",
                           "XOOO"])
    big_computer.get_move.should eq(1)
  end



  context "Strategic Moves:" do
    it "should make strategic move for 3x3, human first, 1 move, center open" do
      board.stub(tiles: "-X-------", move_count: 1)
      computer.get_move.should == 5
    end

    it "should make strategic moves for 3x3, human first, 3 moves" do
      tests = [ [["O--",
                  "-X-",
                  "--X"], [3,7]],
                [["X--",
                  "-O-",
                  "--X"], [2,4,6,8]],
                [["--X",
                  "-O-",
                  "X--"], [2,4,6,8]],
                [["--X",
                  "XO-",
                  "---"], [1]],
                [["---",
                  "XO-",
                  "--X"], [7]],
                [["-X-",
                  "-O-",
                  "X--"], [1]],
                [["-X-",
                  "-O-",
                  "--X"], [3]],
                [["X--",
                  "-OX",
                  "---"], [3]],
                [["---",
                  "-OX",
                  "X--"], [9]],
                [["X--",
                  "-O-",
                  "-X-"], [7]],
                [["--X",
                  "-O-",
                  "-X-"], [9]]  ]
      tests.each_with_index do |test, i|
        board = Board.new(3)
        computer = ComputerPlayer.new(board)
        make_moves(board, test[0])
        test[1].should include(computer.get_move), "Test ##{i+1}: #{test[0]} should = #{test[1]}"
      end
    end

    it "should make strategic moves for 3x3, computer first, 2 moves" do
      tests = [
                [["-X-",
                  "-O-",
                  "---"], [1,3,4,6,7,9]],
                [["---",
                  "XO-",
                  "---"], [1,2,3,7,8,9]],
                [["---",
                  "-OX",
                  "---"], [1,2,3,7,8,9]],
                [["---",
                  "-O-",
                  "-X-"], [1,3,4,6,7,9]],
                # [["X--",
                #   "-O-",
                #   "---"], [9]],
                # [["--X",
                #   "-O-",
                #   "---"], [7]],
                # [["---",
                #   "-O-",
                #   "X--"], [3]],
                # [["---",
                #   "-O-",
                #   "--X"], [1]]
              ]
      tests.each do |test|
        board = Board.new(3)
        computer = ComputerPlayer.new(board)
        make_moves(board, test[0])
        test[1].should include(computer.get_move)
      end
    end

    it "should make strategic moves for 3x3, computer first, 4 moves" do
      tests = [ [["X--",
                  "-OX",
                  "--O"], 7],
                [["X--",
                  "-O-",
                  "-XO"], 3],
                [["--X",
                  "XO-",
                  "O--"], 9],
                [["--X",
                  "-O-",
                  "OX-"], 1],
                [["--O",
                  "-OX",
                  "X--"], 1],
                [["-XO",
                  "-O-",
                  "X--"], 9],
                [["OX-",
                  "-O-",
                  "--X"], 7],
                [["O--",
                  "XO-",
                  "--X"], 3]  ]
      tests.each do |test|
        board = Board.new(3)
        computer = ComputerPlayer.new(board)
        make_moves(board, test[0])
        computer.get_move.should == test[1]
      end
    end

    it "should make strategic move for 4x4, first computer move, even sized board" do
      board = Board.new(4)
      computer = ComputerPlayer.new(board)
      board.corner_tile_numbers.should include(computer.get_move)
      make_moves(board, ["X---",
                         "----",
                         "----",
                         "----"])
      [7,10].should include (computer.get_move)
      board.tiles[0].should == "X"

      board = Board.new(4)
      computer = ComputerPlayer.new(board)
      make_moves(board, ["----",
                         "----",
                         "----",
                         "X---"])
      [6,11].should include (computer.get_move)
      board.tiles[12].should == "X"
    end
  end



  it "should make a hopeful move that moves towards a win" do
    make_moves(board, ["--X",
                       "XO-",
                       "OX-"])
    [1,9].should include(computer.hopeful_move)
    board = Board.new(4)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["-XX-",
                       "---X",
                       "-O-O",
                       "XO--"])
    [9,11].should include(computer.hopeful_move)
  end

  it "should make the hopeful move with the most promise (most O's)" do
    board = Board.new(4)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["X---",
                       "X---",
                       "-O--",
                       "O---"])
    [4,7].should include(computer.hopeful_move)
  end

  it "should make a move touching another computer-controlled tile when it makes hopeful move" do
    board = Board.new(4)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["X---",
                       "X---",
                       "--O-",
                       "--O-"])
    computer.hopeful_move.should == 7
  end

  it "should take the center if it is open" do
    make_moves(board, ["---",
                       "---",
                       "---"])
    computer.center_move.should == 5
    # board = Board.new(7)
    # computer = ComputerPlayer.new(board)
    # computer.center_move.should == 25
  end

  it "should take a corner on the first move on a board bigger than 3x3" do
    board = Board.new(4)
    computer = ComputerPlayer.new(board)
    [1,4,13,16].should include(computer.get_move)
    make_moves(board, ["---X",
                       "----",
                       "----",
                       "----"])
    [1,13,16].should include(computer.get_move)
  end

  it "should prevent a move that sets up a human win scenario" do
    board = Board.new(4)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["XX--",
                       "-O--",
                       "-O-X",
                       "-O-X"])
    computer.try_to_block_move_that_leads_to_loss.should == 4
  end

  it "should make a move that sets up two winning scenarios" do
    board = Board.new(4)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["XX-O",
                       "---O",
                       "XX--",
                       "OO--"])
    computer.try_to_setup_win_on_next_move.should == 16
  end

  # it "should make a move that allows another move that sets up two winning scenarios" do
  #   board = Board.new(6)
  #   computer = ComputerPlayer.new(board)
  #   board.stub(tiles: "--------------O-----XO------X-------", move_count: 4)
  #   computer.try_to_future_future_win.should == 16
  # end

  it "should build a possibility when given a winning-combo and tiles" do
    make_moves(board, ["X--",
                       "---",
                       "---"])
    computer.build_possibility([0,1,2], board.tiles).should == ["X","-","-"]
  end

  it "should know when a possibility is one move away from completion" do
    computer.one_move_away?(["X","X","-"],"X").should == true
    computer.one_move_away?(["X","X","-"],"O").should == false
  end

  it "should never lose in a computer vs computer battle on 3x3" do
    pending "deal with interface connection"
    100.times do
      board = Board.new(3)
      interface = Interface.new
      game = GameController.new(interface, board, ComputerPlayer.new(board, "X"), ComputerPlayer.new(board))
      game.stub(:puts)
      game.stub(:coin_toss)
      game.play
      interface.display_results(board, "X", "O").should start_with("Cat")
    end
  end

  it "should never lose in a computer vs computer battle on 4x4" do
    pending "deal with interface connection"
    100.times do
      board = Board.new(4)
      interface = Interface.new
      game = GameController.new(interface, board, ComputerPlayer.new(board, "X"), ComputerPlayer.new(board))
      game.stub(:puts)
      game.stub(:coin_toss)
      game.play
      interface.display_results(board, "X", "O").should start_with("Cat")
    end
  end

  it "should know when a move is safe (doesn't open up a guaranteed path to victory for opponent)" do
    make_moves(board, ["X--",
                       "-O-",
                       "--X"])
    computer.is_move_safe?(7).should eq(false)
    computer.is_move_safe?(8).should eq(true)
    board = Board.new(3)
    computer = ComputerPlayer.new(board)
    make_moves(board, ["XX-",
                       "-O-",
                       "---"])
    computer.is_move_safe?(9).should eq(false)
    computer.is_move_safe?(3).should eq(true)
  end
end
