module Plans
  module SRP
    class SolarAverage < Plans::SolarBase
      include AverageDemandConcern
      include ::SRP::Dates

      # Only accumulate demand charges for on-peak periods
      def add_demand(date, kwh)
        return 0 unless level(date) != :off_peak
        super
      end

      def display_name
        "SRP/E15 (Average Demand)"
      end

      def notes
        n = "Estimated system cost: #{system_cost}."
        n += " Demand charges are estimated and may be inaccurate." unless @demand_schedule
        n
      end

      def fixed_charges
        32.44
      end

      def demand_usage(date, kwh)
        return 0 if level(date) == :off_peak
        if @demand_schedule
          demand_for_period(date)
        else
          # SRP cares about half-hour demand, but it doesn't particularly define this; I think this means effectively
          # the peak kilowatt-half hour for the month. We'll use 15% over the peak value of any individual hour, to
          # estimate cases where peak draw was high for a period, and was then dropped for the remainder of the hour.
          kwh * 1.15
        end
      end

      def demand_rate(date)
        case season(date)
        when :winter
          8.13
        when :summer
          19.29
        else
          21.94
        end
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
            0.0634
          when :on_peak
            0.0674
          else
            raise "Bad level"
          end
        when :summer
          case l
          when :off_peak
            0.0561
          when :on_peak
            0.0663
          else
            raise "Bad level"
          end
        when :summer_peak
          case l
          when :off_peak
            0.0613
          when :on_peak
            0.0823
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
