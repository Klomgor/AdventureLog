INSERT INTO "worldTravelCountryRegions" (id, name, country_code)
VALUES
  ('JP-01', 'Hokkaido', 'jp'),
  ('JP-02', 'Aomori', 'jp'),
  ('JP-03', 'Iwate', 'jp'),
  ('JP-04', 'Miyagi', 'jp'),
  ('JP-05', 'Akita', 'jp'),
  ('JP-06', 'Yamagata', 'jp'),
  ('JP-07', 'Fukushima', 'jp'),
  ('JP-08', 'Ibaraki', 'jp'),
  ('JP-09', 'Tochigi', 'jp'),
  ('JP-10', 'Gunma', 'jp'),
  ('JP-11', 'Saitama', 'jp'),
  ('JP-12', 'Chiba', 'jp'),
  ('JP-13', 'Tokyo', 'jp'),
  ('JP-14', 'Kanagawa', 'jp'),
  ('JP-15', 'Niigata', 'jp'),
  ('JP-16', 'Toyama', 'jp'),
  ('JP-17', 'Ishikawa', 'jp'),
  ('JP-18', 'Fukui', 'jp'),
  ('JP-19', 'Yamanashi', 'jp'),
  ('JP-20', 'Nagano', 'jp'),
  ('JP-21', 'Gifu', 'jp'),
  ('JP-22', 'Shizuoka', 'jp'),
  ('JP-23', 'Aichi', 'jp'),
  ('JP-24', 'Mie', 'jp'),
  ('JP-25', 'Shiga', 'jp'),
  ('JP-26', 'Kyoto', 'jp'),
  ('JP-27', 'Osaka', 'jp'),
  ('JP-28', 'Hyogo', 'jp'),
  ('JP-29', 'Nara', 'jp'),
  ('JP-30', 'Wakayama', 'jp'),
  ('JP-31', 'Tottori', 'jp'),
  ('JP-32', 'Shimane', 'jp'),
  ('JP-33', 'Okayama', 'jp'),
  ('JP-34', 'Hiroshima', 'jp'),
  ('JP-35', 'Yamaguchi', 'jp'),
  ('JP-36', 'Tokushima', 'jp'),
  ('JP-37', 'Kagawa', 'jp'),
  ('JP-38', 'Ehime', 'jp'),
  ('JP-39', 'Kochi', 'jp'),
  ('JP-40', 'Fukuoka', 'jp'),
  ('JP-41', 'Saga', 'jp'),
  ('JP-42', 'Nagasaki', 'jp'),
  ('JP-43', 'Kumamoto', 'jp'),
  ('JP-44', 'Oita', 'jp'),
  ('JP-45', 'Miyazaki', 'jp'),
  ('JP-46', 'Kagoshima', 'jp'),
  ('JP-47', 'Okinawa', 'jp')

ON CONFLICT (id) DO NOTHING;