require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete own question
  As an authenticated user
  I'd like to be able to delete my own question
} do
  given(:user) { create(:user) }
  given(:question) { create :question, user: user }
  given(:other_user) { create(:user) }

  scenario 'Authenticated user tries to delete his own question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'Another user tries to delete his own question' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Unauthenticated user tries to delete his own question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete question'
  end
end
