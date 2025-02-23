# app/services/pdf_generator_service.rb
require "prawn"

class PdfGeneratorService
 BACKGROUND_IMAGE = Rails.root.join("app/assets/images/background.png")
 FONTS_PATH = Rails.root.join("app/assets/fonts")

 TRANSLATIONS = {
   header: {
     en: "Certificate of Tree Planting",
     nl: "Certificaat van boomplanting"
   },
   details: {
     trees_planted: {
       en: "Number of trees planted:",
       nl: "Aantal bomen geplant:"
     },
     tree_type: {
       en: "Tree type:",
       nl: "Boomtype:"
     },
     tree_name: {
       en: "Your tree name and code:",
       nl: "Jouw boomnaam en code:"
     },
     co2_compensation: {
       en: "CO₂ compensation:",
       nl: "CO₂-compensatie:"
     },
     planting_location: {
       en: "Planting location:",
       nl: "Plantlocatie:"
     },
     gps_coordinates: {
       en: "GPS coordinates:",
       nl: "GPS-coördinaten:"
     }
   },
   impact_message: {
     en: "With this contribution you not only help reduce CO₂ emissions, but you also support local communities in Sierra Leone. Your tree helps with reforestation, biodiversity restoration and sustainable employment for farmers.",
     nl: "Met deze bijdrage draag je niet alleen bij aan de vermindering van CO₂-uitstoot, maar ondersteun je ook lokale gemeenschappen in Sierra Leone. Jouw boom helpt bij herbebossing, biodiversiteitsherstel en duurzame werkgelegenheid voor boeren."
   },
   footer: {
     more_info: {
       en: "More information:",
       nl: "Meer informatie:"
     },
     website: "www.planteenboom.nu",
     hero_message: {
       en: "Thank you for being a Forest Hero!",
       nl: "Dank je wel dat je een Forest Hero bent!"
     },
     qr_code: {
      en:  "Scan the QR code on your certificate and enter your email\naddress to view your tree location in Google Maps.",
      nl: "Scan de QR-code op je certificaat en vul je e-mailadres \nim om jouw boomlocatie in Google Maps te bekijken."
    }
   },
   signature: {
    greeting: {
      en: "Kind regards,",
      nl: "Hartelijke groet,"
    },
    name: {
      en: "Dr. E.K.S. Hanson",
      nl: "Dr. E.K.S. Hanson"
    },
    title: {
      en: "Founder of Plant N Boom",
      nl: "oprichter Plant N Boom"
    }
  }
 }

 TEXT_POSITIONS = {
  header: { x: 200, y: 1080 },
  greeting: { x: 80, y: 1025 },
  congratulations: { x: 80, y: 960 },
  details_block: { x: 90, y: 870 },
  detail_line_height: 35, 
  impact_message: { x: 80, y: 650 },
  
  signature: {
    text: { x: 80, y: 550 },
    name: { x: 80, y: 520 },
    title: { x: 80, y: 490 },
    date: { x: 80, y: 385 }
  },
  
  map_instruction: { x: 230, y: 455 },
  map_detail: { x: 40, y: 290 },      # "Scan de QR-code..."
  qr_code: { x: 700, y: 320 },        # QR code position
  
  footer: {
    link: { x: 150, y: 230 },          # "Meer informatie..."
    hero_message: { x: 80, y: 140 },
    qr_code: { x: 200, y: 420 }
  }
}

 def initialize(language = :nl)
   @pdf = Prawn::Document.new(
     page_size: "A3",
     margin: 0,
     info: { encoding: 'UTF-8' }
   )
   @language = language
   setup_fonts
   add_background_image
 end

 def setup_fonts
  font_families = {
    "Roboto" => {
      normal: "#{FONTS_PATH}/Roboto-Regular.ttf",
      bold: "#{FONTS_PATH}/Roboto-Bold.ttf"
    }
  }
  @pdf.font_families.update(font_families)
  @pdf.font("Roboto")
  end

  def generate(data)
    add_header
    add_greeting(data)
    add_details(data)
    add_impact_message
    add_signature
    add_map_instructions(data)
    add_footer

    filename = "certificate_#{Time.current.to_i}.pdf"
    filename = "certificate.pdf"

    @pdf.render_file(Rails.root.join("tmp", filename))
    filename
 end

 private

 def add_background_image
   if File.exist?(BACKGROUND_IMAGE)
     @pdf.image(BACKGROUND_IMAGE,
       width: @pdf.bounds.width,
       height: @pdf.bounds.height,
       position: :center,
       vposition: :center)
   else
     @pdf.fill_color("88CC88")
     @pdf.fill_rectangle([ 0, @pdf.bounds.height ],
       @pdf.bounds.width, @pdf.bounds.height)
     @pdf.fill_color("000000")
   end
 end

 def add_header
   add_text(TRANSLATIONS[:header][@language], { size: 36, at: [ TEXT_POSITIONS[:header][:x], TEXT_POSITIONS[:header][:y] ], style: :bold })
 end

 def add_greeting(data)
   greeting = "Beste #{data[:first_name]} #{data[:last_name]},"
   add_text(greeting, { size: 24, at: [ TEXT_POSITIONS[:greeting][:x], TEXT_POSITIONS[:greeting][:y] ] })

   congratulations = "Gefeliciteerd! Je hebt bijgedragen aan een groenere planeet door een boom te planten via Plant N Boom."
   add_text(congratulations, { size: 20, at: [ TEXT_POSITIONS[:congratulations][:x], TEXT_POSITIONS[:congratulations][:y] ], width: 600 })
 end

 def add_details(data)
   details = [
     "•  #{TRANSLATIONS[:details][:trees_planted][@language]} #{data[:trees_planted]}",
     "•  #{TRANSLATIONS[:details][:tree_type][@language]} #{data[:tree_type]}",
     "•  #{TRANSLATIONS[:details][:tree_name][@language]} #{data[:tree_name]} - #{data[:tree_code]}",
     "•  #{TRANSLATIONS[:details][:co2_compensation][@language]} #{data[:co2_amount]} ton per jaar",
     "•  #{TRANSLATIONS[:details][:planting_location][@language]} #{data[:forest_area]}",
     "•  #{TRANSLATIONS[:details][:gps_coordinates][@language]} #{data[:gps_coords]}"
   ]

   details.each_with_index do |detail, index|
     y_position = TEXT_POSITIONS[:details_block][:y] - (index * TEXT_POSITIONS[:detail_line_height])
     add_text(detail, { size: 20, at: [ TEXT_POSITIONS[:details_block][:x], y_position ], width: 600 })
   end
 end

 def add_impact_message
   add_text(TRANSLATIONS[:impact_message][@language],
     { size: 24, at: [ TEXT_POSITIONS[:impact_message][:x], TEXT_POSITIONS[:impact_message][:y] ], width: 600,  height: 100 })
 end

 def add_signature
  pos = TEXT_POSITIONS[:signature]
  add_text(TRANSLATIONS[:signature][:greeting][@language], { size: 20, at: [pos[:text][:x], pos[:text][:y]] })
  add_text(TRANSLATIONS[:signature][:name][@language], { size: 20, at: [pos[:name][:x], pos[:name][:y]], style: :bold })
  add_text(TRANSLATIONS[:signature][:title][@language], { size: 20, at: [pos[:title][:x], pos[:title][:y]] })
  add_text(Time.current.strftime("%d/%m/%Y"), { size: 20, at: [pos[:date][:x], pos[:date][:y]] })
