require "test_helper"

feature "VeilPasses" do

  let(:dm) {User.create!(dm: true,
                         email: "dm@example.com",
                         first_name: "Dungeon",
                         last_name: "Master",
                         password: "password",
                         password_confirmation: "password")}
  let(:the_user) {dm; User.create!(email: "player@example.com",
                                   first_name: "Foo",
                                   last_name: "Bar",
                                   password: "password",
                                   password_confirmation: "password")}

  def sign_in
    visit new_user_session_path

    fill_in :user_email, with: the_user.email
    fill_in :user_password, with: the_user.password
    click_on "Sign in"

    page.has_link?("Sign Out").must_equal true
  end

  scenario "redirects anonymous users to sign in" do
    visit veil_passes_path

    current_path.must_equal new_user_session_path
  end

  scenario "with 0 veil passes" do
    sign_in

    visit veil_passes_path

    current_path.must_equal veil_passes_path
  end

  scenario "with 1 veil pass" do
    sign_in

    subject = Subject.create!(name: "test subject", text: "foo")
    VeilPass.create!(subject: subject, user: the_user)

    visit veil_passes_path

    assert page.has_content?(subject.name), "Veil pass not found"
  end
end
