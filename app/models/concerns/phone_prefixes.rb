module PhonePrefixes
  extend ActiveSupport::Concern

  PHONE_PREFIXES = {
    afghanistan: { code: 0, prefix: "+93" },
    albania: { code: 1, prefix: "+355" },
    algeria: { code: 2, prefix: "+213" },
    andorra: { code: 3, prefix: "+376" },
    angola: { code: 4, prefix: "+244" },
    argentina: { code: 5, prefix: "+54" },
    armenia: { code: 6, prefix: "+374" },
    australia: { code: 7, prefix: "+61" },
    austria: { code: 8, prefix: "+43" },
    azerbaijan: { code: 9, prefix: "+994" },
    bahrain: { code: 10, prefix: "+973" },
    bangladesh: { code: 11, prefix: "+880" },
    belarus: { code: 12, prefix: "+375" },
    belgium: { code: 13, prefix: "+32" },
    belize: { code: 14, prefix: "+501" },
    benin: { code: 15, prefix: "+229" },
    bhutan: { code: 16, prefix: "+975" },
    bolivia: { code: 17, prefix: "+591" },
    bosnia: { code: 18, prefix: "+387" },
    botswana: { code: 19, prefix: "+267" },
    brazil: { code: 20, prefix: "+55" },
    brunei: { code: 21, prefix: "+673" },
    bulgaria: { code: 22, prefix: "+359" },
    burkina_faso: { code: 23, prefix: "+226" },
    burundi: { code: 24, prefix: "+257" },
    cambodia: { code: 25, prefix: "+855" },
    cameroon: { code: 26, prefix: "+237" },
    canada: { code: 27, prefix: "+1" },
    cape_verde: { code: 28, prefix: "+238" },
    central_african_republic: { code: 29, prefix: "+236" },
    chad: { code: 30, prefix: "+235" },
    chile: { code: 31, prefix: "+56" },
    china: { code: 32, prefix: "+86" },
    colombia: { code: 33, prefix: "+57" },
    comoros: { code: 34, prefix: "+269" },
    congo: { code: 35, prefix: "+242" },
    costa_rica: { code: 36, prefix: "+506" },
    croatia: { code: 37, prefix: "+385" },
    cuba: { code: 38, prefix: "+53" },
    cyprus: { code: 39, prefix: "+357" },
    czech_republic: { code: 40, prefix: "+420" },
    denmark: { code: 41, prefix: "+45" },
    djibouti: { code: 42, prefix: "+253" },
    dominican_republic: { code: 43, prefix: "+1" },
    ecuador: { code: 44, prefix: "+593" },
    egypt: { code: 45, prefix: "+20" },
    el_salvador: { code: 46, prefix: "+503" },
    estonia: { code: 47, prefix: "+372" },
    ethiopia: { code: 48, prefix: "+251" },
    fiji: { code: 49, prefix: "+679" },
    finland: { code: 50, prefix: "+358" },
    france: { code: 51, prefix: "+33" },
    gabon: { code: 52, prefix: "+241" },
    georgia: { code: 53, prefix: "+995" },
    germany: { code: 54, prefix: "+49" },
    ghana: { code: 55, prefix: "+233" },
    greece: { code: 56, prefix: "+30" },
    guatemala: { code: 57, prefix: "+502" },
    guinea: { code: 58, prefix: "+224" },
    haiti: { code: 59, prefix: "+509" },
    honduras: { code: 60, prefix: "+504" },
    hong_kong: { code: 61, prefix: "+852" },
    hungary: { code: 62, prefix: "+36" },
    iceland: { code: 63, prefix: "+354" },
    india: { code: 64, prefix: "+91" },
    indonesia: { code: 65, prefix: "+62" },
    iran: { code: 66, prefix: "+98" },
    iraq: { code: 67, prefix: "+964" },
    ireland: { code: 68, prefix: "+353" },
    israel: { code: 69, prefix: "+972" },
    italy: { code: 70, prefix: "+39" },
    jamaica: { code: 71, prefix: "+1" },
    japan: { code: 72, prefix: "+81" },
    jordan: { code: 73, prefix: "+962" },
    kazakhstan: { code: 74, prefix: "+7" },
    kenya: { code: 75, prefix: "+254" },
    kuwait: { code: 76, prefix: "+965" },
    kyrgyzstan: { code: 77, prefix: "+996" },
    laos: { code: 78, prefix: "+856" },
    latvia: { code: 79, prefix: "+371" },
    lebanon: { code: 80, prefix: "+961" },
    lesotho: { code: 81, prefix: "+266" },
    liberia: { code: 82, prefix: "+231" },
    libya: { code: 83, prefix: "+218" },
    liechtenstein: { code: 84, prefix: "+423" },
    lithuania: { code: 85, prefix: "+370" },
    luxembourg: { code: 86, prefix: "+352" },
    madagascar: { code: 87, prefix: "+261" },
    malawi: { code: 88, prefix: "+265" },
    malaysia: { code: 89, prefix: "+60" },
    maldives: { code: 90, prefix: "+960" },
    mali: { code: 91, prefix: "+223" },
    malta: { code: 92, prefix: "+356" },
    mauritania: { code: 93, prefix: "+222" },
    mauritius: { code: 94, prefix: "+230" },
    mexico: { code: 95, prefix: "+52" },
    moldova: { code: 96, prefix: "+373" },
    monaco: { code: 97, prefix: "+377" },
    mongolia: { code: 98, prefix: "+976" },
    montenegro: { code: 99, prefix: "+382" },
    morocco: { code: 100, prefix: "+212" },
    mozambique: { code: 101, prefix: "+258" },
    myanmar: { code: 102, prefix: "+95" },
    namibia: { code: 103, prefix: "+264" },
    nepal: { code: 104, prefix: "+977" },
    netherlands: { code: 105, prefix: "+31" },
    new_zealand: { code: 106, prefix: "+64" },
    nicaragua: { code: 107, prefix: "+505" },
    niger: { code: 108, prefix: "+227" },
    nigeria: { code: 109, prefix: "+234" },
    north_korea: { code: 110, prefix: "+850" },
    norway: { code: 111, prefix: "+47" },
    oman: { code: 112, prefix: "+968" },
    pakistan: { code: 113, prefix: "+92" },
    palestine: { code: 114, prefix: "+970" },
    panama: { code: 115, prefix: "+507" },
    papua_new_guinea: { code: 116, prefix: "+675" },
    paraguay: { code: 117, prefix: "+595" },
    peru: { code: 118, prefix: "+51" },
    philippines: { code: 119, prefix: "+63" },
    poland: { code: 120, prefix: "+48" },
    portugal: { code: 121, prefix: "+351" },
    qatar: { code: 122, prefix: "+974" },
    romania: { code: 123, prefix: "+40" },
    russia: { code: 124, prefix: "+7" },
    rwanda: { code: 125, prefix: "+250" },
    saudi_arabia: { code: 126, prefix: "+966" },
    senegal: { code: 127, prefix: "+221" },
    serbia: { code: 128, prefix: "+381" },
    singapore: { code: 129, prefix: "+65" },
    slovakia: { code: 130, prefix: "+421" },
    slovenia: { code: 131, prefix: "+386" },
    somalia: { code: 132, prefix: "+252" },
    south_africa: { code: 133, prefix: "+27" },
    south_korea: { code: 134, prefix: "+82" },
    spain: { code: 135, prefix: "+34" },
    sri_lanka: { code: 136, prefix: "+94" },
    sudan: { code: 137, prefix: "+249" },
    sweden: { code: 138, prefix: "+46" },
    switzerland: { code: 139, prefix: "+41" },
    syria: { code: 140, prefix: "+963" },
    taiwan: { code: 141, prefix: "+886" },
    tajikistan: { code: 142, prefix: "+992" },
    tanzania: { code: 143, prefix: "+255" },
    thailand: { code: 144, prefix: "+66" },
    togo: { code: 145, prefix: "+228" },
    tunisia: { code: 146, prefix: "+216" },
    turkey: { code: 147, prefix: "+90" },
    turkmenistan: { code: 148, prefix: "+993" },
    uganda: { code: 149, prefix: "+256" },
    ukraine: { code: 150, prefix: "+380" },
    united_arab_emirates: { code: 151, prefix: "+971" },
    united_kingdom: { code: 152, prefix: "+44" },
    united_states: { code: 153, prefix: "+1" },
    uruguay: { code: 154, prefix: "+598" },
    uzbekistan: { code: 155, prefix: "+998" },
    venezuela: { code: 156, prefix: "+58" },
    vietnam: { code: 157, prefix: "+84" },
    yemen: { code: 158, prefix: "+967" },
    zambia: { code: 159, prefix: "+260" },
    zimbabwe: { code: 160, prefix: "+263" }
  }.freeze

  included do
    enum phone_prefix: PHONE_PREFIXES.transform_values { |v| v[:code] }
  end

  def self.phone_prefix_with_plus
    PHONE_PREFIXES[phone_prefix.to_sym][:prefix]
  end

  def full_phone
    cleaned_phone = phone.start_with?("0") ? phone[1..-1] : phone
    "(#{phone_prefix_with_plus}) #{cleaned_phone}"
  end

  module ClassMethods
    def prefix_for_code(code)
      country = PHONE_PREFIXES.find { |_key, value| value[:code] == code }
      country ? country.last[:prefix] : nil
    end

    def code_for_prefix(prefix)
      country = PHONE_PREFIXES.find { |_key, value| value[:prefix] == prefix }
      country ? country.last[:code] : nil
    end

    def country_for_code(code)
      country = PHONE_PREFIXES.find { |_key, value| value[:code] == code }
      country ? country.first : nil
    end

    def all_prefixes
      PHONE_PREFIXES.map { |country, data| { country: country, code: data[:code], prefix: data[:prefix] } }
    end

    def format_phone(prefix, phone)
      prefix_value = PHONE_PREFIXES[prefix.to_sym][:prefix]
      cleaned_phone = phone.start_with?("0") ? phone[1..-1] : phone
      "(#{prefix_value}) #{cleaned_phone}"
    end
  end
end
