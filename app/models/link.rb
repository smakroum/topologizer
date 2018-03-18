class Link < ApplicationRecord
  belongs_to :source_node, class_name: 'Node', foreign_key: :source_id
  belongs_to :target_node, class_name: 'Node', foreign_key: :target_id
  validates :source_node, uniqueness: { scope: :target_node }

  validates_numericality_of :target_id, :greater_than => Proc.new {|link| link.source_id }

  def self.links_by_node(node)
    Link.where(source_node: node).or(Link.where(target_node: node))
  end
end
