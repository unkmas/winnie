# Public: class, that maintins pollen information
class Pollens
  # Public: Struct, containing information abot single pollen
  Pollen = Struct.new(:name, :sugar_per_mg)

  # Pubic: Initializes Pollens
  def initialize
    @data = {}
  end

  # Public: adds new pollen to the data
  #
  # id           - a String id of pollen
  # name         - a String name of pollen
  # sugar_per_mg - an Object, that responds to to_i, value of sugar per mg for this pollen
  #
  # Examples
  #    add('10', 'Canola', 120)
  #
  # Returns nothing.
  # Raises ArgumentError if sugar_per_mg cannot respond to to_i.
  def add(id, name, sugar_per_mg)
    raise ArgumentError.new('Sugar per mg must be a number') unless sugar_per_mg.respond_to?(:to_i)
    @data[id] = Pollen.new(name, sugar_per_mg.to_i)
  end

  # Public: finds pollen by id
  #
  # id - a String pollen id
  #
  # Returns Pollens::Pollen if found, and nil if not
  def find(id)
    @data[id]
  end
end