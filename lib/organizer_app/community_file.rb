class CommunityFile

  include Neographic

  attributes :name

  def add_resident(file)
    resident_nodes << file.node
  end

  def create_resident(params)
    ResidentFile.new(ResidentFile.new(params)).tap do |file|
      self.add_resident(file)
    end
  end

  def files
    resident_nodes.map {|n| ResidentFile.new(n) }
  end

  private

  def resident_nodes
    @node.outgoing("resident")
  end

end
