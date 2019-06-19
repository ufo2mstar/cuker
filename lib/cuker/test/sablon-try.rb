# require "sablon"
# # template = Sablon.template(File.expand_path("./template.docx"))
# # context = {
# #     title: "Fabulous Document",
# #     technologies: ["Ruby", "HTML", "ODF"]
# # }
# # template.render_to_file File.expand_path("./output.docx"), context
#
# word_processing_ml = <<-XML.gsub("\n", "")
# <w:p>
# <w:r w:rsidRPr="00B97C39">
# <w:rPr>
# <w:b />
# </w:rPr>
# <w:t>this is bold text</w:t>
# </w:r>
# </w:p>
# XML
# context = {
#     long_description: Sablon.content(:word_ml, word_processing_ml)
# }
# # template.render_to_file File.expand_path("~/Desktop/output.docx"), context
#
# template.render_to_file File.expand_path("./output.docx"), context