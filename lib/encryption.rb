require 'digest'

class Encryption
  ENC_SALT = '*BaC$%caYLE.'
  
  class << self
    # 使用md5算法把明文转为密文
    def md5(text)
      Digest::MD5.hexdigest(text) unless text.blank?
    end
  
    # 对明文做再次加密
    def encrypt(plain)
      Encryption.md5(ENC_SALT + plain.to_s)
    end
  end
end
