//
//  Countries.swift
//  verify-ios-test-app
//
//  Created by Dorian Peake on 29/06/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class Country {

    let countryCode : String
    let countryCodeAlpha3 : String
    let country : String
    let intPrefix : [String]
    let natPrefix : [String]
    
    init(_ countryCode: String, _ countryCodeAlpha3: String, _ country: String, _ intPrefix: [String], _ natPrefix: [String]) {
        self.countryCode = countryCode
        self.countryCodeAlpha3 = countryCodeAlpha3
        self.country = country
        self.intPrefix = intPrefix
        self.natPrefix = natPrefix
    }
    
     static let countries = [
    Country("NANP", "NANP", "North American Numbering Plan", ["1"], ["1"]),
    Country("WW", "", "World-Wide",[], ["0"]),
    Country("GB", "GBR", "United Kingdom", ["44"], ["0"]),
    Country("AF", "AFG", "Afghanistan", ["93"], ["0"]),
    Country("AL", "ALB", "Albania", ["355"], ["0"]),
    Country("DZ", "DZA", "Algeria", ["213"], ["0"]),
    Country("AS", "AMS", "American Samoa", ["1684"], ["1684"]),
    Country("AD", "AND", "Andorra", ["376"], []),
    Country("AO", "AGO", "Angola", ["244"], ["0"]),
    Country("AI", "AIA", "Anguilla", ["1264"], ["1264"]),
    Country("AQ", "ATA", "Antarctica", ["672"], []),
    Country("AG", "ATG", "Antigua / Barbuda", ["1268"], ["1268"]),
    Country("AR", "ARG", "Argentina", ["54"], ["0"]),
    Country("AM", "ARM", "Armenia", ["374"], ["0"]),
    Country("AW", "ABW", "Aruba", ["297"], []),
    Country("AC", "", "Ascension", ["247"], []),
    Country("AU", "AUS", "Australia", ["61"], ["0"]),
    Country("", "", "Australian External Territories", ["672"], ["0"]),
    Country("AT", "AUT", "Austria", ["43"], ["0"]),
    Country("AZ", "AZE", "Azerbaijan", ["994"], ["0"]),
    Country("BS", "BHS", "Bahamas", ["1242"], ["1242"]),
    Country("BH", "BHR", "Bahrain", ["973"], []),
    Country("BD", "BGD", "Bangladesh", ["880"], ["0"]),
    Country("BB", "BRB", "Barbados", ["1246"], ["1246"]),
    Country("BY", "BLR", "Belarus", ["375"], ["8"]),
    Country("BE", "BEL", "Belgium", ["32"], ["0"]),
    Country("BZ", "BLZ", "Belize", ["501"], []),
    Country("BJ", "BEN", "Benin", ["229"], []),
    Country("BM", "BMU", "Bermuda", ["1441"], ["1441"]),
    Country("BT", "BTN", "Bhutan", ["975"], []),
    Country("BO", "BOL", "Bolivia", ["591"], ["0"]),
    Country("BA", "BIH", "Bosnia & Herzegovina", ["387"], ["0"]),
    Country("BW", "BWA", "Botswana", ["267"], []),
    Country("BV", "BVT", "Bouvet Island", [], []),
    Country("BQ", "BES", "Bonaire, Sint Eustatius and Saba", ["599"], ["0"]),
    Country("BR", "BRA", "Brazil", ["55"], ["0"]),
    Country("VI", "VIR", "British Virgin Islands", ["1284"], ["1284"]),
    Country("IO", "IOT", "British Indian Ocean Territory", [], ["0"]),
    Country("BN", "BRN", "Brunei Darussalam", ["673"], []),
    Country("BG", "BGR", "Bulgaria", ["359"], ["0"]),
    Country("BF", "BFA", "Burkina Faso", ["226"], []),
    Country("BI", "BDI", "Burundi", ["257"], []),
    Country("KH", "KHM", "Cambodia", ["855"], ["0"]),
    Country("CM", "CMR", "Cameroon", ["237"], []),
    Country("CA", "CAN", "Canada", ["1"], ["1"]),
    Country("CV", "CPV", "Cape Verde Islands", ["238"], []),
    Country("KY", "CYM", "Cayman Islands", ["1345"], ["1345"]),
    Country("CF", "CAF", "Central African Republic", ["236"], []),
    Country("TD", "TCD", "Chad", ["235"], []),
    Country("CL", "CHL", "Chile", ["56"], ["0"]),
    Country("CN", "CHN", "China (PRC)", ["86"], ["0"]),
    Country("CX", "CXR", "Christmas Island", ["618"], ["0"]),
    Country("CC", "CCK", "Cocos-Keeling Islands", ["61"], ["0"]),
    Country("CO", "COL", "Colombia", ["57"], ["9"]),
    Country("KM", "COM", "Comoros", ["269"], []),
    Country("CG", "COG", "Congo", ["242"], []),
    Country("CD", "COD", "Congo, Dem. Rep. of (former Zaire)", ["243"], ["0"]),
    Country("CK", "COK", "Cook Islands", ["682"], []),
    Country("CR", "CRI", "Costa Rica", ["506"], []),
    Country("CI", "CIV", "Côte d'Ivoire (Ivory Coast)", ["225"], []),
    Country("HR", "HRV", "Croatia", ["385"], ["0"]),
    Country("CU", "CUB", "Cuba", ["53"], ["0"]),
    Country("CW", "CUW", "Curaçao", ["599"], ["0"]),
    Country("CY", "CYP", "Cyprus", ["357"], []),
    Country("CZ", "CZE", "Czech Republic", ["420"], []),
    Country("DK", "DNK", "Denmark", ["45"], []),
    Country("DG", "", "Diego Garcia", ["246"], []),
    Country("DJ", "DJI", "Djibouti", ["253"], []),
    Country("DM", "DMA", "Dominica", ["1767"], ["1767"]),
    Country("DO", "DOM", "Dominican Republic", ["1809", "1829", "1849"], ["1809", "1829", "1849"]),
    Country("TL", "TLS", "Timor-Leste", ["670"], []),
    Country("", "", "Easter Island", ["56"], []),
    Country("EC", "ECU", "Ecuador", ["593"], ["0"]),
    Country("EG", "EGY", "Egypt", ["20"], ["0"]),
    Country("EH", "ESH", "Western Sahara", ["0"], ["0"]),
    Country("SV", "SLV", "El Salvador", ["503"], []),
    Country("WW", "", "Ellipso (Mobile Satellite service)", ["8812", "8813"], []),
    Country("WW", "", "EMSAT (Mobile Satellite service)", ["88213"], [""]),
    Country("GQ", "GNQ", "Equatorial Guinea", ["240"], []),
    Country("ER", "ERI", "Eritrea", ["291"], ["0"]),
    Country("EE", "EST", "Estonia", ["372"], []),
    Country("ET", "ETH", "Ethiopia", ["251"], ["0"]),
    Country("FK", "FLK", "Falkland Islands", ["500"], []),
    Country("FO", "FRO", "Faroe Islands", ["298"], []),
    Country("FJ", "FJI", "Fiji Islands", ["679"], []),
    Country("FI", "FIN", "Finland", ["358"], ["0"]),
    Country("FR", "FRA", "France", ["33"], ["0"]),
    Country("", "", "French Antilles", ["596"], []),
    Country("GF", "GUF", "French Guiana", ["594"], []),
    Country("PF", "PYF", "French Polynesia", ["689"], []),
    Country("GA", "GAB", "Gabonese Republic", ["241"], []),
    Country("GM", "GMB", "Gambia", ["220"], []),
    Country("GE", "GEO", "Georgia", ["995"], ["8"]),
    Country("DE", "DEU", "Germany", ["49"], ["0"]),
    Country("GH", "GHA", "Ghana", ["233"], []),
    Country("GI", "GIB", "Gibraltar", ["350"], []),
    Country("WW", "", "Global Mobile Satellite System (GMSS)", ["881"], []),
    Country("WW", "", "Globalstar (Mobile Satellite Service)", ["8818", "8819"], []),
    Country("GR", "GRC", "Greece", ["30"], ["0"]),
    Country("GL", "GRL", "Greenland", ["299"], []),
    Country("GD", "GRD", "Grenada", ["1473"], ["1473"]),
    Country("GP", "GLP", "Guadeloupe", ["590"], []),
    Country("GU", "GUM", "Guam", ["1671"], ["1671"]),
    Country("", "", "Guantanamo Bay", ["5399"], ["0"]),
    Country("GT", "GTM", "Guatemala", ["502"], []),
    Country("GW", "GNB", "Guinea-Bissau", ["245"], []),
    Country("GN", "GIN", "Guinea", ["224"], []),
    Country("GY", "GUY", "Guyana", ["592"], []),
    Country("GG", "GGY", "Guernsey", ["44"], ["0"]),
    Country("HT", "HTI", "Haiti", ["509"], []),
    Country("HN", "HND", "Honduras", ["504"], []),
    Country("HK", "HKG", "Hong Kong", ["852"], []),
    Country("HU", "HUN", "Hungary", ["36"], ["6"]),
    Country("HM", "HMD", "Heard Island and McDonald Islands", [""], ["0"]),
    Country("WW", "", "ICO Global (Mobile Satellite Service)", ["8810", "8811"], []),
    Country("IS", "ISL", "Iceland", ["354"], ["0"]),
    Country("IN", "IND", "India", ["91"], ["0"]),
    Country("ID", "IDN", "Indonesia", ["62"], ["0"]),
    Country("WW", "", "Inmarsat (Atlantic Ocean - East)", ["871"], []),
    Country("WW", "", "Inmarsat (Atlantic Ocean - West)", ["874"], []),
    Country("WW", "", "Inmarsat (Indian Ocean)", ["873"], []),
    Country("WW", "", "Inmarsat (Pacific Ocean)", ["872"], []),
    Country("WW", "", "Inmarsat", ["870"], []),
    Country("WW", "", "International Freephone Service", ["800"], []),
    Country("WW", "", "International Shared Cost Service (ISCS)", ["808"], []),
    Country("IR", "IRN", "Iran", ["98"], ["0"]),
    Country("IQ", "IRQ", "Iraq", ["964"], ["0"]),
    Country("IE", "IRL", "Eire (Ireland)", ["353"], ["0"]),
    Country("WW", "", "Iridium (Mobile Satellite service)", ["8816", "8817"], []),
    Country("IL", "ISR", "Israel", ["972"], ["0"]),
    Country("IM", "IMN", "Isle of Man", ["44"], ["0"]),
    Country("IT", "ITA", "Italy", ["39"], []),
    Country("JM", "JAM", "Jamaica", ["1876"], ["1876"]),
    Country("JP", "JPN", "Japan", ["81"], ["0"]),
    Country("JE", "JEY", "Jersey", ["44"], ["0"]),
    Country("JO", "JOR", "Jordan", ["962"], ["0"]),
    Country("KZ", "KAZ", "Kazakhstan", ["7"], ["8"]),
    Country("KE", "KEN", "Kenya", ["254"], ["0"]),
    Country("KI", "KIR", "Kiribati", ["686"], []),
    Country("KP", "PRK", "Korea (North)", ["850"], ["0"]),
    Country("KR", "KOR", "Korea (South)", ["82"], ["82"]),
    Country("KW", "KWT", "Kuwait", ["965"], []),
    Country("KG", "KGZ", "Kyrgyz Republic", ["996"], ["0"]),
    Country("LA", "LAO", "Laos", ["856"], ["0"]),
    Country("LV", "LVA", "Latvia", ["371"], []),
    Country("LB", "LBN", "Lebanon", ["961"], ["0"]),
    Country("LS", "LSO", "Lesotho", ["266"], []),
    Country("LR", "LBR", "Liberia", ["231"], []),
    Country("LY", "LBY", "Libya", ["218"], ["0"]),
    Country("LI", "LIE", "Liechtenstein", ["423"], []),
    Country("LT", "LTU", "Lithuania", ["370"], ["0"]),
    Country("LU", "LUX", "Luxembourg", ["352"], []),
    Country("MO", "MAC", "Macao", ["853"], []),
    Country("MK", "MKD", "Macedonia (Former Yugoslav Rep of.)", ["389"], ["0"]),
    Country("MG", "MDG", "Madagascar", ["261"], []),
    Country("MW", "MWI", "Malawi", ["265"], []),
    Country("MY", "MYS", "Malaysia", ["60"], ["0"]),
    Country("MV", "MDV", "Maldives", ["960"], []),
    Country("ML", "MLI", "Mali Republic", ["223"], []),
    Country("MT", "MLT", "Malta", ["356"], []),
    Country("MH", "MHL", "Marshall Islands", ["692"], ["1"]),
    Country("MQ", "MTQ", "Martinique", ["596"], []),
    Country("MR", "MRT", "Mauritania", ["222"], []),
    Country("MU", "MUS", "Mauritius", ["230"], []),
    Country("YT", "MYT", "Mayotte Island", ["269"], []),
    Country("MX", "MEX", "Mexico", ["52"], ["1"]),
    Country("FM", "FSM", "Micronesia, (Federal States of)", ["691"], ["1"]),
    Country("MD", "MDA", "Moldova", ["373"], ["0"]),
    Country("MC", "MCO", "Monaco", ["377"], []),
    Country("MN", "MNG", "Mongolia", ["976"], ["0"]),
    Country("ME", "MNE", "Montenegro", ["382"], ["0"]),
    Country("MS", "MSR", "Montserrat", ["1664"], ["1664"]),
    Country("MA", "MAR", "Morocco", ["212"], ["0"]),
    Country("MZ", "MOZ", "Mozambique", ["258"], []),
    Country("MM", "MMR", "Myanmar (Burma)", ["95"], ["0"]),
    Country("NA", "NAM", "Namibia", ["264"], ["0"]),
    Country("NR", "NRU", "Nauru", ["674"], []),
    Country("NP", "NPL", "Nepal", ["977"], ["0"]),
    Country("NL", "NDL", "Netherlands", ["31"], ["0"]),
    Country("AN", "", "Netherlands Antilles", ["599"], ["0"]),
    Country("NC", "NCL", "New Caledonia", ["687"], []),
    Country("NZ", "NZL", "New Zealand", ["64"], ["0"]),
    Country("NI", "NIC", "Nicaragua", ["505"], []),
    Country("NE", "NER", "Niger", ["227"], []),
    Country("NG", "NGA", "Nigeria", ["234"], ["0"]),
    Country("NU", "NIU", "Niue", ["683"], []),
    Country("NF", "NFK", "Norfolk Island", ["672"], []),
    Country("MP", "MNP", "Northern Marianas Islands (Saipan, Rota, & Tinian)", ["1670"], ["1670"]),
    Country("NO", "NOR", "Norway", ["47"], []),
    Country("OM", "OMN", "Oman", ["968"], []),
    Country("PK", "PAK", "Pakistan", ["92"], ["0"]),
    Country("PW", "PLW", "Palau", ["680"], []),
    Country("PS", "PSE", "Palestinian Settlements", ["970"], ["0"]),
    Country("PA", "PAN", "Panama", ["507"], []),
    Country("PG", "PNG", "Papua New Guinea", ["675"], []),
    Country("PY", "PRY", "Paraguay", ["595"], ["0"]),
    Country("PE", "PER", "Peru", ["51"], ["0"]),
    Country("PH", "PHL", "Philippines", ["63"], ["0"]),
    Country("PN", "PCN", "Pitcairn Islands",[], ["0"]),
    Country("PL", "POL", "Poland", ["48"], ["0"]),
    Country("PT", "PRT", "Portugal", ["351"], []),
    Country("PR", "PRI", "Puerto Rico", ["1787", "1939"], ["1787", "1939"]),
    Country("QA", "QAT", "Qatar", ["974"], []),
    Country("RE", "REU", "Réunion Island", ["262"], ["0"]),
    Country("RO", "ROU", "Romania", ["40"], ["0"]),
    Country("RU", "RUS", "Russia", ["7"], ["8"]),
    Country("RW", "RWA", "Rwandese Republic", ["250"], []),
    Country("SH", "SHN", "St. Helena", ["290"], []),
    Country("KN", "KNA", "St. Kitts/Nevis", ["1869"], ["1869"]),
    Country("LC", "LCA", "St. Lucia", ["1758"], ["1758"]),
    Country("PM", "SPM", "St. Pierre & Miquelon", ["508"], []),
    Country("VC", "VCT", "St. Vincent & Grenadines", ["1784"], ["1784"]),
    Country("MF", "MAF", "St. Martin",[], ["0"]),
    Country("SX", "SXM", "Sint Maarten (Dutch Part)", ["1721"], ["1721"]),
    Country("WS", "WSM", "Samoa", ["685"], []),
    Country("SM", "SMR", "San Marino", ["378"], []),
    Country("ST", "STP", "São Tomé and Principe", ["239"], []),
    Country("SA", "SAU", "Saudi Arabia", ["966"], ["0"]),
    Country("SN", "SEN", "Senegal", ["221"], []),
    Country("RS", "SRB", "Serbia", ["381"], ["0"]),
    Country("SC", "SYC", "Seychelles Republic", ["248"], []),
    Country("SL", "SLE", "Sierra Leone", ["232"], ["0"]),
    Country("SG", "SGP", "Singapore", ["65"], []),
    Country("SK", "SVK", "Slovak Republic", ["421"], ["0"]),
    Country("SI", "SVN", "Slovenia", ["386"], ["0"]),
    Country("SB", "SLB", "Solomon Islands", ["677"], []),
    Country("SO", "SOM", "Somali Democratic Republic", ["252"], []),
    Country("ZA", "ZAF", "South Africa", ["27"], ["0"]),
    Country("GS", "SGS", "South Georgia & South Sandwich Islands",[], ["0"]),
    Country("ES", "ESP", "Spain", ["34"], []),
    Country("LK", "LKA", "Sri Lanka", ["94"], ["0"]),
    Country("SD", "SDN", "Sudan", ["249"], ["0"]),
    Country("SS", "SSD", "Republic of South Sudan", ["211"], ["0"]),
    Country("SR", "SUR", "Suriname", ["597"], ["0"]),
    Country("SJ", "SJM", "Svalbard and Jan Mayen", [], []),
    Country("SZ", "SWZ", "Swaziland", ["268"], []),
    Country("SE", "SWE", "Sweden", ["46"], ["0"]),
    Country("CH", "CHE", "Switzerland", ["41"], ["0"]),
    Country("SY", "SYR", "Syria", ["963"], ["0"]),
    Country("TW", "TWN", "Taiwan", ["886"], ["0"]),
    Country("TJ", "TJK", "Tajikistan", ["992"], ["8"]),
    Country("TZ", "TZA", "Tanzania", ["255"], ["0"]),
    Country("TH", "THA", "Thailand", ["66"], ["0"]),
    Country("WW", "", "Thuraya (Mobile Satellite service)", ["88216"], []),
    Country("TG", "TGO", "Togolese Republic", ["228"], []),
    Country("TK", "TKL", "Tokelau", ["690"], []),
    Country("TO", "TON", "Tonga Islands", ["676"], []),
    Country("TT", "TTO", "Trinidad & Tobago", ["1868"], ["1868"]),
    Country("TN", "TUN", "Tunisia", ["216"], []),
    Country("TR", "TUR", "Turkey", ["90"], ["0"]),
    Country("TM", "TKM", "Turkmenistan", ["993"], ["8"]),
    Country("TC", "TCA", "Turks and Caicos Islands", ["1649"], ["1649"]),
    Country("TV", "TUV", "Tuvalu", ["688"], []),
    Country("UG", "UGA", "Uganda", ["256"], ["0"]),
    Country("UA", "UKR", "Ukraine", ["380"], ["0"]),
    Country("AE", "ARE", "United Arab Emirates", ["971"], ["0"]),
    Country("US", "USA", "United States of America", ["1"], ["1"]),
    Country("VG", "VGB", "American Virgin Islands", ["1340"], ["1340"]),
    Country("WW", "", "Universal Personal Telecommunications (UPT)", ["878"], []),
    Country("UM", "UMI", "United States Minor Outlying Islands", ["1"], ["1"]),
    Country("UY", "URY", "Uruguay", ["598"], ["0"]),
    Country("UZ", "UZB", "Uzbekistan", ["998"], ["8"]),
    Country("VU", "VUT", "Vanuatu", ["678"], []),
    Country("VA", "VAT", "Vatican City", ["39", "379"], []),
    Country("VE", "VEN", "Venezuela", ["58"], ["0"]),
    Country("VN", "VNM", "Vietnam", ["84"], ["0"]),
    Country("WF", "WLF", "Wallis and Futuna Islands", ["681"], []),
    Country("YE", "YEM", "Yemen", ["967"], ["0"]),
    Country("ZM", "ZMB", "Zambia", ["260"], ["0"]),
    Country("", "", "Zanzibar", ["255"], ["0"]),
    Country("ZW", "ZMB", "Zimbabwe", ["263"], ["0"])
    ]
    
    static let NANP = countries[0]
    static let WORLD_WIDE = countries[1]
    static let UNITED_KINGDOM = countries[2]
    static let AFGHANISTAN = countries[3]
    static let ALBANIA = countries[4]
    static let ALGERIA = countries[5]
    static let AMERICAN_SAMOA = countries[6]
    static let ANDORRA = countries[7]
    static let ANGOLA = countries[8]
    static let ANGUILLA = countries[9]
    static let ANTARCTICA = countries[10]
    static let ANTIGUA_BARBUDA = countries[11]
    static let ARGENTINA = countries[12]
    static let ARMENIA = countries[13]
    static let ARUBA = countries[14]
    static let ASCENSION = countries[15]
    static let AUSTRALIA = countries[16]
    static let AUSTRALIAN_EXTERNAL_TERRITORIES = countries[17]
    static let AUSTRIA = countries[18]
    static let AZERBAIJAN = countries[19]
    static let BAHAMAS = countries[20]
    static let BAHRAIN = countries[21]
    static let BANGLADESH = countries[22]
    static let BARBADOS = countries[23]
    static let BELARUS = countries[24]
    static let BELGIUM = countries[25]
    static let BELIZE = countries[26]
    static let BENIN = countries[27]
    static let BERMUDA = countries[28]
    static let BHUTAN = countries[29]
    static let BOLIVIA = countries[30]
    static let BOSNIA_AND_HERZEGOVINA = countries[31]
    static let BOTSWANA = countries[32]
    static let BOUVET_ISLAND = countries[33]
    static let BONAIRE_SINT_EUSTATIUS_AND_SABA = countries[34]
    static let BRAZIL = countries[35]
    static let BRITISH_VIRGIN_ISLANDS = countries[36]
    static let BRITISH_INDIAN_OCEAN_TERRITORY = countries[37]
    static let BRUNEI_DARUSSALAM = countries[38]
    static let BULGARIA = countries[39]
    static let BURKINA_FASO = countries[40]
    static let BURUNDI = countries[41]
    static let CAMBODIA = countries[42]
    static let CAMEROON = countries[43]
    static let CANADA = countries[44]
    static let CAPE_VERDE_ISLANDS = countries[45]
    static let CAYMAN_ISLANDS = countries[46]
    static let CENTRAL_AFRICAN_REPUBLIC = countries[47]
    static let CHAD = countries[48]
    static let CHILE = countries[49]
    static let CHINA = countries[50]
    static let CHRISTMAS_ISLAND = countries[51]
    static let COCOS_KEELING_ISLANDS = countries[52]
    static let COLOMBIA = countries[53]
    static let COMOROS = countries[54]
    static let CONGO = countries[55]
    static let CONGO_FORMER_ZAIRE = countries[56]
    static let COOK_ISLANDS = countries[57]
    static let COSTA_RICA = countries[58]
    static let COTE_D_IVOIRE = countries[59]
    static let CROATIA = countries[60]
    static let CUBA = countries[61]
    static let CURACAO = countries[62]
    static let CYPRUS = countries[63]
    static let CZECH_REPUBLIC = countries[64]
    static let DENMARK = countries[65]
    static let DIEGO_GARCIA = countries[66]
    static let DJIBOUTI = countries[67]
    static let DOMINICA = countries[68]
    static let DOMINICAN_REPUBLIC = countries[69]
    static let TIMOR_LESTE = countries[70]
    static let EASTER_ISLAND = countries[71]
    static let ECUADOR = countries[72]
    static let EGYPT = countries[73]
    static let WESTERN_SAHARA = countries[74]
    static let EL_SALVADOR = countries[75]
    static let ELLIPSO = countries[76]
    static let EMSAT = countries[77]
    static let EQUATORIAL_GUINEA = countries[78]
    static let ERITREA = countries[79]
    static let ESTONIA = countries[80]
    static let ETHIOPIA = countries[81]
    static let FALKLAND_ISLANDS = countries[82]
    static let FAROE_ISLANDS = countries[83]
    static let FIJI_ISLANDS = countries[84]
    static let FINLAND = countries[85]
    static let FRANCE = countries[86]
    static let FRENCH_ANTILLES = countries[87]
    static let FRENCH_GUIANA = countries[88]
    static let FRENCH_POLYNESIA = countries[89]
    static let GABONESE_REPUBLIC = countries[90]
    static let GAMBIA = countries[91]
    static let GEORGIA = countries[92]
    static let GERMANY = countries[93]
    static let GHANA = countries[94]
    static let GIBRALTAR = countries[95]
    static let GMSS = countries[96]
    static let GLOBALSTAR = countries[97]
    static let GREECE = countries[98]
    static let GREENLAND = countries[99]
    static let GRENADA = countries[100]
    static let GUADELOUPE = countries[101]
    static let GUAM = countries[102]
    static let GUANTANAMO_BAY = countries[103]
    static let GUATEMALA = countries[104]
    static let GUINEA_BISSAU = countries[105]
    static let GUINEA = countries[106]
    static let GUYANA = countries[107]
    static let GUERNSEY = countries[108]
    static let HAITI = countries[109]
    static let HONDURAS = countries[110]
    static let HONG_KONG = countries[111]
    static let HUNGARY = countries[112]
    static let HEARD_ISLAND_AND_MCDONALD_ISLANDS = countries[113]
    static let ICO_GLOBAL = countries[114]
    static let ICELAND = countries[115]
    static let INDIA = countries[116]
    static let INDONESIA = countries[117]
    static let INMARSAT_ATLANTIC_OCEAN_EAST = countries[118]
    static let INMARSAT_ATLANTIC_OCEAN_WEST = countries[119]
    static let INMARSAT_INDIAN_OCEAN = countries[120]
    static let INMARSAT_PACIFIC_OCEAN = countries[121]
    static let INMARSAT = countries[122]
    static let INTERNATIONAL_FREEPHONE_SERVICE = countries[123]
    static let ISCS = countries[124]
    static let IRAN = countries[125]
    static let IRAQ = countries[126]
    static let IRELAND = countries[127]
    static let IRIDIUM = countries[128]
    static let ISRAEL = countries[129]
    static let ISLE_OF_MAN = countries[130]
    static let ITALY = countries[131]
    static let JAMAICA = countries[132]
    static let JAPAN = countries[133]
    static let JERSEY = countries[134]
    static let JORDAN = countries[135]
    static let KAZAKHSTAN = countries[136]
    static let KENYA = countries[137]
    static let KIRIBATI = countries[138]
    static let KOREA_NORTH = countries[139]
    static let KOREA_SOUTH = countries[140]
    static let KUWAIT = countries[141]
    static let KYRGYZ_REPUBLIC = countries[142]
    static let LAOS = countries[143]
    static let LATVIA = countries[144]
    static let LEBANON = countries[145]
    static let LESOTHO = countries[146]
    static let LIBERIA = countries[147]
    static let LIBYA = countries[148]
    static let LIECHTENSTEIN = countries[149]
    static let LITHUANIA = countries[150]
    static let LUXEMBOURG = countries[151]
    static let MACAO = countries[152]
    static let MACEDONIA = countries[153]
    static let MADAGASCAR = countries[154]
    static let MALAWI = countries[155]
    static let MALAYSIA = countries[156]
    static let MALDIVES = countries[157]
    static let MALI_REPUBLIC = countries[158]
    static let MALTA = countries[159]
    static let MARSHALL_ISLANDS = countries[160]
    static let MARTINIQUE = countries[161]
    static let MAURITANIA = countries[162]
    static let MAURITIUS = countries[163]
    static let MAYOTTE_ISLAND = countries[164]
    static let MEXICO = countries[165]
    static let MICRONESIA = countries[166]
    static let MOLDOVA = countries[167]
    static let MONACO = countries[168]
    static let MONGOLIA = countries[169]
    static let MONTENEGRO = countries[170]
    static let MONTSERRAT = countries[171]
    static let MOROCCO = countries[172]
    static let MOZAMBIQUE = countries[173]
    static let MYANMAR = countries[174]
    static let NAMIBIA = countries[175]
    static let NAURU = countries[176]
    static let NEPAL = countries[177]
    static let NETHERLANDS = countries[178]
    static let NETHERLANDS_ANTILLES = countries[179]
    static let NEW_CALEDONIA = countries[180]
    static let NEW_ZEALAND = countries[181]
    static let NICARAGUA = countries[182]
    static let NIGER = countries[183]
    static let NIGERIA = countries[184]
    static let NIUE = countries[185]
    static let NORFOLK_ISLAND = countries[186]
    static let NORTHERN_MARIANAS_ISLANDS = countries[187]
    static let NORWAY = countries[188]
    static let OMAN = countries[189]
    static let PAKISTAN = countries[190]
    static let PALAU = countries[191]
    static let PALESTINIAN_SETTLEMENTS = countries[192]
    static let PANAMA = countries[193]
    static let PAPUA_NEW_GUINEA = countries[194]
    static let PARAGUAY = countries[195]
    static let PERU = countries[196]
    static let PHILIPPINES = countries[197]
    static let PITCAIRN_ISLANDS = countries[198]
    static let POLAND = countries[199]
    static let PORTUGAL = countries[200]
    static let PUERTO_RICO = countries[201]
    static let QATAR = countries[202]
    static let REUNION_ISLAND = countries[203]
    static let ROMANIA = countries[204]
    static let RUSSIA = countries[205]
    static let RWANDESE_REPUBLIC = countries[206]
    static let ST_HELENA = countries[207]
    static let ST_KITTS_NEVIS = countries[208]
    static let ST_LUCIA = countries[209]
    static let ST_PIERRE_AND_MIQUELON = countries[210]
    static let ST_VINCENT_AND_GRENADINES = countries[211]
    static let ST_MARTIN = countries[212]
    static let SINT_MAARTEN = countries[213]
    static let SAMOA = countries[214]
    static let SAN_MARINO = countries[215]
    static let SAO_TOME_AND_PRINCIPE = countries[216]
    static let SAUDI_ARABIA = countries[217]
    static let SENEGAL = countries[218]
    static let SERBIA = countries[219]
    static let SEYCHELLES_REPUBLIC = countries[220]
    static let SIERRA_LEONE = countries[221]
    static let SINGAPORE = countries[222]
    static let SLOVAK_REPUBLIC = countries[223]
    static let SLOVENIA = countries[224]
    static let SOLOMON_ISLANDS = countries[225]
    static let SOMALI_DEMOCRATIC_REPUBLIC = countries[226]
    static let SOUTH_AFRICA = countries[227]
    static let SOUTH_GEORGIA_AND_SOUTH_SANDWICH_ISLANDS = countries[228]
    static let SPAIN = countries[229]
    static let SRI_LANKA = countries[230]
    static let SUDAN = countries[231]
    static let REPUBLIC_OF_SOUTH_SUDAN = countries[232]
    static let SURINAME = countries[233]
    static let SVALBARD_AND_JAN_MAYEN = countries[234]
    static let SWAZILAND = countries[235]
    static let SWEDEN = countries[236]
    static let SWITZERLAND = countries[237]
    static let SYRIA = countries[238]
    static let TAIWAN = countries[239]
    static let TAJIKISTAN = countries[240]
    static let TANZANIA = countries[241]
    static let THAILAND = countries[242]
    static let THURAYA = countries[243]
    static let TOGOLESE_REPUBLIC = countries[244]
    static let TOKELAU = countries[245]
    static let TONGA_ISLANDS = countries[246]
    static let TRINIDAD_AND_TOBAGO = countries[247]
    static let TUNISIA = countries[248]
    static let TURKEY = countries[249]
    static let TURKMENISTAN = countries[250]
    static let TURKS_AND_CAICOS_ISLANDS = countries[251]
    static let TUVALU = countries[252]
    static let UGANDA = countries[253]
    static let UKRAINE = countries[254]
    static let UNITED_ARAB_EMIRATES = countries[255]
    static let UNITED_STATES_OF_AMERICA = countries[256]
    static let AMERICAN_VIRGIN_ISLANDS = countries[257]
    static let UNIVERSAL_PERSONAL_TELECOMMUNICATIONS = countries[258]
    static let UNITED_STATES_MINOR_OUTLYING_ISLANDS = countries[259]
    static let URUGUAY = countries[260]
    static let UZBEKISTAN = countries[261]
    static let VANUATU = countries[262]
    static let VATICAN_CITY = countries[263]
    static let VENEZUELA = countries[264]
    static let VIETNAM = countries[265]
    static let WALLIS_AND_FUTUNA_ISLANDS = countries[266]
    static let YEMEN = countries[267]
    static let ZAMBIA = countries[268]
    static let ZANZIBAR = countries[269]
    static let ZIMBABWE = countries[270]
}
