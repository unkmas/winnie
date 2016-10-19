# Public: main class, that rules all of bee statistics
class BeeStats
  attr_reader :pollens, :workdays

  # Public: initializes BeeStats
  def initialize
    @pollens  = Pollens.new
    @workdays = Workdays.new
  end

  # Public: Returns name and amount of harvested sugar from most-sugar-pollen
  #
  # Returns a String name of pollen
  def best_sugar_pollen
    best_pollen = best(:pollen, :sugar_total)

    pollens.find(best_pollen.key).name
  end

  # Public: Returns name and amount of mg harvested from most popular pollen
  #
  # Returns a String name of pollen
  def most_popular_pollen
    best_pollen = best(:pollen, :mg_total)

    pollens.find(best_pollen.key).name
  end

  # Public: Gets best stat by attribute
  #
  # type      - an Object, that responds to to_s, type of data
  # attribute - an Object, that responds to to_s, attribute to compare
  #
  # Examples
  #    best(:days, :sugar_total)
  #
  # Returns Workdays::Totals
  def best(type, attribute)
    get_stats(type).max {|a, b| a.send(attribute) <=> b.send(attribute) }
  end

  # Public: Gets worst stat by attribute
  #
  # type      - an Object, that responds to to_s, type of data
  # attribute - an Object, that responds to to_s, attribute to compare
  #
  # Examples
  #    worst(:days, :sugar_total)
  #
  # Returns Workdays::Totals
  def worst(type, attribute)
    get_stats(type).min {|a, b| a.send(attribute) <=> b.send(attribute) }
  end

  # Public: Gets stats of a given type
  #
  # type - an Object, that responds_to to_s, type of data
  #
  # Returns Array of Workdays::Totals
  # Raises ArgumentError if there is no such type of stats
  def get_stats(type)
    method_name = type.to_s + '_stats'
    if respond_to?(method_name)
      send(method_name)
    else
      raise ArgumentError.new('there is no such stat!')
    end
  end

  # Public: Returns totals by pollen
  #
  # Returns Array of Workdays::Totals
  def pollen_stats
    @pollen_stats ||= workdays.pollen_totals
  end

  # Public: Returns totals by day
  #
  # Returns Array of Workdays::Totals
  def days_stats
    @days_stats ||= workdays.days_totals
  end

  # Public: Returns totals by bees
  #
  # Returns Array of Workdays::Totals
  def bee_stats
    @bee_stats ||= workdays.bee_totals
  end
end