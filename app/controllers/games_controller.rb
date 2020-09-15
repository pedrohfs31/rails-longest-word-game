require 'pry-byebug'
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a
    @sample = []
    10.times do
      @sample.push(@letters.sample)
    end
  end

  def score
    # pry-byebug
    @word = params[:word].upcase
    # url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    @sample = params[:sample].split('')

    @english = english_word?(@word)
    @included = included?(@word, @sample)

    @message = ''
    if @included
     @message = @english ? 'well done' : 'not an english word'


    else
      @message = 'not in the grid'
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)

        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end
end
