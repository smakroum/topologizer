require "json"

class PagesController < ApplicationController

	def index
	end

	# TODO cut to small functions. Not Clean Code
	def parse_gml
		begin
			gml_data = params["gml"].read
			data = Hash.from_xml(gml_data)
			data_label = data["graphml"]["graph"]["data"][12]
			data_nodes = data["graphml"]["graph"]["node"]
			data_edges = data["graphml"]["graph"]["edge"]

			new_topology = Topology.create(name: data_label)
			nodes = new_topology.nodes.create(data_nodes.map {|node| {name: node['id']}})

			edges = []
			data_edges.each do |edge|
				source = nodes.find {|n| n.name == edge['source']}
				target = nodes.find {|n| n.name == edge['target']}
				edges << {source_node: source, target_node: target}
			end
			Link.create(edges)
		rescue
			redirect_to pages_index_path, :flash => { :error => "Parse Error" }
		end
	end

	def parse_json
		begin
			gml_data = params["gml"].read
			data = JSON.parse(gml_data)
			data_label = data["graph"]["label"]
			data_nodes = data["graph"]["nodes"]
			data_edges = data["graph"]["edges"]

			new_topology = Topology.create(name: data_label)
			nodes = new_topology.nodes.create(data_nodes.map {|node| {name: node['id']}})

			edges = []
			data_edges.each do |edge|
				source = nodes.find {|n| n.name == edge['source'].to_s}
				target = nodes.find {|n| n.name == edge['target'].to_s}
				edges << {source_node: source, target_node: target}
			end
			Link.create(edges)
		rescue
			redirect_to pages_index_path, :flash => { :error => "Parse Error" }
		end
		redirect_to pages_index_path, :flash => { :success => "Parse ok" }
	end

end