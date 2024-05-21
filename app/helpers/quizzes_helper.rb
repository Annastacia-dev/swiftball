module QuizzesHelper

  def era_color(era)
    case era
    when 'lover'
      'bg-rose-200 text-rose-900'
    when 'fearless'
      'bg-yellow-200 text-yellow-900'
    else
      'bg-black text-white'
    end
  end
end
