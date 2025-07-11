module Plans
  module SRP
    class EVSolar < SolarBase
      include ::SRP::Dates

      def demand_usage(date, kwh)
        0
      end

      def notes
        "Only available to customers with a plug-in battery or hybrid vehicle. Requires solar. " +
        "Estimated system cost: #{system_cost}."
      end

      def display_name
        "SRP/E14 (EV Solar)"
      end

      def fixed_charges
        32.44
      end

      def level(date)
        super_offpeak_level date
      end

      def net_metering_rate
        0.0281
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
            0.0215
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
