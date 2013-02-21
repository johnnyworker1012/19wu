class Invitation < ActiveRecord::Base
  
  belongs_to :user


  attr_accessible :code, :activated

  def authenticate(code)
    if self.code == code
      true
    else
      false
    end
  end
  
  def generate_code
    self.code = Digest::MD5.hexdigest(self.user.email + Time.now.to_s)
    self.save
    UserMailer.delay.invitation_mail(self.user)
  end

end
