require 'sequel'
require 'pg'

class DatabaseAdapter
  def initialize(db_url)
    @db = Sequel.connect(db_url)
    migrate unless @db.table_exists?(:memes)
  end

  def migrate
    @db.create_table :memes do
      primary_key :id
      String :text
      String :filepath
      Integer :tweetid
      TrueClass :queue, default: true
      DateTime :created_at

      index :queue
    end
  end

  # @param source [Hash] consist of tweetid, text and filepath
  # @return rowid [Integer]
  def add_meme(source)
    return false if source.nil? || source.empty?
    # Source rendering will process ProcessApp or MessageAdapter
    source["created_at"] = DateTime.now
    @db[:memes].insert(source)
  end

  # Get record from database
  # @param id [Integer]
  # @return [Hash]
  def get_meme(id)
    @db[:memes].first(id: id)
  end

  def next_que
    @db[:memes].order(:tweetid).first(queue: true)
  end

  def remove_que(id)
    @db[:memes].where(id: id).update(queue: false)
  end

  def get_que
    @db[:memes].where(queue: true)
  end
end
