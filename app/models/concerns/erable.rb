# frozen_string_literal: true

# Allow models to have an era
module Erable
  extend ActiveSupport::Concern

  included do
    enum era: {
      lover: 0,
      fearless: 1,
      red: 2,
      speak_now: 3,
      reputation: 4,
      folkmore: 5,
      '1989': 6,
      the_tortured_poets_department: 7,
      acoustic_set: 8,
      midnights: 9,
      extra: 10
    }

    def self.eras_options
      eras.map { |k, _v| [k.humanize, k] }
    end
  end
end
