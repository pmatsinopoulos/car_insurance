class InsurerCoverage
  # @param name   {String}
  # @param covers {String}
  #
  # Examples:
  #     windows+tires
  #     doors+engine
  #
  def initialize(name, covers)
    @name   = name
    @covers = covers.split('+')
  end

  attr_reader :covers, :name
end
