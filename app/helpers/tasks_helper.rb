module TasksHelper
  def order_icon(order)
    case order
    when 'asc'  then '▲'
    when 'desc' then '▼'
    end
  end
end
