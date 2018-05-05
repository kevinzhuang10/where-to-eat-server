class RecommendController < ApplicationController
  include HTTParty

  def index
    puts "hello >>>>>>>>>>>>>>>"
    response = HTTParty.get('http://api.stackexchange.com/2.2/questions?site=stackoverflow')
    render json: response
  end
end
