class Current
  cattr_accessor :user_proc, :controller_proc

  def self.user
    user_proc.call
  end

  def self.controller
    controller_proc.call
  end

  def self.controller_name
    controller.controller_name
  end

  def self.action_name
    controller.action_name
  end

  #interface
  def self.always_free?
    true
  end
end
