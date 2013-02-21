class InvitationsController < ApplicationController
  prepend_before_filter :authenticate_user!


  def index
    authorize! :index, current_user 
    @invitations = Invitation.unapproved_invitations

    respond_to do |format|
      format.html
    end
  end

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
    invitation.generate_code
    redirect_to '/admin'
  end

  def create
    invitation = current_user.invitation
    if invitation.nil?
      invitation = Invitation.new
      invitation.user_id = current_user.id
      invitation.save
      redirect_to root_path, :alert => I18n.t('internal_testing.alerts.after_invitation_made')
    else
      if !invitation.code.nil?
        #probably admin has approved, but you forget the invitation code and wanna create a new one
        invitation.generate_code
        redirect_to root_path, :alert => I18n.t('internal_testing.alerts.resend_invitation_after_approved')
      end
    end
  end


  def authenticate

    code = params[:invitation][:code]

    if code.empty? 
      redirect_to new_invitation_path, :alert => I18n.t('internal_testing.alerts.empty_invitation')
    else
      invitation = current_user.invitation

      #if the user has not requested an invitation, ask him to request a new one
      if invitation.nil?
        redirect_to new_invitation_path, :alert => I18n.t('internal_testing.alerts.not_requested_invitation') 
      else 
        #if the invitation code submitted by the user is correct, make him activated
        if invitation.authenticate(code) 
          invitation.activated = true
          invitation.save
          redirect_to new_event_path
        else
          redirect_to new_invitation_path, :alert => I18n.t('internal_testing.alerts.correct_invitation_required')
        end
      end
    end
  end

end
  
