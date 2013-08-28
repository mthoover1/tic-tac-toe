require './interface'

describe Interface do
  let(:interface) { Interface.new }

  it "should clear the screen" do
    interface.clear_screen.should == "\e[H\e[2J\n"
  end

  it "should print instructions to the screen" do
    interface.instructions.should == "123\n456 <-- Tile Numbers\n789\n\n"
  end

  it "should prompt human for next move" do
    interface.prompt_human.should == "Enter your next move:"
  end

  it "should get human input" do
    interface.stub(gets: "5\n")
    interface.get_input.should == 5
  end

  it "should not accept input outside of 1-9" do
    interface.input_valid?(0).should == false
    interface.input_valid?(8).should == true
    interface.input_valid?(10).should == false
  end

  it "should display results of a tie" do
    board = double("board", tied?: true)
    interface.display_results(board).should == "Cat's Game"
  end

  it "should display results of a human win" do
    board = double("board", won?: true, tied?: false, last_player: "X")
    interface.display_results(board).should == "Human Wins!!"
  end

  it "should display results of a computer win" do
    board = double("board", won?: true, tied?: false, last_player: "O")
    interface.display_results(board).should == "Computer Wins"
  end
end
