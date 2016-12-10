module MemeAdapter

  # Convert object to MemeObject
  # @params source [any]
  # @return meme [Hash]
  def convert(source)
    meme = {
      text: source.text,
      sourceid: source.id,
      files: [media(source)]
    }
  end

  # Fetch media to files
  # @params source [any]
  # @return media_url [String]
  def media(source)
    if source.media? && source.media.count == 1
      source.media[0].media_url.to_s
    else
      nil
    end
  end
end
