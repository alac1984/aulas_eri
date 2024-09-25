drop table autor cascade;
drop table tipo_livro cascade;
drop table editora cascade;
drop table situacao cascade;
drop table livro cascade;
drop table aluno cascade;
drop table emprestimo cascade;
drop table estoque cascade;

create table if not exists autor (
    id_autor serial primary key,
    nome varchar(20) not null,
    sobrenome varchar(30) not null
);

create table if not exists tipo_livro (
    id_tipo_livro serial primary key,
    nome_tipo varchar(100)
);

create table if not exists editora (
     id_editora serial primary key,
     nome varchar(50) not null
);

create table if not exists situacao(
    id_situacao int primary key,
    descricao varchar(30)
);

create table if not exists livro (
    id_livro serial primary key,
    titulo varchar(200) not null,
    autor int,
    editora int,
    tipo_livro int,
    constraint fk_id_autor foreign key(autor) references autor(id_autor),
    constraint fk_id_editora foreign key(editora) references editora(id_editora),
    constraint fk_id_tipo foreign key(tipo_livro) references tipo_livro(id_tipo_livro)
);

create table if not exists aluno (
    id_aluno serial primary key,
    nome varchar(50),
    sobrenome varchar(50),
    endereco varchar(100),
    contato varchar(15)
);

create table if not exists estoque
(
    id_estoque    serial primary key,
    livro      int,
    situacao   int,
    constraint fk_id_livro foreign key (livro) references livro (id_livro),
    constraint fk_id_situacao foreign key (situacao) references situacao (id_situacao)
);

create table if not exists emprestimo (
    id_emprestimo serial primary key,
    estoque int,
    aluno int,
    data_emprestimo date,
    data_devolucao date,
    devolvido bool default false,
    constraint fk_id_aluno foreign key(aluno) references aluno(id_aluno),
    constraint fk_id_estoque foreign key(estoque) references estoque(id_estoque)
);


insert into autor (nome, sobrenome) values
('J.K.', 'Rowling'),
('George', 'Orwell'),
('J.R.R.', 'Tolkien'),
('Harper', 'Lee'),
('Gabriel', 'García Márquez');

insert into tipo_livro (nome_tipo) values
('Ficção'),
('Não-ficção'),
('Fantasia'),
('Romance'),
('Biografia');

insert into editora (nome) values
('Editora A'),
('Editora B'),
('Editora C'),
('Editora D'),
('Editora E');

insert into situacao (id_situacao, descricao) values
(1, 'Disponível'),
(2, 'Emprestado'),
(3, 'Perdido'),
(4, 'Danificado');

insert into livro (titulo, autor, editora, tipo_livro) values
('Harry Potter e a Pedra Filosofal', 1, 1, 3),
('1984', 2, 2, 1),
('O Senhor dos Anéis: A Sociedade do Anel', 3, 3, 3),
('O Sol é Para Todos', 4, 4, 4),
('Cem Anos de Solidão', 5, 5, 4);

insert into livro (titulo, autor, editora, tipo_livro) values
('Harry Potter e a Câmara Secreta', 1, 1, 3)
;

insert into aluno (nome, sobrenome, endereco, contato) values
('Carlos', 'Silva', 'Rua A, 123', '555-1234'),
('Ana', 'Oliveira', 'Rua B, 456', '555-5678'),
('Pedro', 'Santos', 'Rua C, 789', '555-9101'),
('Mariana', 'Costa', 'Rua D, 101', '555-1121'),
('João', 'Pereira', 'Rua E, 112', '555-3141');

insert into estoque (livro, situacao) values
(1, 1),
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1)
;

insert into emprestimo (estoque, aluno, data_emprestimo, data_devolucao, devolvido) values
(1, 1, '2024-07-01', '2024-07-15', false);

insert into emprestimo (estoque, aluno, data_emprestimo, data_devolucao, devolvido) values
(4, 1, '2024-07-01', '2024-07-15', false);

-- Agora temos uma missão:

-- A tabela estoque precisa ser atualizada toda vez que um empréstimo for feito. Como fazer isso? Precisamo usar um TRIGGER! Precisaremos de um trigger que dispare toda vez que houver uma inserção na tabela empréstimo. Quando houver inserção, o trigger deve alterar o status do item do estoque para emprestado.

create or replace function situacao_emprestimo()
-- Essa função é executada sempre que há um emprestimo de livros
returns trigger as $$
	begin
		update estoque
		set situacao = 2
		where id_estoque = new.estoque;
	return new;
	end;
$$ language plpgsql;

create trigger tg_situacao_emprestimo
after insert on emprestimo
for each row
execute function situacao_emprestimo();

-- Agora você tem uma missão
-- Quando um aluno devolve um livro, isso é anotado da seguinte forma:

select * from emprestimo;

update emprestimo
set devolvido = true
where id_emprestimo = 4;

-- Mas se você observar, fazer essa mudança no id_estoque = 4 não mudou a situacao do estoque
-- na tabela estoque

select * from estoque order by id_estoque;

-- Crie um trigger de nome tg_situacao_devolucao e uma função de nome situacao_devolucao
-- que rode toda vez que for feito um update na tabela emprestimo que setar um livro para
-- devolvido. Esse trigger deve alterar a situacao do livro para disponível.

create  or replace function situacao_devolucao()
--  função é executada sempre que há uma devolução de livros.
returns trigger as $$
	begin
		raise notice 'Passei aqui';
		if old.devolvido is false and new.devolvido is true then
			update estoque
			set situacao = 1
			where id_estoque = new.estoque;
		end if;
	return new;
	end;
$$ language plpgsql;

create trigger tg_situacao_devolucao
after update on emprestimo
for each row
execute function situacao_devolucao();

select * from emprestimo;

update emprestimo
set devolvido = true
where id_emprestimo = 1;

select * from estoque;

-- Outro teste: fazer outro tipo de update e ver o que acontece!

insert into emprestimo(estoque, aluno, data_emprestimo, data_devolucao, devolvido) values
(3, 4, '2024-08-10', '2024-08-12', false);

select * from emprestimo;

update emprestimo
set aluno = 5
where id_emprestimo = 2;

select * from estoque;

-- Pronto, muito bem!
-- Agora você vai criar um trigger para resolver o seguinte problema:
-- Quando um item do estoque é marcado como a situação perdido, ele deve ser inserido numa tabela chamada 'estoque_perdido'.
-- Essa tabela deverá ser igual a tabela estoque, com as mesmas colunas, e ela deve ser preenchida com todos os estoques
-- que forem perdidos ao longo do tempo. É importante entender que um estoque perdido tem que SAIR da tabela estoque e ser inserido
-- na tabela estoque_perdido.

create table if not exists estoque_perdido(
	id_estoque_perdido serial primary key,
	livro int,
	situacao int,
	constraint fk_id_livro foreign key (livro) references livro (id_livro),
	constraint fk_id_situacao foreign key (situacao) references situacao (id_situacao)
);

create or replace function situacao_perdido()
returns trigger as $$
	begin 
		if new.situacao = 3 then
			update estoque_perdido
			set situacao = 3
			where id_estoque_perdido = new.estoque;
		end if;
		return new;
	end;
$$ language plpgsql;

create trigger tg_situacao_perdido
after update on emprestimo
for each row
execute function situacao_perdido();

select * from emprestimo;
