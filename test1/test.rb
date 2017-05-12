require 'combine_pdf'

pdf = CombinePDF.new
dir = "./123_Main"

files_to_load = [ "#{dir}/Alameda-County-DD-102016_ts28356.pdf",
                  "#{dir}/Electronic_Signature_Advisory_ts26794.pdf",
                  "#{dir}/Agent_Visual_Inspection_Disclosure_1_-_1113_ts26794.pdf",
                  "#{dir}/Homeowners_Booklet_Receipt_with_Links_ts28356.pdf",
                  "#{dir}/Lead_Paint_Supplemental_Disclosure-1_ts28356.pdf",
                  "#{dir}/Lead-Based_Paint_and_Lead-Based_Paint_Hazards_-_1110_ts26794.pdf",
                  "#{dir}/Market_Conditions_Advisory_-_1111_ts26794.pdf",
                  "#{dir}/Real_Estate_Transfer_Disclosure_Statement_-_414_ts26794.pdf",
                  "#{dir}/Residential_Earthquake_Hazards_Report_ts26794.pdf",
                  "#{dir}/Seller_Property_Questionnaire_-_1216_ts26794.pdf",
                  "#{dir}/Statewide_Buyer_and_Seller_Advisory_-_116_ts26794.pdf",
                  "#{dir}/Verification_of_Property_Condition_-_407_ts26794.pdf",
                  "#{dir}/Water_Conservation_Plumbing_Fixture_Advisory_for_Sellers_Buyers_ts08946_ts28356.pdf",
                  "#{dir}/Water_Heater_and_Smoke_Detector_Statement_of_Compliance_-_1110_ts28356.pdf",
                  "#{dir}/Wire_Fraud_Advisory_-_616_ts28356.pdf" ]

files_to_load.each do |file|
  pdf << CombinePDF.load(file)
end

pdf.save "combined.pdf"