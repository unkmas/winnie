require 'prawn'
require 'gruff'

module Formatter
  class PDF
    # Colors
    BLACK      = "000000"
    LIGHT_GRAY = "F2F2F2"
    GRAY       = "DDDDDD"
    ORANGE     = "F28157"

    class << self
      def format(stats)
        draw_day_chart(stats)
        draw_bee_chart(stats)
        draw_pdf(stats)
      end

      # Internal: Draw chart for sugar harvested by days
      #
      # Returns nothing
      def draw_day_chart(stats)
        stats[:all_by_days].sort_by!(&:key)
        g = Gruff::SideBar.new(350)
        g.title = 'Количество сахара по дням'
        g.labels = stats[:all_by_days].each_with_index.inject({}) do |hash, (stat, index)|
          hash[index] = index % 5 == 0 ? stat.key : ''
          hash
        end

        g.data('Сахар', stats[:all_by_days].map(&:sugar_total))
        g.write('days_chart.png')
      end

      # Internal: Draw chart for sugar harvested by bees
      #
      # Returns nothing
      def draw_bee_chart(stats)
        stats[:all_by_bees].each {|x| x.key = x.key.to_i }
        stats[:all_by_bees].sort_by!(&:key)
        g = Gruff::SideBar.new(350)
        g.title = 'Количество сахара, собранного пчёлами'
        g.labels = stats[:all_by_bees].each_with_index.inject({}) do |hash, (stat, index)|
          hash[index] = stat.key.to_s
          hash
        end

        g.data('Сахар', stats[:all_by_bees].map(&:sugar_total))
        g.write('bee_chart.png')
      end

      # Internal: Draws pdf with analytics
      #
      # Returns nothing
      def draw_pdf(stats)
        dejavu_path = File.join(File.dirname(__FILE__), '../../fonts/DejaVuSans.ttf')
        Prawn::Document.generate("output.pdf") do
          font dejavu_path
          bounding_box([-bounds.absolute_left, cursor + 36],
                     width: bounds.absolute_left + bounds.absolute_right,
                     height: 42) do

            fill_color LIGHT_GRAY
            fill_rectangle([bounds.left, bounds.top], bounds.right, bounds.top - bounds.bottom)
            fill_color BLACK

            indent(33) do
              font_size(18) do
                formatted_text([{text: 'Аналитика Улья', color: ORANGE  }], valign: :center)
              end
            end
          end

          stroke_color GRAY
          stroke_horizontal_line(-36, bounds.width, :at => cursor)
          stroke_color BLACK

          move_down(10)

          font_size(18) { text "Привет, дорогой друг." }
          text "Представляю тебе подробную аналитику по пчёлам в этом улье."
          stroke_color GRAY
          stroke_horizontal_line(0, bounds.width, :at => cursor)
          stroke_color BLACK
          move_down(10)

          text "Больше всего сахара было получено из пыльцы: #{stats[:best_sugar_pollen]}"
          text "Самая популярна пыльца среди пчёл: #{stats[:most_popular_pollen]}"
          move_down(10)

          text "Лучший день для сбора урожая: #{stats[:best_day]}"
          text "Худший день для сбора урожая: #{stats[:worst_day]}"
          move_down(10)
          image "days_chart.png"
          move_down(10)

          text "Самая эффективная пчела: #{stats[:best_bee]}"
          text "Самая неэффективная пчела: #{stats[:worst_bee]}"
          move_down(10)
          image "bee_chart.png"
        end

        puts 'Отчёт сгенерирован в файл output.pdf'
      end

    end
  end
end