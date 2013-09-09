require 'interface'

describe Interface do
  let(:interface) { Interface.new }

  it "should clear the screen" do
    interface.clear_screen.should == "\e[H\e[2J\n"
  end

  it "should print instructions to the screen" do
    interface.instructions(3).should == "1  2  3\n4  5  6\n7  8  9\n\n"
  end

  it "should print instructions for a board of any (reasonable) size" do
    interface.instructions(5).should == "1  2  3  4  5\n6  7  8  9  10\n11 12 13 14 15\n16 17 18 19 20\n21 22 23 24 25\n\n"
  end

  it "should prompt human for next move" do
    interface.prompt_human.should == "Enter your next move:"
  end

  it "should get human input" do
    interface.stub(gets: "5\n")
    interface.get_input.should == 5
  end

  it "should not accept input outside of tile numbers" do
    interface.input_valid?(0,3).should == false
    interface.input_valid?(8,3).should == true
    interface.input_valid?(10,3).should == false
    interface.input_valid?(16,4).should == true
  end

  it "should display results of a tie" do
    board = double("board", tied?: true)
    interface.display_results(board).should == "Cat's Game"
  end

  it "should display results of an inevitiable cat's game" do
    board = double("board", tied?: false, won?: false, future_cats_game?: true)
    interface.display_results(board).should == "Cat's Game (Saving You Time)"
  end

  it "should display results of a human win" do
    board = double("board", won?: true, tied?: false, future_cats_game?: false, last_player: "X")
    interface.display_results(board).should == "Human Wins!!"
  end

  it "should display results of a computer win" do
    board = double("board", won?: true, tied?: false, future_cats_game?: false, last_player: "O")
    interface.display_results(board).should == "Computer Wins"
  end

  it "should prompt user for game board size choice" do
    interface.pick_board_size.should == "Enter board width:\n"
  end
end
