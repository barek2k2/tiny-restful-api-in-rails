class Page < ApplicationRecord
  validates :url, presence: true
  has_many :page_contents, :dependent => :destroy

  def self.save_page(page)

  end


end
