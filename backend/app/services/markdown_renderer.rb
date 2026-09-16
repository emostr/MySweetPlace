require "rouge/plugins/redcarpet"

class MarkdownRenderer
  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def header(text, _level) = "<p><strong>#{text}</strong></p>\n"
    def image(_link, _title, alt) = ERB::Util.html_escape(alt.to_s)
  end

  TAGS = %w[p br strong em del code pre blockquote ul ol li a span div hr].freeze
  ATTRIBUTES = %w[href rel target class].freeze

  def self.render(text)
    html = parser.render(text.to_s)
    Rails::HTML5::SafeListSanitizer.new.sanitize(html, tags: TAGS, attributes: ATTRIBUTES).strip
  end

  def self.parser
    @parser ||= Redcarpet::Markdown.new(
      HTML.new(escape_html: true, hard_wrap: true, safe_links_only: true,
        link_attributes: { rel: "nofollow ugc noopener", target: "_blank" }),
      autolink: true, fenced_code_blocks: true, strikethrough: true, no_intra_emphasis: true, lax_spacing: true
    )
  end
end
