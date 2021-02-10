require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def letters_in_grid?(attempt, grid)
    attempt_grid = attempt.upcase.split("")
    attempt_hash = attempt_grid.group_by { |e| e }
    attempt_hash.merge!(attempt_hash) { |_k, v| v.size }
    grid_hash = grid.group_by { |e| e }
    grid_hash.merge!(grid_hash) { |_k, v| v.size }
    attempt_hash.all? { |k, v| grid_hash.include?(k) && v <= grid_hash[k] }
  end

  def new
    @letters = generate_grid(9)
  end

  def score

    @message = ""
    # @word = params[:word].chars
    if letters_in_grid?(params[:word], params[:letters].split(" "))
      @message = "Not included"
      if (valid_word(params[:word]))
        @message = "valid word"
      else
        @message = "invalid word"
      end
    else
      @message = "Not in grid"
    end
  end

  def valid_word(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
