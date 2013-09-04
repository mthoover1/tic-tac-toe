class Interface
	def clear_screen
		"\e[H\e[2J\n"
	end

	def instructions(size)
		if size == 3
			"123\n456 <-- Tile Numbers\n789\n\n"
		elsif size == 4
			"1  2  3  4\n5  6  7  8 <-- Tile Numbers\n9  10 11 12\n13 14 15 16\n\n"
		end
	end

	def pick_board_size
		"Enter 3 for 3x3\nEnter 4 for 4x4\n"
	end

	def prompt_human
		"Enter your next move:"
	end

	def get_input
		input = gets.chomp
		input.to_i
	end

	def input_valid?(input, size)
		input >= 1 && input <= (size**2)
	end

	def display_results(board)
		return "Cat's Game" if board.tied?
		if board.won?
			return "Human Wins!!" if board.last_player == "X"
			return "Computer Wins" if board.last_player == "O"
		end
	end
end
