desc "This task converts all .txt files in the markdown folder to .md files"
task :convert_files do
	Dir.chdir("markdown/")
	bundle exec ruby "text_to_md.rb"
end