-- ============================================================
-- Viciô · Gestor do Evento — Supabase Migration
-- Execute no SQL Editor do Supabase (mcjowmfbxxwrjfrlaeyt)
-- ============================================================

-- CONFIG (investimento, custos fixos, margem)
create table if not exists config (
  key   text primary key,
  value jsonb not null
);

-- INGREDIENTES
create table if not exists ingredientes (
  id          text primary key default gen_random_uuid()::text,
  nome        text not null,
  unidade     text not null default 'g',
  custo       numeric(12,4) not null default 0,
  estoque     numeric(12,3) not null default 0,
  minimo      numeric(12,3) not null default 0,
  fornecedor  text default '',
  updated_at  timestamptz default now()
);

-- RECEITAS
create table if not exists receitas (
  id          text primary key,
  nome        text not null,
  rendimento  integer not null default 20,
  preco_venda numeric(10,2) not null default 0,
  ingredientes jsonb not null default '[]'
);

-- VENDAS
create table if not exists vendas (
  id          text primary key default gen_random_uuid()::text,
  dia         integer not null,
  sabor       text not null,
  sabor_nome  text not null,
  qtd         integer not null,
  valor_unit  numeric(10,2) not null,
  desconto    numeric(10,2) not null default 0,
  pagamento   text not null,
  subtotal    numeric(10,2) not null,
  hora        text not null,
  created_at  timestamptz default now()
);

-- INVESTIMENTO (itens de alocação)
create table if not exists investimento_itens (
  id     text primary key default gen_random_uuid()::text,
  item   text not null,
  valor  numeric(10,2) not null
);

-- RLS: desabilitar (app próprio, sem auth de usuários)
alter table config              disable row level security;
alter table ingredientes        disable row level security;
alter table receitas            disable row level security;
alter table vendas              disable row level security;
alter table investimento_itens  disable row level security;

-- Dados iniciais de config
insert into config (key, value) values
  ('dias',          '["Sexta","Sábado","Domingo"]'),
  ('dia_atual',     '0'),
  ('custos_fixos',  '15'),
  ('margem_lucro',  '50'),
  ('invest_total',  '280')
on conflict (key) do nothing;

-- Dados iniciais: ingredientes
insert into ingredientes (id, nome, unidade, custo, estoque, minimo, fornecedor) values
  ('i1',  'Farinha de trigo',        'g',  0.006,  3000, 500, ''),
  ('i2',  'Açúcar',                  'g',  0.005,  2500, 400, ''),
  ('i3',  'Chocolate em pó/cacau',   'g',  0.030,  1200, 200, ''),
  ('i4',  'Chocolate para cobertura','g',  0.045,  1500, 300, ''),
  ('i5',  'Leite condensado',        'ml', 0.012,  1800, 300, ''),
  ('i6',  'Creme de leite',          'ml', 0.014,  1200, 200, ''),
  ('i7',  'Paçoca',                  'un', 0.600,    60,  10, ''),
  ('i8',  'Doce de leite',           'g',  0.020,  1000, 200, ''),
  ('i9',  'Polpa de maracujá',       'ml', 0.025,   800, 150, ''),
  ('i10', 'Ovos',                    'un', 0.700,    36,   6, ''),
  ('i11', 'Embalagem individual',    'un', 0.900,   150,  20, '')
on conflict (id) do nothing;

-- Dados iniciais: receitas
insert into receitas (id, nome, rendimento, preco_venda, ingredientes) values
  ('matilda','Matilda (chocolate c/ brigadeiro)',20,12,
   '[{"ing":"i1","qtd":600},{"ing":"i2","qtd":500},{"ing":"i3","qtd":200},{"ing":"i4","qtd":400},{"ing":"i5","qtd":600},{"ing":"i10","qtd":6}]'),
  ('pacoca','Paçoca',20,12,
   '[{"ing":"i1","qtd":500},{"ing":"i2","qtd":400},{"ing":"i7","qtd":20},{"ing":"i8","qtd":500},{"ing":"i5","qtd":300},{"ing":"i10","qtd":6}]'),
  ('maracuja','Chocolate com Maracujá',20,13,
   '[{"ing":"i1","qtd":550},{"ing":"i2","qtd":450},{"ing":"i3","qtd":180},{"ing":"i4","qtd":350},{"ing":"i9","qtd":400},{"ing":"i10","qtd":6}]')
on conflict (id) do nothing;

-- Dados iniciais: investimento
insert into investimento_itens (item, valor) values
  ('Chocolate/cacau',        90),
  ('Leite condensado/creme', 60),
  ('Embalagens e talheres',  50),
  ('Paçoca/amendoim',        40),
  ('Maracujá/frutas',        40)
on conflict do nothing;

