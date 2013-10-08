require 'rubygems'
require 'sinatra'
require 'kramdown'
require 'find'

class MarkdownRenderer
	def initialize ()
		@content = {}
	end

	def start_search
		Dir['markdown/**/*.md'].each {|fileName|
			name = create_tab_name_from(fileName)
			file = File.open(fileName)
			@content[name] = Kramdown::Document.new(file.read).to_html
		}
		@content
	end

	private

	def create_tab_name_from(name)
		File.basename(name, '.md').gsub(/[-_]/, ' ').capitalize
	end
end

get '/' do
	content = MarkdownRenderer.new.start_search
	erb :index, :locals => { :content => content }
end
