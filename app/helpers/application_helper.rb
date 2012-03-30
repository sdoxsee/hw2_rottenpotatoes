module ApplicationHelper
  def hilite_sort(column)
    column == sort_column ? "hilite" : nil
  end
  def sortable(column, title = nil)
    title ||= column.titleize
    link_to title, {:sort => column, :ratings => params[:ratings]}, {:id => column+"_header"} 
  end
  def is_checked(rating)
    selected_ratings.include?(rating)
  end
end
