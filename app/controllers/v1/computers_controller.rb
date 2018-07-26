class V1::ComputersController < ApplicationController

  def create
    computer = Computer.new
    computer.save
    render json: computer.as_json
  end

end