end

 def add_map_instructions(data)
   pos = TEXT_POSITIONS[:map_instruction]
   add_text("Vind jouw boom op de kaart!", { size: 16, at: [ pos[:x], pos[:y] ], style: :bold })

   # Add QR code here if you have the QR code functionality
 end

 def add_footer
   pos = TEXT_POSITIONS[:footer]
   add_text("#{TRANSLATIONS[:footer][:more_info][@language]} #{TRANSLATIONS[:footer][:website]}",
     { size: 36, at: [ pos[:link][:x], pos[:link][:y] ],  height: 150 })
   add_text(TRANSLATIONS[:footer][:hero_message][@language],
     { size: 16, at: [ pos[:hero_message][:x], pos[:hero_message][:y] ] })
     add_text(TRANSLATIONS[:footer][:qr_code][@language],
      { size: 16, at: [ pos[:qr_code][:x], pos[:qr_code][:y] ] })
 end

 def add_text(text, options = {})
    default_options = {
      size: 24,
      align: :left,
      width: @pdf.bounds.width - 80,
      color: "FF0000"
    }

    options = default_options.merge(options)
    text_color = options.delete(:color)
    font_style = options.delete(:style) || :normal

    original_color = @pdf.fill_color
    @pdf.fill_color = text_color
    @pdf.font("Roboto", style: font_style) do
      @pdf.text_box(text,
        width: options[:width],
        height: options[:height] || 50,
        overflow: :shrink_to_fit,
        **options)
    end
    @pdf.fill_color = original_color
  end
end
