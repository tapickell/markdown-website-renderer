require 'rubygems'
require 'sinatra'
require 'kramdown'
require 'find'
require 'json'

class MarkdownRenderer
	def initialize ()
		@content = {}
	end

	def get_documents
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
	erb :index
end

get '/content.json' do
	content_type :json
	MarkdownRenderer.new.get_documents.to_json
end