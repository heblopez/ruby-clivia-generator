require "json"
require "httparty"
require_relative "presenter"
require_relative "requester"
require "htmlentities"

class CliviaGenerator
  include Presenter
  include Requester

  def initialize
    # we need to initialize a couple of properties here
    @questions = []
    @score = 0
  end

  def start
    puts print_welcome
    select_main_menu_action
  end

  def random_trivia
    @questions = load_questions
    ask_questions
  end

  def ask_questions
    @questions.each do |question|
      ask_question(question)
    end
    print_score(@score)
    will_save?(@score)
  end

  def save(data)
    # write to file the scores data
    file = File.open("scores.json", "a") do |file|
      file.write(data.to_json)
    end
    # File.write("scores.json", data.to_json)
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10&difficulty=easy&type=multiple")
    object = JSON.parse(response.body, symbolize_names: true)
    results = object[:results]
    results.each do |hash|
      hash[:question] = HTMLEntities.new.decode(hash[:question])
      hash[:correct_answer] = HTMLEntities.new.decode(hash[:correct_answer])
      incorrect_answers_array = hash[:incorrect_answers]
      incorrect_answers_array.map! { |string| string = HTMLEntities.new.decode(string) }
    end
    results
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
end

trivia = CliviaGenerator.new
trivia.start
