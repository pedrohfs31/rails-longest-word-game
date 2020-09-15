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
    @word = params[:word].upcase
    @sample = params[:sample].split('')
    @message = ''
    answers = [
      "Congratulations, #{@word} is a valid English Word",
      "Sorry but #{@word} does not seem to be a valid English word",
      "Sorry but #{@word} can't be built out of #{@sample.join(',')}"
    ]

    @response = { english: english_word?(@word), valid: included?(@word, @sample) }

    if included?(@word, @sample)
      @message = english_word?(@word) ? answers[0] : answers[1]
    else
      @message = answers[2]
    end

    @tag = "<h1>hello!!!</h1>"
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
