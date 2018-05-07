class RecommendController < ApplicationController
  include HTTParty

  def index
    responses = []

    yelp_URL = 'https://api.yelp.com/v3/businesses/search?'
    request_params = {
      headers: {
        Authorization: ENV['YELP_API_KEY']
      }
    }

    categories = params[:term].split(' ')
    categories.each do |category|
      if category != 'Food'
        params[:term] = category
        query_string = stringify_query(params)
        request_URL = yelp_URL + query_string
        responses.push(HTTParty.get(request_URL, request_params))
      end
    end

    recommendations = responses.map do |response|
      response.parsed_response["businesses"][0]
    end

    render json: recommendations.shuffle[0, 3]
  end

  def stringify_query(query_object)
    key_value_pairs = []
    query_object.each do |k, v|
      if k.to_s != 'controller' && k.to_s != 'action'
        key_value_pairs.push("#{k.to_s}=#{v.to_s}")
      end
    end
    key_value_pairs.join('&')
  end
end
