# == Schema Information
#
# Table name: tours
#
#  id         :uuid             not null, primary key
#  date       :date
#  end_time   :time
#  number     :integer
#  start_time :time
#  timezone   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tour < ApplicationRecord
end
