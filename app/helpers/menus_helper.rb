module MenusHelper
  def granted_menus_for(user)
    htmls = user.cached_granted_menus.map{|m|content_tag :li, m}
    content_tag :ul, htmls.join('')
  end
end