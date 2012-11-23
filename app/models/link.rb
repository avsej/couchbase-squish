class Link < Couchbase::Model

  attribute :url, :session_id
  attribute :views, :default => 0
  attribute :created_at, :default => lambda { Time.zone.now }

  view :by_created_at, :by_session_id, :by_view_count

  validates :url, :presence => true, :url => {:allow_nil => true, :message => "This is not a valid URL"}
  before_save :generate_key

  def generate_key
    while self.id.nil?
      random = SecureRandom.hex(2)
      self.id = random if self.class.find_by_id(random).nil?
    end
  end

  def self.popular
    by_view_count(:descending => true, :limit => 10).to_a
  end

  def self.my(session_id)
    by_session_id(:key => session_id).to_a
  end

  def self.recent
    by_created_at(:descending => true, :limit => 10).to_a
  end

end
