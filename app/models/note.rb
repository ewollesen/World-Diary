class Note < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_permalink

  validates :name, uniqueness: true, presence: true, format: {with: /\A[a-z0-9]/i}
  validates :permalink, :uniqueness => true, :presence => true
  validates :text, :presence => true

  before_save :update_vp_text, :if => :text_changed?
  before_save :update_anon_text, :if => :text_changed?

  def to_param
    self.permalink
  end

  def url
    new_record? ? new_note_path(note: {name: name}) : url_for(self)
  end

  def authorized_users
    []
  end

  private


  def self.dummy(name)
    Subject.new(name: name)
  end

  def update_vp_text
    self.vp_text = DmStripper.strip(text, nil, true)
  end

  def update_anon_text
    self.anon_text = DmStripper.strip(text, nil, false)
  end

end
