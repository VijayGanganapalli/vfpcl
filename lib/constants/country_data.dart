class CountryData {
  final Map<String, List<String>> states = {
    'India': ['Andhra Pradesh'],
  };
  final Map<String, List<String>> districts = {
    'Andhra Pradesh': ['Annamaya', 'Y.S.R. Kadapa'],
  };
  final Map<String, List<String>> mandals = {
    'Annamaya': ['Lakkireddypalli', 'Ramapuram'],
  };
  final Map<String, List<String>> revenueVillages = {
    'Lakkireddypalli': ['Ananthapuram', 'Lakkireddypalli', 'Maddirevula'],
    'Ramapuram': ['Chitlur', 'Gopagudipalli', 'Hasanapuram'],
  };
  final Map<String, List<String>> habitations = {
    'Ananthapuram': [
      'Edigapalli',
      'Dandevandlapalli',
      'Vaddepalli',
      'Yenamalavandlapalli'
    ],
    'Lakkireddypalli': [
      'Gudlavaripalli',
      'Lakkireddypalli',
      'Malapalli',
      'Nandivandlapalli',
    ],
    'Maddirevula': [
      'Batamadigapalli',
      'Budithaguntapalli',
      'Edigapalli',
      'G.M.R. Colony',
      'Nehru Nagar',
    ],
    'Chitlur': ['Chitlur', 'Chenikkayavandlapalli', 'Majjigavandlapalli'],
    'Gopagudipalli': ['Adapalavandlapalli'],
    'Hasanapuram': ['Musalireddygaripalli'],
  };
}
