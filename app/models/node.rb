class Node < ApplicationRecord
  has_many :source_links, class_name: 'Link', foreign_key: :target_id
  has_many :target_links, class_name: 'Link', foreign_key: :source_id
  has_many :source_nodes, class_name:'Node', through: :source_links, source: :source_node
  has_many :target_nodes, class_name:'Node', through: :target_links, source: :target_node
  belongs_to :topology

  def links
    Link.links_by_node(self)
  end

  def linked_nodes
    self.source_nodes + self.target_nodes
  end

end
