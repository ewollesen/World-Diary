Factory.define :user do |u|
  u.first_name "Test"
  u.last_name "User"
  u.email "test@example.com"
  u.password u.password_confirmation "password"
  u.dm false
end

Factory.define :subject do |s|
  s.name "Test Subject"
  s.text "This is the test subject."
end

Factory.define :veil_pass do |vp|
  vp.subject Factory(:subject)
  vp.user Factory(:user, {email: "test+veil_pass@example.com"})
end
