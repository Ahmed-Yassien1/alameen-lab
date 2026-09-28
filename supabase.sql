create extension if not exists "uuid-ossp";

create table patients (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  phone text unique not null,
  gender text,
  age int,
  address text,
  created_at timestamp default now()
);

create table test_categories (
  id uuid primary key default uuid_generate_v4(),
  name text not null
);

create table tests (
  id uuid primary key default uuid_generate_v4(),
  category_id uuid references test_categories(id),
  name text not null,
  price numeric not null,
  unit text,
  normal_range text,
  duration text
);

create table devices (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  model text,
  last_maintenance date,
  next_maintenance date,
  status text default \'نشط\'
);

create table visits (
  id uuid primary key default uuid_generate_v4(),
  patient_id uuid references patients(id) on delete cascade,
  visit_date timestamp default now(),
  status text default \'تم السحب\',
  total_price numeric default 0
);

create table visit_tests (
  id uuid primary key default uuid_generate_v4(),
  visit_id uuid references visits(id) on delete cascade,
  test_id uuid references tests(id),
  result_value text
);

alter table patients enable row level security;
alter table visits enable row level security;
alter table tests enable row level security;
alter table visit_tests enable row level security;
alter table devices enable row level security;

create policy "allow all" on patients for all using (true) with check (true);
create policy "allow all" on visits for all using (true) with check (true);
create policy "allow all" on tests for all using (true) with check (true);
create policy "allow all" on visit_tests for all using (true) with check (true);
create policy "allow all" on devices for all using (true) with check (true);

insert into test_categories (name) values (\'صورة دم\'), (\'كيمياء\'), (\'هرمونات\');
insert into tests (name, price, unit, normal_range, duration) values 
(\'صورة دم كاملة CBC\', 150, \'10^9/L\', \'4.5 - 11.0\', \'24 ساعة\'),
(\'سكر صائم\', 50, \'mg/dL\', \'70 - 100\', \'ساعتين\');
