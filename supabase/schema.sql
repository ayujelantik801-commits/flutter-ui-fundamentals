create table public.courses (
  id bigint generated always as identity primary key,
  code text not null unique,
  title text not null,
  credits int not null check (credits > 0),
  status text not null default 'planned'
    check (status in ('planned', 'active', 'done')),
  created_at timestamptz not null default now()
);

insert into public.courses (code, title, credits, status) values
  ('MOB01', 'Git & GitHub', 3, 'done'),
  ('MOB02', 'Dart Fundamentals', 2, 'done'),
  ('MOB03', 'Flutter UI Fundamentals', 3, 'active'),
  ('MOB04', 'REST API & Backend', 3, 'planned'),
  ('MOB05', 'Mobile Testing', 3, 'planned');

alter table public.courses enable row level security;

create policy "lab: anon can read courses"
  on public.courses for select to anon using (true);

create policy "lab: anon can insert courses"
  on public.courses for insert to anon with check (true);

create policy "lab: anon can update courses"
  on public.courses for update to anon using (true) with check (true);

create policy "lab: anon can delete courses"
  on public.courses for delete to anon using (true);