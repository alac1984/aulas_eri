drop table autor cascade;
drop table tipo_livro cascade;
drop table editora cascade;
drop table situacao cascade;
drop table livro cascade;
drop table aluno cascade;
drop table emprestimo cascade;

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

create table if not exists emprestimo (
    id_emprestimo serial primary key,
    id_livro int,
    aluno int,
    data_emprestimo date,
    data_devolucao date,
    devolvido bool,
    constraint fk_id_aluno foreign key(aluno) references aluno(id_aluno),
    constraint fk_id_livro foreign key(id_livro) references livro(id_livro)
);

-- Inserir dados na tabela autor
insert into autor (nome, sobrenome) values
('J.K.', 'Rowling'),
('George', 'Orwell'),
('J.R.R.', 'Tolkien'),
('Harper', 'Lee'),
('Gabriel', 'García Márquez');

-- Inserir dados na tabela tipo_livro
insert into tipo_livro (nome_tipo) values
('Ficção'),
('Não-ficção'),
('Fantasia'),
('Romance'),
('Biografia');

-- Inserir dados na tabela editora
insert into editora (nome) values
('Editora A'),
('Editora B'),
('Editora C'),
('Editora D'),
('Editora E');

-- Inserir dados na tabela situacao
insert into situacao (id_situacao, descricao) values
(1, 'Disponível'),
(2, 'Emprestado'),
(3, 'Perdido'),
(4, 'Danificado');

-- Inserir dados na tabela livro
insert into livro (titulo, autor, editora, tipo_livro) values
('Harry Potter e a Pedra Filosofal', 1, 1, 3),
('1984', 2, 2, 1),
('O Senhor dos Anéis: A Sociedade do Anel', 3, 3, 3),
('O Sol é Para Todos', 4, 4, 4),
('Cem Anos de Solidão', 5, 5, 4);

-- Inserir dados na tabela aluno
insert into aluno (nome, sobrenome, endereco, contato) values
('Carlos', 'Silva', 'Rua A, 123', '555-1234'),
('Ana', 'Oliveira', 'Rua B, 456', '555-5678'),
('Pedro', 'Santos', 'Rua C, 789', '555-9101'),
('Mariana', 'Costa', 'Rua D, 101', '555-1121'),
('João', 'Pereira', 'Rua E, 112', '555-3141');

-- Inserir dados na tabela emprestimo
insert into emprestimo (id_livro, aluno, data_emprestimo, data_devolucao, devolvido) values
(1, 1, '2024-07-01', '2024-07-15', true),
(2, 2, '2024-07-05', '2024-07-20', true),
(3, 3, '2024-07-10', '2024-07-25', false),
(4, 4, '2024-07-12', '2024-07-28', true),
(5, 5, '2024-07-15', null, false);

-- 01. ENTENDENDO O BANCO

-- Q1)