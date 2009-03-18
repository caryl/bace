Factory.define :user do |user|
  user.login 'admin'

  user.name 'admin'
  user.email 'my@email.at'
  user.remark 'administrator'
  user.state_id '1'
end
