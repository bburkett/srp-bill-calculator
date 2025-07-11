module Plans
  module SRP
    class TimeOfUse < Base
      include ::SRP::Dates

      def fixed_charges
        20
      end

      def level(date)
        standard_level date
      end

      def rate(date)
        l = level date
        case season(date)
        when :winter
          case l
          when :off_peak
            0.0955
          when :on_peak
            0.1215
          else
            raise "Bad level"
          end
        when :summer
          case l
          when :off_peak
            0.0928
          when :on_peak
            0.2295
          else
            raise "Bad level"
          end
        when :summer_peak
          case l
          when :off_peak
            0.0931
          when :on_peak
            0.2610
          else
            raise "Bad level"
          end
        else
          raise "Bad level"
        end
      end
    end
  end
end
