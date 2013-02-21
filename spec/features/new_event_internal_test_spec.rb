require 'spec_helper'


feature 'new event with user who has not requested invitation' do

  given(:user) {create(:user,:internal_test_init,:confirmed)}

  background do
    login_user user
    visit new_event_path
  end

  scenario 'the page should have a header' do
    page.should have_content(I18n.t('internal_testing.invitation.request_box_title'))
  end 

  scenario 'when there is an empty input' do
    click_button(I18n.t('internal_testing.buttons.submit_invitation'))
    page.should have_content(I18n.t('internal_testing.alerts.empty_invitation')) 
  end

  scenario 'when user input an invitation code' do
    fill_in('invitation_code', :with => 'sdfasdfasdfasd') 
    click_button(I18n.t('internal_testing.buttons.submit_invitation'))
    page.should have_content(I18n.t('internal_testing.alerts.not_requested_invitation')) 
  end

  scenario 'when user click the invitation request link' do
    click_link(I18n.t('internal_testing.invitation.request_invitation'))
    page.should have_content(I18n.t('internal_testing.alerts.after_invitation_made')) 
  end
end

feature 'new event with user who has requested invitation but not approved' do
  given(:user) {create(:user, :internal_test_not_approved,:confirmed)}

  background do
    login_user user
  end

  scenario 'user want to create an event' do
    visit new_event_path
    page.should have_content(I18n.t('internal_testing.alerts.request_not_approved'))
  end
end

feature 'new event with user who is approved' do
  given(:user) {create(:user, :internal_test_approved,:confirmed)}

  background do
    login_user user
    visit new_event_path
    page.should have_content(I18n.t('internal_testing.invitation.request_box_title'))
  end

  scenario 'user want to create an event with incorrect invitation code' do
    fill_in('invitation_code', :with => user.invitation.code.reverse) 
    click_button(I18n.t('internal_testing.buttons.submit_invitation'))
    page.should have_content(I18n.t('internal_testing.alerts.correct_invitation_required'))
  end

  scenario 'user want to create an event with correct invitation code' do
    fill_in('invitation_code', :with => user.invitation.code) 
    click_button(I18n.t('internal_testing.buttons.submit_invitation'))
    page.should have_content(I18n.t('labels.launch_event'))
  end
  
  scenario 'user lost his invitation code after he is approved' do
    click_link(I18n.t('internal_testing.invitation.request_invitation'))
    page.should have_content(I18n.t('internal_testing.alerts.resend_invitation_after_approved'))
    open_email(user.email)
    expect(current_email.subject).to have_content(I18n.t('internal_testing.email.subject'))
  end

end
