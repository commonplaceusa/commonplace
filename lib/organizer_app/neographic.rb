module Neographic

  attr_reader :node

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attributes(*attrs)
      @attrs ||= []
      @attrs += attrs
    end

    def create(params)
      new(Neography::Node.create(params.slice(*self.attributes)))
    end

    def find(id)
      self.new(Neography::Node.load(id))
    end

  end

  def initialize(node)
    @node = node
  end

  def method_missing(method, *args)
    @node[method]
  end
  
  def update(hash)
    self.class.attributes.each {|attr| this[attr] = hash[attr]}
    return self
  end

  def to_json(*options)
    {}.tap {|hash|
      self.class.attributes.each {|attr| hash[attr.to_s] = @node[attr]}
    }.to_json(*options)
  end

end
