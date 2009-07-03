Factory.define :meta do |meta|
  meta.klass_id '1'
  meta.key 'name'
  meta.name 'User name'
  meta.assoc_klass_id ''
  meta.include ''
  meta.joins ''
end

Factory.define :var_meta, :class => Meta do |meta|
  meta.key 'today'
  meta.name 'Today'
  meta.assoc_klass_id ''
  meta.include ''
  meta.joins ''
end

