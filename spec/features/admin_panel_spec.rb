require 'spec_helper'

feature 'admin panel with non-admin user' do

  given(:user) {create(:user)}
   
  background do
    login_user
  end 

  scenario 'user who is not admin go to the panel' do
    click_link(I18n.t('admin.entry_link')) 
    page.should have_content(I18n.t('flash.admin.permission_not_granted'))
  end

end

feature 'admin panel with admin user' do
  given(:admin) {create(:user, :admin, :confirmed)}
  given(:unapproved_user) {create(:user, :internal_test_not_approved, :confirmed )}

  background do
    login_user admin
  end

  scenario 'when admin approve invitation requests' do

    click_link(I18n.t('admin.entry_link')) 
    page.should have_content(I18n.t('admin.header'))
    email = find(:css, '.email').text
    click_link(I18n.t('admin.buttons.approve'))
    open_email(email)
    expect(current_email).to have_content(I18n.t('internal_testing.email.subject'))
     

  end

end
