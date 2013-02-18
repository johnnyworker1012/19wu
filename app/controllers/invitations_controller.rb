class InvitationsController < ApplicationController
  prepend_before_filter :authenticate_user!


  def new

    @invitation = current_user.invitation

    #for user who has not requested an invitation
    if @invitation.nil?
      @invitation = current_user.build_invitation
    else
      #for user who has received the invitation code
      @invitation.code = nil
    end

    respond_to do |format|
      format.html
    end
  end

  def approve
    #after the admin approve the invitation request
    #an invitation code will be generated and sent to the user
    user = User.find_by_email(params[:email])
    invitation = user.invitation
    invitation.code = Digest::MD5.hexdigest(user.email + Time.now.to_s)
    invitation.save
    UserMailer.delay.invitation_mail(user)
    redirect_to '/admin'
  end

  def create
    invitation = current_user.invitation
    if invitation.nil?
      invitation = Invitation.new
      invitation.user_id = current_user.id
      invitation.save
      redirect_to root_path, :alert => "a invitation request has been made, please waiting for approval"
    else
      if invitation.code.nil?
      #mean has been not approved
        redirect_to root_path, :alert => "You invitaion request has not been approved, please wait...."
      else
        #probably admin has approved, but you forget the invitation code and wanna create a new one
        invitation.code = nil
        invitation.save
        redirect_to root_path, :alert => "a invitation request has been made, please wait for approval"
      end
    end
  end


  def authenticate

    code = params[:invitation][:code]

    if code.empty? 
      redirect_to new_invitation_path, :alert => "please input code"
    else
      invitation = current_user.invitation

      #if the user has not requested an invitation, ask him to request a new one
      if invitation.nil?
        redirect_to new_invitation_path, :alert => "you have not requested an invitation,please do it in the link below"
      else 
        #if the invitation code submitted by the user is correct, make him activated
        if invitation.authenticate(code) 
          invitation.activated = true
          invitation.save
          redirect_to new_event_path
        else
          redirect_to new_invitation_path, :alert => "Please input correct invitation code"
        end
      end
    end
  end

end
  
