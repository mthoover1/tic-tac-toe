class Interface
	NEW_LINE = "\n"
	CLEAR_SCREEN = "\e[H\e[2J"

	def clear_screen
		CLEAR_SCREEN
	end

	def tile_number_diagram(size)
		total = size ** 2
		output_string = ""

		total.times do |i|
			number = i + 1

			if number % size == 0
				output_string << tile_end_of_row(number)
			elsif number <= 9
				output_string << tile_single_digit(number)
			elsif number >= 10
				output_string << tile_double_digit(number)
			end
		end

		output_string + NEW_LINE
	end

	def tile_end_of_row(number)
		"#{number}" + NEW_LINE
	end

	def tile_single_digit(number)
		"#{number}  "
	end

	def tile_double_digit(number)
		"#{number} "
	end

	def pick_board_size
		"Enter board width:" + NEW_LINE
	end

	def prompt_human
		"Enter your next move:"
	end

	def get_input
		input = gets.chomp
		input.to_i
	end

	def display_results(board, human, computer)
		return "Cat's Game" if board.tied?
		if board.won?
			return "Human Wins!!" if board.last_player == human
			return "Computer Wins" if board.last_player == computer
		end
		return "Cat's Game (Saving You Time)" if board.future_cats_game?
	end
end
