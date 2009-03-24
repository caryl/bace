Factory.define :limit_scope do |limit_scope|
  limit_scope.role_id '1'
  limit_scope.permission_id '1'
  limit_scope.key_meta {Factory(:meta, :klass=>Factory(:klass))}
  limit_scope.prefix ''
  limit_scope.op '='
  limit_scope.value_meta_id '1'
  limit_scope.value ''
  limit_scope.suffix ''
  limit_scope.logic 'AND'
  limit_scope.position '1'
end
