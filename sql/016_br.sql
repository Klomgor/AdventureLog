INSERT INTO "worldTravelCountryRegions" (id, name, country_code)
VALUES
  ('BR-AC', 'Acre', 'br'),
  ('BR-AL', 'Alagoas', 'br'),
  ('BR-AP', 'Amapá', 'br'),
  ('BR-AM', 'Amazonas', 'br'),
  ('BR-BA', 'Bahia', 'br'),
  ('BR-CE', 'Ceará', 'br'),
  ('BR-DF', 'Federal District', 'br'),
  ('BR-ES', 'Espírito Santo', 'br'),
  ('BR-GO', 'Goiás', 'br'),
  ('BR-MA', 'Maranhão', 'br'),
  ('BR-MT', 'Mato Grosso', 'br'),
  ('BR-MS', 'Mato Grosso do Sul', 'br'),
  ('BR-MG', 'Minas Gerais', 'br'),
  ('BR-PA', 'Pará', 'br'),
  ('BR-PB', 'Paraíba', 'br'),
  ('BR-PR', 'Paraná', 'br'),
  ('BR-PE', 'Pernambuco', 'br'),
  ('BR-PI', 'Piauí', 'br'),
  ('BR-RJ', 'Rio de Janeiro', 'br'),
  ('BR-RN', 'Rio Grande do Norte', 'br'),
  ('BR-RS', 'Rio Grande do Sul', 'br'),
  ('BR-RO', 'Rondônia', 'br'),
  ('BR-RR', 'Roraima', 'br'),
  ('BR-SC', 'Santa Catarina', 'br'),
  ('BR-SP', 'São Paulo', 'br'),
  ('BR-SE', 'Sergipe', 'br'),
  ('BR-TO', 'Tocantins', 'br')

ON CONFLICT (id) DO NOTHING;