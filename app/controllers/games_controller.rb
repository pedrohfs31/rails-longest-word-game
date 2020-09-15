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

    @response = { english: english_word?(@word), valid: included?(@word, @sample) }

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
