require "rails_helper"

describe "admin area" do

  let!(:admin) { create(:admin) }

  before :each do
    Permission.sync_and_permit_admins!

    visit "/en/admin/login"

    fill_in "admin_email", with: admin.email
    fill_in "admin_password", with: "password"
    click_button "Log in"
  end

  it "can log in" do
    expect(page).to have_content("Home")
  end

  it "can comment on a model" do
    model = create(:test_model)
    visit "/en/admin/test_models/#{model.id}"

    fill_in "comment_message", with: "Keep up the good work, admin"
    click_button "create"

    expect(Comment.all.count).to eq(1)
    expect(page).to have_content("Keep up the good work, admin")
  end

  it "can create a new TestModel" do
    visit "/en/admin/test_models"

    click_link "Create New Test model"

    expect{click_button "Create Test model"}.to change{TestModel.all.count}.from(0).to(1)
  end
end