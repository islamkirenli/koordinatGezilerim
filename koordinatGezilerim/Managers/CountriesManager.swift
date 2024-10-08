import Foundation

class CountriesManager {
    static let countries = [
        "Global", "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina","Armenia",
        "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium",
        "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria",
        "Burkina Faso", "Burundi", "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Central African Republic",
        "Chad", "Chile", "China", "Colombia", "Comoros", "Congo, Democratic Republic of the",
        "Congo, Republic of the", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti",
        "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia",
        "Eswatini", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece",
        "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India",
        "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya",
        "Kiribati", "Korea, North", "Korea, South", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon",
        "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia",
        "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova",
        "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands",
        "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Macedonia", "Norway", "Oman", "Pakistan", "Palau",
        "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar",
        "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines",
        "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone",
        "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Sudan", "Spain",
        "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania",
        "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Türkiye", "Turkmenistan",
        "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan",
        "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"
    ]

    static let countryCoordinatesRanges: [String: (north: Double, south: Double, east: Double, west: Double)] = [
        "Global": (north: 90.0, south: -90.0, east: 180.0, west: -180.0),
        "Afghanistan": (north: 38.4834, south: 29.3772, east: 74.8794, west: 60.5171),
        "Albania": (north: 42.6611, south: 39.6481, east: 21.0573, west: 19.2631),
        "Algeria": (north: 37.0937, south: 18.976, east: 11.9995, west: -8.684),
        "Andorra": (north: 42.656, south: 42.4285, east: 1.7865, west: 1.4072),
        "Angola": (north: -4.3889, south: -18.0421, east: 24.0821, west: 11.6792),
        "Antigua and Barbuda": (north: 17.7275, south: 16.989, east: -61.6726, west: -61.9064),
        "Argentina": (north: -21.7812, south: -55.051, east: -53.5918, west: -73.582),
        "Armenia": (north: 41.3018, south: 38.8405, east: 46.6226, west: 43.4477),
        "Australia": (north: -10.6872, south: -43.6444, east: 153.6393, west: 112.9211),
        "Austria": (north: 49.021, south: 46.3726, east: 17.1621, west: 9.5309),
        "Azerbaijan": (north: 41.9056, south: 38.3892, east: 50.3701, west: 44.7637),
        "Bahamas": (north: 26.9193, south: 22.8528, east: -74.4238, west: -78.98),
        "Bahrain": (north: 26.2822, south: 25.7968, east: 50.6649, west: 50.4543),
        "Bangladesh": (north: 26.6319, south: 20.7433, east: 92.6747, west: 88.0218),
        "Barbados": (north: 13.3354, south: 13.0511, east: -59.4201, west: -59.6398),
        "Belarus": (north: 56.1722, south: 51.2561, east: 32.7715, west: 23.1783),
        "Belgium": (north: 51.5054, south: 49.497, east: 6.4038, west: 2.5218),
        "Belize": (north: 18.496, south: 15.886, east: -87.774, west: -89.227),
        "Benin": (north: 12.418, south: 6.2254, east: 3.8433, west: 0.7762),
        "Bhutan": (north: 28.3584, south: 26.702, east: 92.1252, west: 88.7465),
        "Bolivia": (north: -9.6796, south: -22.896, east: -57.4687, west: -69.6448),
        "Bosnia and Herzegovina": (north: 45.2766, south: 42.5553, east: 19.6222, west: 15.7287),
        "Botswana": (north: -17.7808, south: -26.8916, east: 29.3753, west: 20.0011),
        "Brazil": (north: 5.2649, south: -33.7507, east: -34.793, west: -73.9854),
        "Brunei": (north: 5.048, south: 4.0037, east: 115.359, west: 114.075),
        "Bulgaria": (north: 44.2176, south: 41.2354, east: 28.6122, west: 22.3653),
        "Burkina Faso": (north: 15.084, south: 9.4011, east: 2.4054, west: -5.5189),
        "Burundi": (north: -2.3097, south: -4.4693, east: 30.8493, west: 28.9941),
        "Cabo Verde": (north: 17.1966, south: 14.8036, east: -22.6677, west: -25.3588),
        "Cambodia": (north: 14.686, south: 10.4865, east: 107.6126, west: 102.3123),
        "Cameroon": (north: 13.0782, south: 1.6546, east: 16.1921, west: 8.4947),
        "Canada": (north: 83.1139, south: 41.6766, east: -52.6363, west: -141.0019),
        "Central African Republic": (north: 11.0048, south: 2.2233, east: 27.4639, west: 14.4201),
        "Chad": (north: 23.4097, south: 7.421, east: 24.0024, west: 13.4735),
        "Chile": (north: -17.5066, south: -55.6118, east: -66.416, west: -75.6458),
        "China": (north: 53.5609, south: 18.1949, east: 134.7728, west: 73.5577),
        "Colombia": (north: 13.394, south: -4.2317, east: -66.8763, west: -79.0227),
        "Comoros": (north: -11.3623, south: -12.3879, east: 44.5314, west: 43.2158),
        "Congo, Democratic Republic of the": (north: 5.392, south: -13.459, east: 31.305, west: 12.2104),
        "Congo, Republic of the": (north: 3.7131, south: -5.0143, east: 18.6429, west: 11.1425),
        "Costa Rica": (north: 11.216, south: 8.0322, east: -82.555, west: -85.9506),
        "Croatia": (north: 46.5038, south: 42.4359, east: 19.4479, west: 13.4932),
        "Cuba": (north: 23.266, south: 19.8284, east: -74.131, west: -84.9577),
        "Cyprus": (north: 35.6868, south: 34.6342, east: 34.5979, west: 32.2717),
        "Czech Republic": (north: 51.0557, south: 48.557, east: 18.8601, west: 12.0936),
        "Denmark": (north: 57.7511, south: 54.5606, east: 15.1495, west: 8.0712),
        "Djibouti": (north: 12.7132, south: 10.9269, east: 43.418, west: 41.7709),
        "Dominica": (north: 15.6333, south: 15.2012, east: -61.252, west: -61.4808),
        "Dominican Republic": (north: 19.9363, south: 17.5402, east: -68.3221, west: -72.003),
        "Ecuador": (north: 1.4458, south: -5.0158, east: -75.2566, west: -81.0774),
        "Egypt": (north: 31.6673, south: 22.0, east: 35.6798, west: 24.7),
        "El Salvador": (north: 14.4501, south: 13.1564, east: -87.6867, west: -90.1287),
        "Equatorial Guinea": (north: 2.344, south: 0.9208, east: 11.3352, west: 9.3466),
        "Eritrea": (north: 18.0036, south: 12.3607, east: 43.128, west: 36.4334),
        "Estonia": (north: 59.674, south: 57.5093, east: 28.2089, west: 21.8323),
        "Eswatini": (north: -25.7186, south: -27.3174, east: 32.1345, west: 30.7908),
        "Ethiopia": (north: 14.883, south: 3.4221, east: 47.9787, west: 32.9542),
        "Fiji": (north: -12.4805, south: -20.6757, east: -178.1222, west: 176.8462),
        "Finland": (north: 70.0961, south: 59.8081, east: 31.5809, west: 20.5569),
        "France": (north: 51.089, south: 41.365, east: 9.5616, west: -5.1413),
        "Gabon": (north: 2.3226, south: -3.9365, east: 14.5023, west: 8.6973),
        "Gambia": (north: 13.826, south: 13.0659, east: -13.7926, west: -16.8259),
        "Georgia": (north: 43.5866, south: 41.0551, east: 46.6948, west: 39.9857),
        "Germany": (north: 55.056, south: 47.27, east: 15.042, west: 5.8663),
        "Ghana": (north: 11.1749, south: 4.737, east: 1.1998, west: -3.261),
        "Greece": (north: 41.7489, south: 34.8, east: 26.2946, west: 19.3746),
        "Grenada": (north: 12.318, south: 11.9987, east: -61.1732, west: -61.8024),
        "Guatemala": (north: 17.8162, south: 13.737, east: -88.225, west: -92.233),
        "Guinea": (north: 12.676, south: 7.1936, east: -7.6411, west: -14.9263),
        "Guinea-Bissau": (north: 12.6794, south: 10.9278, east: -13.6363, west: -16.7173),
        "Guyana": (north: 8.558, south: 1.1856, east: -56.4802, west: -61.389),
        "Haiti": (north: 20.0899, south: 18.021, east: -71.6451, west: -74.4786),
        "Honduras": (north: 16.5103, south: 12.9827, east: -83.1558, west: -89.3508),
        "Hungary": (north: 48.585, south: 45.743, east: 22.897, west: 16.113),
        "Iceland": (north: 66.5667, south: 63.3931, east: -13.4946, west: -24.5465),
        "India": (north: 35.6745, south: 6.755, east: 97.4023, west: 68.1766),
        "Indonesia": (north: 5.9044, south: -10.95, east: 141.0205, west: 95.293),
        "Iran": (north: 39.7824, south: 25.064, east: 63.3173, west: 44.0326),
        "Iraq": (north: 37.3784, south: 29.0596, east: 48.5765, west: 38.7941),
        "Ireland": (north: 55.3869, south: 51.4249, east: -5.9974, west: -10.4691),
        "Israel": (north: 33.2774, south: 29.4894, east: 35.6689, west: 34.267),
        "Italy": (north: 47.0912, south: 36.6528, east: 18.5148, west: 6.6267),
        "Jamaica": (north: 18.525, south: 17.7036, east: -76.1802, west: -78.3687),
        "Japan": (north: 45.5515, south: 24.3963, east: 153.9866, west: 122.9355),
        "Jordan": (north: 33.374, south: 29.1848, east: 39.3011, west: 34.9599),
        "Kazakhstan": (north: 55.441, south: 40.584, east: 87.3238, west: 46.4937),
        "Kenya": (north: 5.0302, south: -4.678, east: 41.885, west: 33.907),
        "Kiribati": (north: 4.7196, south: -11.4468, east: -150.2155, west: 169.5421),
        "Korea, North": (north: 43.007, south: 37.6733, east: 130.6749, west: 124.3156),
        "Korea, South": (north: 38.6122, south: 33.191, east: 129.5844, west: 126.1178),
        "Kosovo": (north: 43.2696, south: 41.8566, east: 21.7988, west: 20.0142),
        "Kuwait": (north: 30.0959, south: 28.5246, east: 48.4313, west: 46.5552),
        "Kyrgyzstan": (north: 43.2382, south: 39.1727, east: 80.2839, west: 69.2755),
        "Laos": (north: 22.4964, south: 13.9153, east: 107.6637, west: 100.0831),
        "Latvia": (north: 58.0854, south: 55.6745, east: 28.241, west: 20.9683),
        "Lebanon": (north: 34.6924, south: 33.0557, east: 36.6335, west: 35.1261),
        "Lesotho": (north: -28.5706, south: -30.6681, east: 29.4557, west: 27.0285),
        "Liberia": (north: 8.5519, south: 4.3531, east: -7.3673, west: -11.4927),
        "Libya": (north: 33.168, south: 19.508, east: 25.15, west: 9.3914),
        "Liechtenstein": (north: 47.2706, south: 47.0484, east: 9.6357, west: 9.4717),
        "Lithuania": (north: 56.4469, south: 53.8969, east: 26.8355, west: 20.9415),
        "Luxembourg": (north: 50.1828, south: 49.446, east: 6.5309, west: 5.7345),
        "Madagascar": (north: -11.9455, south: -25.608, east: 50.4833, west: 43.2249),
        "Malawi": (north: -9.3687, south: -17.125, east: 35.9169, west: 32.6733),
        "Malaysia": (north: 7.3668, south: 0.8514, east: 119.2669, west: 99.6448),
        "Maldives": (north: 7.1041, south: -0.6927, east: 73.6373, west: 72.6932),
        "Mali": (north: 25.0011, south: 10.1596, east: 4.2674, west: -12.2674),
        "Malta": (north: 36.0833, south: 35.7979, east: 14.5765, west: 14.1833),
        "Marshall Islands": (north: 14.62, south: 4.5746, east: 172.0271, west: 160.8476),
        "Mauritania": (north: 27.2981, south: 14.7155, east: -4.8157, west: -17.065),
        "Mauritius": (north: -10.138, south: -20.5253, east: 63.503, west: 56.5127),
        "Mexico": (north: 32.7187, south: 14.5329, east: -86.7034, west: -118.4566),
        "Micronesia": (north: 10.0904, south: 0.8278, east: 163.0375, west: 137.2232),
        "Moldova": (north: 48.4902, south: 45.4665, east: 30.1332, west: 26.6189),
        "Monaco": (north: 43.7499, south: 43.7248, east: 7.439, west: 7.4088),
        "Mongolia": (north: 52.149, south: 41.5865, east: 119.936, west: 87.7483),
        "Montenegro": (north: 43.5681, south: 41.8351, east: 20.3516, west: 18.451),
        "Morocco": (north: 35.9369, south: 27.6673, east: -0.9989, west: -13.1753),
        "Mozambique": (north: -10.471, south: -26.8603, east: 40.8425, west: 30.2139),
        "Myanmar": (north: 28.5433, south: 9.7849, east: 101.1778, west: 92.1893),
        "Namibia": (north: -16.9637, south: -28.9694, east: 25.2637, west: 11.7132),
        "Nauru": (north: -0.5043, south: -0.552, east: 166.9583, west: 166.9062),
        "Nepal": (north: 30.424, south: 26.347, east: 88.2015, west: 80.0569),
        "Netherlands": (north: 53.5122, south: 50.7503, east: 7.207, west: 3.314),
        "New Zealand": (north: -34.3891, south: -47.2899, east: -180, west: 166.7155),
        "Nicaragua": (north: 15.025, south: 10.7084, east: -82.7384, west: -87.6902),
        "Niger": (north: 23.5177, south: 11.6947, east: 15.9966, west: 0.1693),
        "Nigeria": (north: 13.8856, south: 4.2771, east: 14.6801, west: 2.6684),
        "North Macedonia": (north: 42.3738, south: 40.8603, east: 23.038, west: 20.4631),
        "Norway": (north: 71.1855, south: 57.9936, east: 31.0781, west: 4.6345),
        "Oman": (north: 26.3871, south: 16.6423, east: 59.8366, west: 52.0005),
        "Pakistan": (north: 37.0841, south: 23.6345, east: 77.8374, west: 60.8729),
        "Palau": (north: 8.4696, south: 2.8036, east: 134.721, west: 131.1134),
        "Palestine": (north: 32.5515, south: 31.2198, east: 35.5746, west: 34.2161),
        "Panama": (north: 9.639, south: 7.2048, east: -77.1736, west: -83.0514),
        "Papua New Guinea": (north: -0.8764, south: -11.6579, east: 155.9676, west: 140.8415),
        "Paraguay": (north: -19.2876, south: -27.5952, east: -54.2931, west: -62.6465),
        "Peru": (north: -0.0393, south: -18.3488, east: -68.6523, west: -81.3267),
        "Philippines": (north: 21.1224, south: 4.6432, east: 126.6016, west: 116.9318),
        "Poland": (north: 54.8378, south: 49.002, east: 24.1458, west: 14.123),
        "Portugal": (north: 42.1543, south: 36.9613, east: -6.1891, west: -9.5266),
        "Qatar": (north: 26.1534, south: 24.5562, east: 51.6166, west: 50.75),
        "Romania": (north: 48.266, south: 43.633, east: 29.7016, west: 20.2617),
        "Russia": (north: 81.8573, south: 41.1854, east: -168.978, west: 19.6523),
        "Rwanda": (north: -1.0539, south: -2.8398, east: 30.8999, west: 28.8574),
        "Saint Kitts and Nevis": (north: 17.4158, south: 17.0951, east: -62.5283, west: -62.8616),
        "Saint Lucia": (north: 14.1104, south: 13.7073, east: -60.8728, west: -61.0799),
        "Saint Vincent and the Grenadines": (north: 13.3772, south: 12.583, east: -61.1136, west: -61.4598),
        "Samoa": (north: -13.4326, south: -14.0528, east: -171.4226, west: -172.7983),
        "San Marino": (north: 43.9923, south: 43.8937, east: 12.4935, west: 12.4033),
        "Sao Tome and Principe": (north: 1.7018, south: -0.0241, east: 7.4654, west: 6.4709),
        "Saudi Arabia": (north: 32.161, south: 16.29, east: 55.6667, west: 34.4957),
        "Senegal": (north: 16.6922, south: 12.3033, east: -11.3771, west: -17.6862),
        "Serbia": (north: 46.1905, south: 42.2322, east: 23.0063, west: 18.8394),
        "Seychelles": (north: -3.7127, south: -9.7553, east: 56.2988, west: 46.2046),
        "Sierra Leone": (north: 9.9974, south: 6.9059, east: -10.2823, west: -13.305),
        "Singapore": (north: 1.4713, south: 1.2604, east: 104.0411, west: 103.6383),
        "Slovakia": (north: 49.6138, south: 47.7584, east: 22.5581, west: 16.8333),
        "Slovenia": (north: 46.8767, south: 45.4214, east: 16.5648, west: 13.3831),
        "Solomon Islands": (north: -6.5868, south: -11.8556, east: 166.9709, west: 155.5091),
        "Somalia": (north: 11.9792, south: -1.6749, east: 51.4165, west: 40.9866),
        "South Africa": (north: -22.1266, south: -34.8395, east: 32.9433, west: 16.4519),
        "South Sudan": (north: 12.248, south: 3.4934, east: 35.9489, west: 23.4398),
        "Spain": (north: 43.7934, south: 36.0001, east: 4.3278, west: -9.2997),
        "Sri Lanka": (north: 9.8315, south: 5.9161, east: 81.881, west: 79.6951),
        "Sudan": (north: 22.2249, south: 8.6853, east: 38.6082, west: 21.8276),
        "Suriname": (north: 6.0145, south: 1.8373, east: -53.9777, west: -58.0709),
        "Sweden": (north: 69.0363, south: 55.337, east: 24.1768, west: 11.1096),
        "Switzerland": (north: 47.8085, south: 45.8194, east: 10.4921, west: 5.9559),
        "Syria": (north: 37.319, south: 32.3116, east: 42.3771, west: 35.7076),
        "Taiwan": (north: 25.2976, south: 21.896, east: 122.0074, west: 119.4189),
        "Tajikistan": (north: 41.0412, south: 36.6737, east: 75.137, west: 67.3427),
        "Tanzania": (north: -0.9856, south: -11.7457, east: 40.45, west: 29.3217),
        "Thailand": (north: 20.4649, south: 5.6149, east: 105.6393, west: 97.3448),
        "Timor-Leste": (north: -8.125, south: -9.5014, east: 127.3132, west: 124.0419),
        "Togo": (north: 11.1394, south: 6.1043, east: 1.8083, west: -0.1441),
        "Tonga": (north: -15.5639, south: -21.4559, east: -173.9297, west: -175.6834),
        "Trinidad and Tobago": (north: 11.3525, south: 10.036, east: -60.9397, west: -61.9245),
        "Tunisia": (north: 37.5391, south: 30.2282, east: 11.5975, west: 7.5245),
        "Türkiye": (north: 42.1076, south: 35.8086, east: 44.7939, west: 25.865),
        "Turkmenistan": (north: 42.7516, south: 35.1415, east: 66.646, west: 52.4414),
        "Tuvalu": (north: -5.6417, south: -10.801, east: 179.9042, west: 176.1256),
        "Uganda": (north: 4.2208, south: -1.4823, east: 35.0, west: 29.5734),
        "Ukraine": (north: 52.3791, south: 44.3911, east: 40.134, west: 22.1289),
        "United Arab Emirates": (north: 26.0842, south: 22.6333, east: 56.381, west: 51.5833),
        "United Kingdom": (north: 60.8552, south: 49.9096, east: 1.7692, west: -8.6236),
        "United States": (north: 49.3844, south: 24.3963, east: -66.9346, west: -125.0017),
        "Uruguay": (north: -30.0849, south: -35.003, east: -53.0755, west: -58.439),
        "Uzbekistan": (north: 45.5576, south: 37.192, east: 73.1796, west: 55.9975),
        "Vanuatu": (north: -13.0734, south: -20.2488, east: 169.8964, west: 166.5205),
        "Vatican City": (north: 41.9074, south: 41.9003, east: 12.457, west: 12.4457),
        "Venezuela": (north: 12.2018, south: 0.6265, east: -59.7583, west: -73.3531),
        "Vietnam": (north: 23.3889, south: 8.1797, east: 109.4636, west: 102.1411),
        "Yemen": (north: 18.9996, south: 12.1111, east: 54.527, west: 42.5322),
        "Zambia": (north: -8.2033, south: -17.9612, east: 33.7062, west: 21.9994),
        "Zimbabwe": (north: -15.6099, south: -22.4174, east: 33.0562, west: 25.2373)
    ]
}

