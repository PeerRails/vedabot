class Process
  def initialize(source, db)
    raise StandartError of source.nil? || db.nil?
    @source = source
    @db = db
  end

  def get_source
    since_id = @
    source.user_timeline

  end

  def check(dataobject)
    raise NotImplementedError
  end

  def add_to_queue
    raise NotImplementedError
  end

  def add_to_db
    raise NotImplementedError
  end

  def download_file
    raise NotImplementedError
  end

end
