class V1::ComputersController < ApplicationController

  def create
    computer = Computer.create
    render json: computer.as_json
  end

end
