class TopologiesController < ApplicationController
  def index
    @topologies = Topology.all
    render json: @topologies
  end

  def show
    begin
      @topology = Topology.find(params[:id])
    rescue
      @topology = '{}'
    end
    render json: @topology
  end

  def current
    begin
      @topology = Topology.find_by!(is_current: true)
    rescue
      @topology = '{}'
    end
    render json: @topology
  end

end
