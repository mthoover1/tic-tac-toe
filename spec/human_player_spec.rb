require 'human_player'
require 'spec_helper'

describe HumanPlayer do
  let(:board) { Board.new(3) }
  let(:interface) { Interface.new }
  let(:human) { HumanPlayer.new(board, "X", interface) }

  def make_moves(board, moves)
    SpecHelper.make_moves(board, moves)
  end

  it "should make a move where the human tells it to" do
    make_moves(board, ["---",
                       "---",
                       "---"])
    interface.stub(gets: "5\n")
    human.stub(:puts)
    board.should_receive(:update).with(5, "X")
    human.move
  end
end
