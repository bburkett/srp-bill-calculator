module Plans
  module SRP
    class Basic < Base
      include ::SRP::Dates

      def fixed_charges
        20
      end

      def level(date)
        case season(date)
        when :winter
          :off_peak
        when :summer
          if monthly_usage <= 2000
            :off_peak
          else
            :on_peak
          end
        when :summer_peak
          if monthly_usage <= 2000
            :off_peak
          else
            :on_peak
          end
        else
          raise "Bad level"
        end
      end

      def rate(date)
        l = level date
        case season(date)
        when :winter
          0.1046
        when :summer
          case l
          when :off_peak
            0.1292
          when :on_peak
            0.1335
          else
            raise "Bad level"
          end
        when :summer_peak
          case l
          when :off_peak
            0.1358
          when :on_peak
            0.1471
          else
            raise "Bad level"
          end
        end
      end
    end
  end
end
