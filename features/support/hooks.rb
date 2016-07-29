Before ('@logged_in') do
  user = User.create!(name: 'Test User',email: 'testuser@example.uk.com',password: 'password',password_confirmation: 'password')
  visit new_user_session_path
  fill_in 'Email', with: 'testuser@example.uk.com'
  fill_in 'Password', with: "password"
  page.find('input[value="Log in"]').click
end
