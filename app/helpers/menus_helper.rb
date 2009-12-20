module MenusHelper
  def granted_menus_for(user)
    menus = user.cached_granted_menus
    uls = menus.select{|m|m.parent_id.blank?}.map do |m|
      content_tag :ul, build_tree(m, menus)
    end.join("\n")
    content_tag :div, uls, :id => 'granted_menus'
  end

  def build_tree(root, sets)
    li = content_tag(:li, link_to(root.try(:name), root.try(:url)))
    ul = ""
    children = sets.select{|m|m.parent_id == root.try(:id)}
    children.each do |child|
      ul << build_tree(child, sets)
    end
    ul = content_tag(:ul, ul) if children.present?
    li << ul
  end
end