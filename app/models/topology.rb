class Topology < ApplicationRecord
  has_many :nodes

  def save
    if self.is_current?
      Topology.all.update(is_current: false)
    end
    super
  end


end
