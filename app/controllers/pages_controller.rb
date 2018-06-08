require "json"

class PagesController < ApplicationController

	def index
	end

	# TODO cut to small functions. Not Clean Code

	def parse_file_json(file_data)
		data = JSON.parse(file_data)
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
	end

	def parse_file_graphml(file_data)
		data = Hash.from_xml(file_data)
		data_label = data["graphml"]["graph"]["data"][12]
		data_nodes = data["graphml"]["graph"]["node"]
		data_edges = data["graphml"]["graph"]["edge"]

		new_topology = Topology.create(name: data_label)
		nodes = new_topology.nodes.create(data_nodes.map {|node| {name: node['id']}})

		edges = []
		data_edges.each do |edge|
			source = nodes.find {|n| n.name == edge['source']}
			puts source.inspect
			target = nodes.find {|n| n.name == edge['target']}
			edges << {source_node: source, target_node: target}
		end
		Link.create(edges)
	end

	def parse_file
		file_data= params["parse_file"].read
		accepted_formats = [".json", ".graphml"]
		file_name_original = params["parse_file"].original_filename
		extension_file = File.extname(file_name_original)
		begin
			if extension_file == accepted_formats[0]
				parse_file_json(file_data)
			else
				parse_file_graphml(file_data)
			end
		rescue
			redirect_to pages_index_path, :flash => { :error => "Parse Error" } and return
		end
		redirect_to pages_index_path, :flash => { :success => "Parse ok" }
	end

end