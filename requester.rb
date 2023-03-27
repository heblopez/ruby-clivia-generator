module Requester
  def select_main_menu_action
    action = ""
    options = ["random", "score", "exit"]
    until action == "exit"
      action = gets_option(options)
      case action
      when "random" then random_trivia
      when "score" then puts "Score action"
      when "exit" then puts "Thanks for using Clivia Generator"
      end
    end
  end

  def ask_question(question)
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    puts "Question: #{question[:question]}"
    options = question[:incorrect_answers].push(question[:correct_answer])
    options_random = options.shuffle
    options_random.map.with_index { |option, i| puts "#{i + 1}. #{option}" }
    print "> "
    answer_index_user = gets.chomp.strip.to_i
    answer_user = options_random[answer_index_user - 1]
    if answer_user == question[:correct_answer]
      puts "#{answer_user}... Correct!"
      @score += 10
    else
      puts "#{answer_user}... Incorrect!"
      puts "The correct answer was #{question[:correct_answer]}"
    end
  end

  def will_save?(score)
    election = ""
    valid_inputs = ["y", "n"]
    until valid_inputs.include?(election)
      puts "Do you want to save your score? (y/n)"
      print "> "
      election = gets.chomp.strip.downcase
      puts "Invalid option" unless valid_inputs.include?(election)
    end
    if election == "y"
      name = input_save
      data_user = { name: name, score: score }
      save(data_user)
    else
      score = 0
    end
  end

  def input_save
    puts "Type the name to assign to the score"
    print "> "
    name_user = gets.chomp.capitalize
    name_user = "Anonymous" if name_user == ""
    name_user
  end

  def gets_option(options)
    prompt = ""
    until options.include?(prompt)
      puts options.join(" | ")
      print "> "
      prompt = gets.chomp.strip
      puts "Invalid option" unless options.include?(prompt)
    end
    prompt
  end
end
