module ApplicationHelper
  def hilite(column)
    css_class = column == params[:sort] ? "hilite" : nil
  end
end
