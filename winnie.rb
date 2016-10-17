Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each {|file| require file }

# q = Reader.new('/home/unkmas/kontur-test/data/pollens.csv', '/home/unkmas/kontur-test/data/harvest.csv')
# bee_stats = q.read

class Winnie
  attr_reader :bee_stats

  # Public: initializes Winnie
  #
  # pollens_path - a String full path to pollens csv
  # harvest_path - a String full path to harvest csv
  def initialize(pollens_path, harvest_path)
    reader = Reader.new(pollens_path, harvest_path)
    @bee_stats = reader.read
  end

  # Public: outputs stats in specified format
  #
  # format - a Symbol, format. One of: [:plain]. (default: :plain)
  #
  # Returns nothing.
  # Raises ArgumentError if unsupported format given
  def output(format = :plain)
    case format
    when :plain
      Formatter::PlainText.format(values)
    else
      raise ArgumentError.new('There is no such format!')
    end
  end

  private
  # Internal: prepares values for render
  #
  # Returns hash of such values
  def values
    bee_proc = Proc.new {|a,b| (a.sugar_total / a.records_total) <=> (b.sugar_total / b.records_total) }

    {
      best_sugar_pollen: bee_stats.best_sugar_pollen,
      most_popular_pollen: bee_stats.most_popular_pollen,
      best_day: bee_stats.best(:days, :sugar_total).key,
      worst_day: bee_stats.worst(:days, :sugar_total).key,
      best_bee: bee_stats.get_stats(:bee).max(&bee_proc).key,
      worst_bee: bee_stats.get_stats(:bee).min(&bee_proc).key
    }
  end
end