class Interface
	def clear_screen
		"\e[H\e[2J\n"
	end

	def instructions
		"123\n456 <-- Tile Numbers\n789\n\n"
	end

	def prompt_human
		"Enter your next move:"
	end

	def get_input
		input = gets.chomp
		input.to_i
	end

	def input_valid?(input)
		input >= 1 && input <= 9
	end

	def display_results(board)
		return "Cat's Game" if board.tied?
		if board.won?
			return "Human Wins!!" if board.last_player == "X"
			return "Computer Wins" if board.last_player == "O"
		end
	end
end
