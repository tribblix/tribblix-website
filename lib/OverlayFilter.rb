class OverlayFilter < Nanoc::Filter
  identifier :overlay

  def run(content, params = {})
    content.gsub(/@([a-z0-9-]*)/, '<a href="overlay-\1.html">\1</a>')
  end
end
