class V1::HumenController < ApplicationController

  def create
    human = Human.new
    human.save
    render json: human.as_json
  end

end
