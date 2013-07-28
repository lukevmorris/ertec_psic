require 'spec_helper'

feature 'Application Homepage' do
  scenario 'The root path routes to the homepage' do
    visit root_path
    expect(page).to have_content 'Hi Dad!'
  end
end