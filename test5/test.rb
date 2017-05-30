#
# executed thusly : ruby test.rb Eli_Lyonhart 123_Main
# this is designed for a file structure reading:
# ./{client-name}/{property-address}/{collection-of-pdfs}
#

require 'combine_pdf'
require 'prawn'
require 'prawn/table'
require 'open-uri'
require 'pdf-reader'


# arguments to locate all applicable files
client = ARGV[0]
address = ARGV[1]
dir = "./#{client}/#{address}"

# initialize two .pdf files for later use
final_contract = CombinePDF.new

file_names, files_to_load, page_breaks = Array.new, Array.new, Array.new

# ------------
# find every file in named directory. format with path and pdf file name
# insert into array 'files_to_load'
# and the title itself into file_names
# ------------
def generate_file_path(dir, files_to_load, file_names, page_breaks)

  page_counts = [0]
  
  Dir.foreach(dir) do |fname|
    unless fname == '.' || fname == '..' || fname == '.DS_Store'
      files_to_load << "./#{dir}/#{fname}"
      file_names << fname

    io     = open("./#{dir}/#{fname}")
    reader = PDF::Reader.new(io)
    page_counts << reader.page_count

    end
  end

  i = 0
  page_counts.size.times do
    page_breaks << page_counts[0..i].inject(:+)
    i+=1
  end

  p page_breaks
end


# ------------
# create table of contents
# - create hash out of files
#   - Index + 1
#   - Name of file - '.pdf' with link using last 15 chars of file title as anchor
# ------------
def generate_table_of_contents(file_names, address)
  
  table_of_contents = Prawn::Document.new do
    contents_hash = { 0 => "Contract for #{address}" }

    file_names.each_with_index do |val,index|
      # store link structure as a string
      contents_hash[index+1] = "<link anchor='#{val[-20..-5]}'>#{val[0..-5]}</link>"
    end

    # "inline_format => true" converts above string, recognizing its link tag
    table(contents_hash, :cell_style => { :inline_format => true }) do |table|
      
      # a little structure for the table. 
      table.row(0).style(:background_color => 'dddddd', :size => 9, :align => :center, :font_style => :bold, :header => true)
      table.column(0).style(:background_color => 'dddddd', :size => 9, :align => :center, :font_style => :bold)

    end
  end
  table_of_contents.render_file "table_of_contents.pdf"
end


# ------------
# add table of contents and each file to pdf
# ------------
def combine_toc_and_elements(address, final_contract, files_to_load, table_of_contents)
  files_to_load.unshift("table_of_contents.pdf")
  files_to_load.each do |file|

    final_contract << CombinePDF.load(file)
  end

  final_contract.save "#{address}_final_contract.pdf"
end

def add_anchor_tags(address, page_breaks)
  current_page = 1
  io     = open("./#{address}_final_contract.pdf")
  reader = PDF::Reader.new(io)
  reader.pages.each do |page|
    # puts page.fonts         # not useful that I can see
    # puts reader.metadata    # there is NO metadata
    # puts page.text
    # puts page.raw_content
    # puts reader.info          # info about its recent creation. not useful
    if page_breaks.include?(current_page)
      p "hallelujha! #{current_page}"
    end
    # puts reader.page_count
    # p "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
    current_page+=1
  end
end

# execute above functions.
generate_file_path(dir, files_to_load, file_names, page_breaks)
# add_anchor_tag_to_files(files_to_load, page_breaks)
table_of_contents = generate_table_of_contents(file_names, address)
combine_toc_and_elements(address, final_contract, files_to_load, table_of_contents)
add_anchor_tags(address, page_breaks)


# clean up unnecessary, placeholder files.
File.delete('table_of_contents.pdf')
# File.delete('temp_file.pdf')




