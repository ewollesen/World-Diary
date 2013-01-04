require "minitest_helper"


describe "Veil Passes integration" do

  it "redirects anonymous users to the sign in page" do
    visit veil_passes_path

    current_path.must_equal new_user_session_path
  end

  describe "signed in" do

    let(:dm) {Factory(:user, dm: true, email: "dm@example.com")}
    let(:user) {dm; Factory(:user)}

    def sign_in
      visit new_user_session_path
      fill_in :user_email, :with => user.email
      fill_in :user_password, :with => user.password
      click_on "Sign in"

      page.has_link?("Sign Out").must_equal true
    end

    before do
      sign_in
    end

    describe "having 0 veil passes" do
      it "shows a blank list" do
        visit veil_passes_path

        current_path.must_equal veil_passes_path
      end
    end

    describe "having 1 veil pass" do
      let(:subject) {Factory(:subject)}

      it "shows 1 veil pass" do
        VeilPass.new do |vp|
          vp.user = user
          vp.subject = subject
        end.save!

        visit veil_passes_path

        assert page.has_content?(subject.name), "Veil Pass not found"
      end

    end
  end

end
