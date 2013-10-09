
class MDConverter
  def convert_files(directory, syntax)
    @syntax = syntax
    Dir.foreach(directory) do |filename|
      process_file(filename) if File.extname(filename) == '.txt'
    end
  end

  private
  def process_file(filename)
    md_file = File.open(new_filename(filename), 'w')
    text_file = File.open(filename, 'r')

    md_file.puts heading_from_filename(filename)
    md_file.puts '   '
    md_file.puts "Date: #{File.mtime(text_file)}"
    md_file.puts '   '

    text_file.each_line do |line|
      md_file.puts processed_line(line)
    end

    md_file.puts '   '
    md_file.puts '***'

    md_file.close
    text_file.close
  end

  def heading_from_filename(filename)
    filename.gsub(/_/, ' ').gsub(/.txt/, '').prepend('###')
  end

  def processed_line(line)
    @syntax.convert(line)
  end

  def new_filename(filename)
    filename.gsub(/.[a-z]{3}$/, '.md')
  end
end

class JTSupportSyntax
  def initialize
    @tag_words = ['fix', 'solution', 'resolution', 'before', 'after', 'issue', 'ticket', 'error']
  end

  def convert(line)
    line = bold_tag_words(line)
    line = convert_h4(line)
    line = convert_hr(line)
    line = convert_dashed_hr(line)
    line = convert_list_items(line)
    line = convert_url(line)
    line = convert_email(line)
    line = convert_filepath(line)
    line = convert_ipaddress(line)
    line
  end

  private
  def bold_tag_words(line)
    @tag_words.each do |word|
      line.gsub!(/(^#{word}$)/i, '**\1**')
    end
    line
  end

  def convert_h4(line)
    /:\s*$/.match(line) ? line.prepend('####'): line
  end

  def convert_hr(line)
    line.gsub(/^[=*]{3,}$/, '   ')
  end

  def convert_dashed_hr(line)
    line.gsub(/[-\s]{4,}/, '  ')
  end

  def convert_list_items(line)
    /^[*]{3,}[^*]+$/.match(line) ? line.gsub(/^[*]{3,}/, '*') : line
  end

  def convert_url(line)
    line.gsub(/(http[s]?:\/\/[\S]+)/, '[\1](\1)')
  end

  def convert_email(line)
    line.gsub(/(\w+@\w+\.\w{3})/, '[\1](mailto:\1)')
  end

  def convert_filepath(line)
    line.gsub(/([A-Z]:\\[\S]+)/, '`\1`')
  end

  def convert_ipaddress(line)
    line.gsub(/(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:?\d{0,4}\b)/, '[http://\1](http://\1)')
  end
end

converter = MDConverter.new()
converter.convert_files('.', JTSupportSyntax.new())