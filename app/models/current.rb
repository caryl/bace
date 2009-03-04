class Current
  cattr_accessor :user_proc, :controller_proc, :action_proc

  def self.user
    user_proc.call
  end

  def self.controller
    controller_proc.call
  end

  def self.action
    action_proc.call
  end
end
