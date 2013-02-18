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

end
