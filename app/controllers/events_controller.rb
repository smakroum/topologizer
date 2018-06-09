require 'rest-client'

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
        send_event_to_api
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :topology_id)
    end

    def send_event_to_api
      base_url = 'http://0.0.0.0:3001'

      response = RestClient.post "#{base_url}/topologies", { name: @event.topology.name }
      topology_api = JSON.parse(response)
      @event.topology.update api_id: topology_api["id"]

      @event.topology.nodes.each do |node|
        response = RestClient.post "#{base_url}/topologies/#{topology_api["id"]}/nodes", {
            name: node.name,
        }
        node_api = JSON.parse(response)
        node.update api_id: node_api["id"]
      end

      @event.topology.links.each do |link|
        response = RestClient.post "#{base_url}/topologies/#{topology_api["id"]}/links", {
            source_id: link.source_node.api_id,
            target_id: link.target_node.api_id
        }
        link_api = JSON.parse(response)
        link.update api_id: link_api["id"]
      end

      response = RestClient.post "#{base_url}/tasks", {
          name: @event.title,
          start: @event.start_time,
          end: @event.end_time,
          topology_id: topology_api["id"]
      }
      event_api = JSON.parse(response)
      @event.update api_id: event_api["id"]

      puts "schedule"
      RestClient.get "#{base_url}/tasks/#{event_api["id"]}/schedule"
    end

end
