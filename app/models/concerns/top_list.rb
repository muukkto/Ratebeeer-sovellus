module TopList
  include AverageRating

  def top(n)
    sorted_by_rating_in_desc_order = all.sort_by{ |b| -b.average_rating }
    sorted_by_rating_in_desc_order.take(n)
  end
end
