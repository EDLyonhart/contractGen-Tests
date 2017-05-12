#
# executed thusly : ruby test.rb Eli_Lyonhart 123_Main
# this is designed for a file structure reading:
# ./{client-name}/{property-address}/{collection-of-pdfs}
#

require 'combine_pdf'
require 'prawn'
require 'prawn/table'

pdf = CombinePDF.new
client = ARGV[0]
address = ARGV[1]

file_names, files_to_load = Array.new, Array.new
dir = "./#{client}/#{address}"

# ------------
# find every file in named directory. format with path and pdf file name
# ------------
def generate_file_path(dir, files_to_load)
  Dir.foreach(dir) do |fname|
    unless fname == '.' || fname == '..'
      files_to_load << "./#{dir}/#{fname}"
    end
  end
end

# ------------
# create table of contents
# ------------
def generate_table_of_contents(file_names)
  Prawn::Document.generate("table_of_contents", page_layout: :portrait) do
    file_names.each do |file|
      text "<link anchor=#{file}>#{file}</link>", inline_format: true
    end
    start_new_page

    file_names.each do |file|

      #
      # figure out how to get body. in examnple it is being generated on the spot. in my case, it needs to be loaded from 'files_to_load' array
      #
      
      table body do |t|
        t.before_rendering_page do |cells|
          cells.each do |cell|
            if cell.content == file
              add_dest(cell.content, dest_xyz(bounds.absolute_left, y))
            end
          end
        end
      end
    end
  end

  # Prawn::Document.generate("linked.pdf", page_layout: :landscape) do
  #   text '<link anchor="hello30">Click me</link>', inline_format: true
  #   start_new_page

  #   body = (1..50).map do |i|
  #     ["hello#{i}", "some info about hello#{i}"]
  #   end

  #   table body do |t|
  #     t.before_rendering_page do |cells|
  #       cells.each do |cell|
  #         if cell.content == "hello30"
  #           add_dest(cell.content, dest_xyz(bounds.absolute_left, y))
  #         end
  #       end
  #     end
  #   end
  # end
end

def get_file_names(dir, file_names)
  Dir.foreach(dir) do |fname|
    unless fname == '.' || fname == '..'
      file_names << fname
    end
  end

  generate_table_of_contents(file_names)
end

# ------------
# add each file to pdf
# ------------
def create_final_contract(file_names, files_to_load)
  pdf << generate_table_of_contents(file_names)
  files_to_load.each do |file|
    pdf << CombinePDF.load(file)
  end
end

#
# output combined pdf
#
get_file_names(dir, file_names)
generate_file_path(dir, files_to_load)
create_final_contract(file_names, files_to_load)
pdf.save "combined.pdf"