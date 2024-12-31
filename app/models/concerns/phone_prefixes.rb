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
    zimbabwe: { code: 160, prefix: "+263" },
    nan: { code: 999, prefix: "+000" }
  }.freeze

  module CountryPrefixes
    COUNTRIES = {
      "AF" => { code: 0, name: :afghanistan, prefix: "+93" },
      "AL" => { code: 1, name: :albania, prefix: "+355" },
      "DZ" => { code: 2, name: :algeria, prefix: "+213" },
      "AD" => { code: 3, name: :andorra, prefix: "+376" },
      "AO" => { code: 4, name: :angola, prefix: "+244" },
      "AR" => { code: 5, name: :argentina, prefix: "+54" },
      "AM" => { code: 6, name: :armenia, prefix: "+374" },
      "AU" => { code: 7, name: :australia, prefix: "+61" },
      "AT" => { code: 8, name: :austria, prefix: "+43" },
      "AZ" => { code: 9, name: :azerbaijan, prefix: "+994" },
      "BH" => { code: 10, name: :bahrain, prefix: "+973" },
      "BD" => { code: 11, name: :bangladesh, prefix: "+880" },
      "BY" => { code: 12, name: :belarus, prefix: "+375" },
      "BE" => { code: 13, name: :belgium, prefix: "+32" },
      "BZ" => { code: 14, name: :belize, prefix: "+501" },
      "BJ" => { code: 15, name: :benin, prefix: "+229" },
      "BT" => { code: 16, name: :bhutan, prefix: "+975" },
      "BO" => { code: 17, name: :bolivia, prefix: "+591" },
      "BA" => { code: 18, name: :bosnia, prefix: "+387" },
      "BW" => { code: 19, name: :botswana, prefix: "+267" },
      "BR" => { code: 20, name: :brazil, prefix: "+55" },
      "BN" => { code: 21, name: :brunei, prefix: "+673" },
      "BG" => { code: 22, name: :bulgaria, prefix: "+359" },
      "BF" => { code: 23, name: :burkina_faso, prefix: "+226" },
      "BI" => { code: 24, name: :burundi, prefix: "+257" },
      "KH" => { code: 25, name: :cambodia, prefix: "+855" },
      "CM" => { code: 26, name: :cameroon, prefix: "+237" },
      "CA" => { code: 27, name: :canada, prefix: "+1" },
      "CV" => { code: 28, name: :cape_verde, prefix: "+238" },
      "CF" => { code: 29, name: :central_african_republic, prefix: "+236" },
      "TD" => { code: 30, name: :chad, prefix: "+235" },
      "CL" => { code: 31, name: :chile, prefix: "+56" },
      "CN" => { code: 32, name: :china, prefix: "+86" },
      "CO" => { code: 33, name: :colombia, prefix: "+57" },
      "KM" => { code: 34, name: :comoros, prefix: "+269" },
      "CG" => { code: 35, name: :congo, prefix: "+242" },
      "CR" => { code: 36, name: :costa_rica, prefix: "+506" },
      "HR" => { code: 37, name: :croatia, prefix: "+385" },
      "CU" => { code: 38, name: :cuba, prefix: "+53" },
      "CY" => { code: 39, name: :cyprus, prefix: "+357" },
      "CZ" => { code: 40, name: :czech_republic, prefix: "+420" },
      "DK" => { code: 41, name: :denmark, prefix: "+45" },
      "DJ" => { code: 42, name: :djibouti, prefix: "+253" },
      "DO" => { code: 43, name: :dominican_republic, prefix: "+1" },
      "EC" => { code: 44, name: :ecuador, prefix: "+593" },
      "EG" => { code: 45, name: :egypt, prefix: "+20" },
      "SV" => { code: 46, name: :el_salvador, prefix: "+503" },
      "EE" => { code: 47, name: :estonia, prefix: "+372" },
      "ET" => { code: 48, name: :ethiopia, prefix: "+251" },
      "FJ" => { code: 49, name: :fiji, prefix: "+679" },
      "FI" => { code: 50, name: :finland, prefix: "+358" },
      "FR" => { code: 51, name: :france, prefix: "+33" },
      "GA" => { code: 52, name: :gabon, prefix: "+241" },
      "GE" => { code: 53, name: :georgia, prefix: "+995" },
      "DE" => { code: 54, name: :germany, prefix: "+49" },
      "GH" => { code: 55, name: :ghana, prefix: "+233" },
      "GR" => { code: 56, name: :greece, prefix: "+30" },
      "GT" => { code: 57, name: :guatemala, prefix: "+502" },
      "GN" => { code: 58, name: :guinea, prefix: "+224" },
      "HT" => { code: 59, name: :haiti, prefix: "+509" },
      "HN" => { code: 60, name: :honduras, prefix: "+504" },
      "HK" => { code: 61, name: :hong_kong, prefix: "+852" },
      "HU" => { code: 62, name: :hungary, prefix: "+36" },
      "IS" => { code: 63, name: :iceland, prefix: "+354" },
      "IN" => { code: 64, name: :india, prefix: "+91" },
      "ID" => { code: 65, name: :indonesia, prefix: "+62" },
      "IR" => { code: 66, name: :iran, prefix: "+98" },
      "IQ" => { code: 67, name: :iraq, prefix: "+964" },
      "IE" => { code: 68, name: :ireland, prefix: "+353" },
      "IL" => { code: 69, name: :israel, prefix: "+972" },
      "IT" => { code: 70, name: :italy, prefix: "+39" },
      "JM" => { code: 71, name: :jamaica, prefix: "+1" },
      "JP" => { code: 72, name: :japan, prefix: "+81" },
      "JO" => { code: 73, name: :jordan, prefix: "+962" },
      "KZ" => { code: 74, name: :kazakhstan, prefix: "+7" },
      "KE" => { code: 75, name: :kenya, prefix: "+254" },
      "KW" => { code: 76, name: :kuwait, prefix: "+965" },
      "KG" => { code: 77, name: :kyrgyzstan, prefix: "+996" },
      "LA" => { code: 78, name: :laos, prefix: "+856" },
      "LV" => { code: 79, name: :latvia, prefix: "+371" },
      "LB" => { code: 80, name: :lebanon, prefix: "+961" },
      "LS" => { code: 81, name: :lesotho, prefix: "+266" },
      "LR" => { code: 82, name: :liberia, prefix: "+231" },
      "LY" => { code: 83, name: :libya, prefix: "+218" },
      "LI" => { code: 84, name: :liechtenstein, prefix: "+423" },
      "LT" => { code: 85, name: :lithuania, prefix: "+370" },
      "LU" => { code: 86, name: :luxembourg, prefix: "+352" },
      "MG" => { code: 87, name: :madagascar, prefix: "+261" },
      "MW" => { code: 88, name: :malawi, prefix: "+265" },
      "MY" => { code: 89, name: :malaysia, prefix: "+60" },
      "MV" => { code: 90, name: :maldives, prefix: "+960" },
      "ML" => { code: 91, name: :mali, prefix: "+223" },
      "MT" => { code: 92, name: :malta, prefix: "+356" },
      "MR" => { code: 93, name: :mauritania, prefix: "+222" },
      "MU" => { code: 94, name: :mauritius, prefix: "+230" },
      "MX" => { code: 95, name: :mexico, prefix: "+52" },
      "MD" => { code: 96, name: :moldova, prefix: "+373" },
      "MC" => { code: 97, name: :monaco, prefix: "+377" },
      "MN" => { code: 98, name: :mongolia, prefix: "+976" },
      "ME" => { code: 99, name: :montenegro, prefix: "+382" },
      "MA" => { code: 100, name: :morocco, prefix: "+212" },
      "MZ" => { code: 101, name: :mozambique, prefix: "+258" },
      "MM" => { code: 102, name: :myanmar, prefix: "+95" },
      "NA" => { code: 103, name: :namibia, prefix: "+264" },
      "NP" => { code: 104, name: :nepal, prefix: "+977" },
      "NL" => { code: 105, name: :netherlands, prefix: "+31" },
      "NZ" => { code: 106, name: :new_zealand, prefix: "+64" },
      "NI" => { code: 107, name: :nicaragua, prefix: "+505" },
      "NE" => { code: 108, name: :niger, prefix: "+227" },
      "NG" => { code: 109, name: :nigeria, prefix: "+234" },
      "KP" => { code: 110, name: :north_korea, prefix: "+850" },
      "NO" => { code: 111, name: :norway, prefix: "+47" },
      "OM" => { code: 112, name: :oman, prefix: "+968" },
      "PK" => { code: 113, name: :pakistan, prefix: "+92" },
      "PS" => { code: 114, name: :palestine, prefix: "+970" },
      "PA" => { code: 115, name: :panama, prefix: "+507" },
      "PG" => { code: 116, name: :papua_new_guinea, prefix: "+675" },
      "PY" => { code: 117, name: :paraguay, prefix: "+595" },
      "PE" => { code: 118, name: :peru, prefix: "+51" },
      "PH" => { code: 119, name: :philippines, prefix: "+63" },
      "PL" => { code: 120, name: :poland, prefix: "+48" },
      "PT" => { code: 121, name: :portugal, prefix: "+351" },
      "QA" => { code: 122, name: :qatar, prefix: "+974" },
      "RO" => { code: 123, name: :romania, prefix: "+40" },
      "RU" => { code: 124, name: :russia, prefix: "+7" },
      "RW" => { code: 125, name: :rwanda, prefix: "+250" },
      "SA" => { code: 126, name: :saudi_arabia, prefix: "+966" },
      "SN" => { code: 127, name: :senegal, prefix: "+221" },
      "RS" => { code: 128, name: :serbia, prefix: "+381" },
      "SG" => { code: 129, name: :singapore, prefix: "+65" },
      "SK" => { code: 130, name: :slovakia, prefix: "+421" },
      "SI" => { code: 131, name: :slovenia, prefix: "+386" },
      "SO" => { code: 132, name: :somalia, prefix: "+252" },
      "ZA" => { code: 133, name: :south_africa, prefix: "+27" },
      "KR" => { code: 134, name: :south_korea, prefix: "+82" },
      "ES" => { code: 135, name: :spain, prefix: "+34" },
      "LK" => { code: 136, name: :sri_lanka, prefix: "+94" },
      "SD" => { code: 137, name: :sudan, prefix: "+249" },
      "SE" => { code: 138, name: :sweden, prefix: "+46" },
      "CH" => { code: 139, name: :switzerland, prefix: "+41" },
      "SY" => { code: 140, name: :syria, prefix: "+963" },
      "TW" => { code: 141, name: :taiwan, prefix: "+886" },
      "TJ" => { code: 142, name: :tajikistan, prefix: "+992" },
      "TZ" => { code: 143, name: :tanzania, prefix: "+255" },
      "TH" => { code: 144, name: :thailand, prefix: "+66" },
      "TG" => { code: 145, name: :togo, prefix: "+228" },
      "TN" => { code: 146, name: :tunisia, prefix: "+216" },
      "TR" => { code: 147, name: :turkey, prefix: "+90" },
      "TM" => { code: 148, name: :turkmenistan, prefix: "+993" },
      "UG" => { code: 149, name: :uganda, prefix: "+256" },
      "UA" => { code: 150, name: :ukraine, prefix: "+380" },
      "AE" => { code: 151, name: :united_arab_emirates, prefix: "+971" },
      "GB" => { code: 152, name: :united_kingdom, prefix: "+44" },
      "US" => { code: 153, name: :united_states, prefix: "+1" },
      "UY" => { code: 154, name: :uruguay, prefix: "+598" },
      "UZ" => { code: 155, name: :uzbekistan, prefix: "+998" },
      "VE" => { code: 156, name: :venezuela, prefix: "+58" },
      "VN" => { code: 157, name: :vietnam, prefix: "+84" },
      "YE" => { code: 158, name: :yemen, prefix: "+967" },
      "ZM" => { code: 159, name: :zambia, prefix: "+260" },
      "ZW" => { code: 160, name: :zimbabwe, prefix: "+263" },
      "NAN" => { code: 999, name: :nan, prefix: "+000" }
    }.freeze
  end

  included do
    enum :phone_prefix, PHONE_PREFIXES.transform_values { |v| v[:code] }.stringify_keys
  end

  def phone_prefix_with_plus
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
