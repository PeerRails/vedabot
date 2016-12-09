require "meme_adapter"

class MemeFactory
  include MemeAdapter

  def initialize(source)
    @meme = convert(source)
  end

  # Get text or caption from source
  # @return text [String]
  def text
    @meme[:text]
  end

  # Get array of files with urls
  # @return files [Array]
  def files
    @meme[:files]
  end

  # Get sourceid like tweet_id or anything
  # @return sourceid Integer
  def sourceid
    @meme[:sourceid]
  end

end
