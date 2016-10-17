require 'csv'

# Public: Reader is used to read data and initialization of all other objects
class Reader
  attr_reader :pollen_path, :harvest_path, :bee_stats

  # Public: Initialize Reader
  #
  # pollen_path  - a String path to file with pollen data
  # harvest_path - a String path to file with harvet data
  def initialize(pollen_path, harvest_path)
    @pollen_path  = pollen_path
    @harvest_path = harvest_path
  end

  # Public: read data from files
  #
  # Returns a BeeStats
  def read
    @bee_stats = BeeStats.new

    read_pollen
    read_harvest

    bee_stats
  end

  private

  # Internal: read data from harvest_path to Workdays, and populate it with sugar harvested
  #
  # Returns nothing
  def read_harvest
    CSV.foreach(harvest_path, headers: true, header_converters: :symbol) do |row|
      sugar_harvested = bee_stats.pollens.find(row[:pollen_id]).sugar_per_mg * row[:miligrams_harvested].to_i

      bee_stats.workdays.add(row[:bee_id], row[:day], row[:pollen_id], row[:miligrams_harvested], sugar_harvested)
    end
  end

  # Internal: read data from pollen_path to Pollens
  #
  # Returns nothing
  def read_pollen
    CSV.foreach(pollen_path, headers: true, header_converters: :symbol) do |row|
      bee_stats.pollens.add(row[:id], row[:name], row[:sugar_per_mg].to_i)
    end
  end
end