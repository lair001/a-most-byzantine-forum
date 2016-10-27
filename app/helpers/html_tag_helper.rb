module HtmlTagHelper

	def link_to(link_text, url, html_options_hash = nil)
		html = "<a href='#{url}'#{html_options_hash ? build_html_options(html_options_hash) : ""}>#{link_text}"
		html += "#{yield}" if block_given?
		html += "</a>"
	end

	def content_tag(tag_name, content, html_options_hash = nil)
		html = "<#{tag_name}#{html_options_hash ? build_html_options(html_options_hash) : ""}>#{content}"
		html += "#{yield}" if block_given?
		html += "</#{tag_name}>"
	end

	def tag(tag_name, html_options_hash = nil)
		"<#{tag_name}#{html_options_hash ? build_html_options(html_options_hash) : ""} />"
	end

	def build_html_options(html_options_hash)
		html_options = ""
		html_options_hash.each do |key, value|
			html_options += " #{key}='#{value}'"
		end
		html_options
	end

end