class V1::HumenController < ApplicationController

  def create
    human = Human.create
    render json: human.as_json
  end

end
