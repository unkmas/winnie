# Public: Handles workdays
class Workdays
  # Public: Structure, containing single workday
  Workday = Struct.new(:bee_id, :day, :pollen_id, :mg_harvested, :sugar_harvested)
  # Public: Structure, containing single total
  Totals = Struct.new(:key, :mg_total, :sugar_total, :records_total)

  # Public: Initializes Workdays
  def initialize
    @data = []
  end

  # Public: adds new workday to the data
  #
  # bee_id          - a String id of bee
  # day             - a String day
  # pollen_id       - a String id of pollen harvested
  # mg_harvested    - an Object, that responds to to_f, count of mg harvested
  # sugar_harvested - an Object, that responds to to_f, amount of sugar harvested
  #
  # Examples
  #    add('10', '2014-10-11', '1', 12)
  #
  # Returns nothing
  # Raises ArgumentError if mg_harvested cannot respond to to_i.
  # Raises ArgumentError if sugar_harvested cannot respond to to_i.
  def add(bee_id, day, pollen_id, mg_harvested, sugar_harvested)
    if !sugar_harvested.respond_to?(:to_i) || !mg_harvested.respond_to?(:to_i)
      raise ArgumentError.new('Sugar per mg must be a number')
    end

    @data << Workday.new(bee_id, day, pollen_id, mg_harvested.to_f, sugar_harvested.to_f)
  end

  # Public: gets totals from workdays by pollen
  #
  # Returns Array of Workdays::Totals
  def pollen_totals
    totals(:pollen_id)
  end

  # Public: gets totals from workdays by day
  #
  # Returns Array of Workdays::Totals
  def days_totals
    totals(:day)
  end

  # Public: gets totals from workdays by bee
  #
  # Returns Array of Workdays::Totals
  def bee_totals
    totals(:bee_id)
  end

  private

  # Internal: counting totals for workdays, grouped by paramether
  #
  # key - a Symbol, method name for groupping
  #
  # Returns Array of Workdays::Totals
  def totals(key)
    @data.group_by(&key).map do |key, workdays|
      totals = workdays.inject([0, 0]) do |array, workday|
        array[0] += workday.mg_harvested
        array[1] += workday.sugar_harvested

        array
      end

      Totals.new(key, totals[0], totals[1], workdays.length)
    end
  end
end