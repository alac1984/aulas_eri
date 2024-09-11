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
    devolvido bool,
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

select * from estoque order by id_estoque;
select * from emprestimo;

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
