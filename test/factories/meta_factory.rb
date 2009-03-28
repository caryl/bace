Factory.define :meta do |meta|
  meta.klass_id '1'
  meta.key 'name'
  meta.name 'User name'
  meta.kind_id '1'
  meta.assoc_klass_id ''
  meta.include ''
  meta.joins ''
end

Factory.define :var_meta, :class => Meta do |meta|
  meta.klass_id '1'
  meta.key 'today'
  meta.name 'Today'
  meta.kind_id '2'
  meta.assoc_klass_id ''
  meta.include ''
  meta.joins ''
end

