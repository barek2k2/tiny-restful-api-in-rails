class PageContent < ApplicationRecord
  belongs_to :page

  COMPONENTS_TO_TRACK = %w(a h1 h2 h3)

end
