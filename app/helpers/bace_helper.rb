module BaceHelper
  def meta_name(meta_key, klass_name=controller_name)
    Meta.cached_meta_name(klass_name.to_s, meta_key.to_s).try(:name)
  end

  def resource_name(controller_name = controller_name, action_name = action_name)
    Resource.cached_resource_name(controller_name.to_s, action_name.to_s).try(:name)
  end

  #meta_helper
  #XXX
  def value_meta_tag(id, f=nil, text_field_options={})
    meta = Meta.unlimit_find(:first, :conditions=>{:id => id})
    append_options = text_field_options.inspect.gsub(/[\{\}]/,'')
    append_options = ",#{append_options}" if append_options.present?
    default_editor = f ? "f.text_field method, :size => 8" : "text_field object, method, :size => 8"
    editor = meta.blank? || meta.editor.blank? ? default_editor : "#{meta.editor}"
    render :inline => "<%=#{editor} #{append_options}%\>", :locals => {:object=>'limit_scope', :method=>'value', :f => f}
  end
end