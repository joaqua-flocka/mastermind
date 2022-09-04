require 'pry-byebug'

def randomize(array)
  4.times do
    array.push(rand(6) + 1)
  end
end

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def colorize(num)
    if num == 1
      return red()
    elsif num == 2
      return blue()
    elsif num == 3
      return green()
    elsif num == 4
      return brown()
    elsif num == 5
      return cyan()
    else
      return magenta()
    end
  end
end

class Guesser
  attr_reader :gameover
  def initialize(guesses, guess_length)
    @guesses = guesses
    @guess_length = guess_length
    @current_guess = []
    @correct_guess = Array.new(guess_length)
    @gameover = false
    @num_correct = 0
    @num_almost_correct = 0
  end

  def set_guess
    begin
    puts "\nGuess the Mastermind's code!\n" << "Red:".red << " [1] | " <<
    "Blue:".blue << " [2] | " << "Green:".green << " [3] | " <<
    "Brown:".brown << " [4] | " << "Cyan:".cyan << " [5] | " <<
    "Magenta:".magenta << " [6]\n" <<
    "(ex: '1234' = [#{"Red".red} #{"Blue".blue} #{"Green".green} #{"Brown".brown}])\n"
    @current_guess = gets.chomp.split('').map! { |i| i = i.to_i }
    raise StandardError unless @current_guess.length == @guess_length && @current_guess.all? { |i| i.between?(1, 6)}
    rescue StandardError
      puts "\nInvalid guess! Please guess FOUR numbers between 1 and 6.\n"
      retry
    end
  end

  def victory
    puts "\nWoohoo! Guesser wins!"
    @gameover = true
  end

  def check_guess(code)
    if @current_guess == code
      @correct_guess = code
      @num_correct = 4
      victory
      return []
    else
      @correct_guess = code
      almost_right = []
      #binding.pry
      @current_guess.each_with_index do |item, idx|
        if code.include?(item) && code[idx] != item
          almost_right.push(item)
          @num_almost_correct += 1
        elsif item == code[idx]
          @num_correct += 1
        end
      end
      return almost_right
    end
  end

  def print_guess(almost_right)
    puts "\nYour guess: #{@current_guess}\n
    Correct color, correct placement: #{@num_correct}\n
    Correct color, incorrect placement: #{@num_almost_correct}\n\n"
    unless gameover == true
      @num_almost_correct = 0
      @num_correct = 0
    end
  end

  def defeat
    puts "Oh no! The Mastermind wins!"
    @gameover = true
  end

  def guess(code)
    set_guess
    almost_right = check_guess(code)
    print_guess(almost_right)
    @guesses -= 1
    defeat if @guesses == 0
  end
end

class Computer < Guesser
  def set_guess(code)
    if @current_guess.empty?
      randomize(@current_guess)
      #binding.pry
    else
      last_guess = @current_guess
      #almost_right = check_guess(code)
      last_guess.each_with_index do |guess, idx|
        if guess == @correct_guess[idx]
          @current_guess[idx] = guess
        else
          @current_guess[idx] = rand(6) + 1
        end
      end
      #binding.pry
    end
  end

  def guess(code)
    set_guess(code)
    almost_right = check_guess(code)
    @guesses -= 1
    defeat if @guesses == 0
    print_guess(almost_right.flatten)
  end
end

class Mastermind
  attr_reader :code
  def initialize(code = [])
    @code = code
    randomize(@code) if @code == []
  end
  #radomize(@code)
end

def run_game
  begin
  puts "Welcome to Mastermind! Would you like to be the guesser or the code-setter?\n
    [1] - Guesser\n
    [2] - Code-Setter\n\n"
  choice = gets.chomp.to_i
  raise StandardError unless choice.between?(1, 2)
  rescue
    puts "Invalid choice! Please try again.\n"
    retry
  end
  if choice == 1
    comp = Mastermind.new
    player = Guesser.new(12, 4)
    until player.gameover
      #p comp.code
      player.guess(comp.code)
    end
  else
    begin
    puts "Set your code!\n" << "Red:".red << " [1] | " <<
    "Blue:".blue << " [2] | " << "Green:".green << " [3] | " <<
    "Brown:".brown << " [4] | " << "Cyan:".cyan << " [5] | " <<
    "Magenta:".magenta << " [6]\n" <<
    "(ex: '1234' = [#{"Red".red} #{"Blue".blue} #{"Green".green} #{"Brown".brown}])\n\n"
    code = gets.chomp.split('').map! { |item| item = item.to_i}
    raise StandardError unless code.length == 4 && code.all? { |i| i.between?(1, 6)}
    rescue
      puts "\nInvalid code! Please input FOUR numbers between 1 and 6.\n"
      retry
    end
    player = Mastermind.new(code)
    comp = Computer.new(12, 4)
    until comp.gameover
      p player.code
      comp.guess(player.code)
    end
  end
end



run_game
