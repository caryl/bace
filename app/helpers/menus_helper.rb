module MenusHelper
  def granted_menus_for(user)
    menus = user.cached_granted_menus
    build_tree(menus.first, menus)
  end

  def build_tree(root, sets)
    li = content_tag(:li, link_to(root.name, root.url))
    ul = ""
    children = sets.select{|m|m.parent_id == root.try(:id)}
    children.each do |child|
      ul << build_tree(child, sets)
    end
    ul = content_tag(:ul, ul) if children.present?
    li << ul
  end
end