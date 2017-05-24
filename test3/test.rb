#
# executed thusly : ruby test.rb Eli_Lyonhart 123_Main
# this is designed for a file structure reading:
# ./{client-name}/{property-address}/{collection-of-pdfs}
#

require 'combine_pdf'
require 'prawn'
require 'prawn/table'

# arguments to locate all applicable files
client = ARGV[0]
address = ARGV[1]
dir = "./#{client}/#{address}"

# initialize two .pdf files for later use
table_of_contents = Prawn::Document.new
final_contract = CombinePDF.new

file_names, files_to_load = Array.new, Array.new

# ------------
# find every file in named directory. format with path and pdf file name
# insert into array 'files_to_load'
# ------------
def generate_file_path(dir, files_to_load)
  Dir.foreach(dir) do |fname|
    unless fname == '.' || fname == '..'
      files_to_load << "./#{dir}/#{fname}"
    end
  end
end

# ------------
# get all file names
# insert into array file_names
# ------------
def get_file_names(dir, file_names)
  Dir.foreach(dir) do |fname|
    unless fname == '.' || fname == '..'
      file_names << fname
    end
  end
end

# ------------
# create table of contents
# - create hash out of files
#   - Index + 1
#   - Name of file - '.pdf'
# ------------
def generate_table_of_contents(table_of_contents, file_names)

  contents_hash = Hash.new
  file_names.each_with_index do |val,index|
    contents_hash[index+1] = val[0..-5]
  end

  table_of_contents.table(contents_hash) do |table|
    table.rows(file_names.length)
  end

  table_of_contents.render_file "table_of_contents.pdf"

 #  contents_hash = Hash.new

 # # add anchor tag to each element
 #  file_names.each_with_index do |val,index|
 #    contents_hash[index+1] = table_of_contents.add_dest(val, 6)
 #  end

 #  p contents_hash[1].class

 #  # table_of_contents.table(contents_hash) do |table|
 #  #   table.rows(contents_hash.length)
 #  # end

 #  table_of_contents.render_file "table_of_contents.pdf"

end


# ------------
# add table of contents and each file to pdf
# ------------
def create_final_contract(address, final_contract, files_to_load, table_of_contents)
  files_to_load.unshift("table_of_contents.pdf")
  files_to_load.each do |file|

    final_contract << CombinePDF.load(file)
  end

  final_contract.save "#{address}_final_contract.pdf"
end

get_file_names(dir, file_names)
generate_file_path(dir, files_to_load)
generate_table_of_contents(table_of_contents, file_names)
create_final_contract(address, final_contract, files_to_load, table_of_contents)
