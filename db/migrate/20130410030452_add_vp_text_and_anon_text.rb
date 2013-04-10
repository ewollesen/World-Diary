class AddVpTextAndAnonText < ActiveRecord::Migration

  def change
    add_column(:subjects, :vp_text, :text)
    add_column(:subjects, :anon_text, :text)
  end

end
