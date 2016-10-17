module Formatter
  # Public: plain text formatter
  class PlainText
    def self.format(stats)
      puts <<-TEXT
        Больше всего сахара было получено из пыльцы: #{stats[:best_sugar_pollen]}
        Самая популярна пыльца среди пчёл: #{stats[:most_popular_pollen]}
        Лучший день для сбора урожая: #{stats[:best_day]}
        Худший день для сбора урожая: #{stats[:worst_day]}
        Самая эффективная пчела: #{stats[:best_bee]}
        Самая неэффективная пчела: #{stats[:worst_bee]}
      TEXT
    end
  end
end