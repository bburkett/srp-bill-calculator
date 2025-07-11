module Plans
  module SRP
    class ElectricVehicle < Base
      include ::SRP::Dates

      def notes
        "Only available to customers with a plug-in battery or hybrid vehicle."
      end

      def display_name
        "SRP/E29 (Electric Vehicle)"
      end

      def fixed_charges
        20
      end

      def level(date)
        super_offpeak_level date
      end

      def rate(date)
        l = level date
        case season(date)
        when :winter
          case l
          when :super_off_peak
            0.0839
          when :off_peak
            0.1001
          when :on_peak
            0.1215
          else
            raise "Bad level"
          end
        when :summer
          case l
          when :super_off_peak
            0.0812
          when :off_peak
            0.0966
          when :on_peak
            0.2295
          else
            raise "Bad level"
          end
        when :summer_peak
          case l
          when :super_off_peak
            0.0815
          when :off_peak
            0.0971
          when :on_peak
            0.2610
          else
            raise "Bad level"
          end
        end
      end
    end
  end
end
