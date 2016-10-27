module HtmlTagHelper

	def link_to(link_text, url, html_options = nil)
		"<a href='#{url}' #{html_options ? build_html_options(html_options) : ""}>#{link_text}#{block_given? ? yield : ""}</a>"
	end

	def content_tag(tag_name, content, html_options = nil)
		"<#{tag_name} #{html_options ? build_html_options(html_options) : ""}>#{content}#{block_given? ? yield : ""}</#{tag_name}>"
	end

	def tag(tag_name, html_options = nil)
		"<#{tag_name} #{html_options ? build_html_options(html_options) : ""} />"
	end

	# def build_html_options(html_options)
	# 	binding.pry
	# 	html_options = ""
	# 	html_options.each do |key, value|
	# 		html_options += " #{key}='#{value}'"
	# 	end
	# 	html_options
	# end

	def build_html_options(html_options)
		html_options.is_a?(Hash) ? html_options.inspect.gsub(/[}{:>,]/, '') : html_options
	end

end