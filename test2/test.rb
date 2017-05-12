#
# executed thusly : ruby test.rb Eli_Lyonhart 123_Main
# this is designed for a file structure reading:
# ./{client-name}/{property-address}/{collection-of-pdfs}
#

require 'combine_pdf'

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
# add each file to pdf
# ------------
files_to_load.each do |file|
      pdf << CombinePDF.load(file)
end

#
# output combined pdf
#
generate_table_of_contents(dir, file_names)
generate_file_path(dir, files_to_load)
pdf.save "combined.pdf"