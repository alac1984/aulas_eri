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

insert into aluno (nome, sobrenome, endereco, contato) values
('Carlos', 'Silva', 'Rua A, 123', '555-1234'),
('Ana', 'Oliveira', 'Rua B, 456', '555-5678'),
('Pedro', 'Santos', 'Rua C, 789', '555-9101'),
('Mariana', 'Costa', 'Rua D, 101', '555-1121'),
('João', 'Pereira', 'Rua E, 112', '555-3141');

insert into emprestimo (id_livro, aluno, data_emprestimo, data_devolucao, devolvido) values
(1, 1, '2024-07-01', '2024-07-15', true),
(2, 2, '2024-07-05', '2024-07-20', true),
(3, 3, '2024-07-10', '2024-07-25', false),
(4, 4, '2024-07-12', '2024-07-28', true),
(5, 5, '2024-07-15', null, false);

-- AQUECIMENTO

-- Q1) Liste todos os livros, mostrando o título, o nome completo do autor (nome e sobrenome) e o nome da editora.

select
    titulo,
    a.nome nome_autor,
    a.sobrenome sobrenome_autor,
    e.nome nome_editora
from livro
    join autor as a on a.id_autor = livro.autor
    join editora as e on livro.editora = e.id_editora
;

-- Q2) Encontre todos os empréstimos que ainda não foram devolvidos. Mostre o título do livro, o nome do aluno (nome e sobrenome) e a data de empréstimo.

select
    l.titulo titulo_livro,
    a.nome nome_aluno,
    a.sobrenome sobrenome_aluno,
    data_emprestimo
from emprestimo
join aluno a on emprestimo.aluno = a.id_aluno
join livro l on emprestimo.id_livro = l.id_livro
where devolvido = false;

-- Q3) Liste todos os livros de um determinado tipo, como "Fantasia". Mostre o título do livro e o nome completo do autor.

select
    titulo titulo_livro,
    a.nome nome_autor,
    a.sobrenome sobrenome_autor,
    tl.nome_tipo tipo
from livro
join autor a on livro.autor = a.id_autor
join tipo_livro tl on livro.tipo_livro = tl.id_tipo_livro
where nome_tipo = 'Fantasia'
;

-- Q4) Encontre os autores que têm mais de um livro cadastrado no sistema. Mostre o nome completo do autor e o número de livros que ele possui.
-- todos os livros estao relacionados cada 1 com um autor unico. anular essa questao ein kkkkk 5 livroscom 5 autores diferentes.
select
    titulo,
    a.nome nome_autor,
    a.sobrenome sobrenome_autor,
    sum(autor)
from livro
join autor a on livro.autor = a.id_autor
group by titulo, a.nome, a.sobrenome
order by a.nome, a.sobrenome desc limit 1
;

-- Q5) Liste todos os alunos que já pegaram emprestado um livro do tipo "Romance". Mostre o nome do aluno, sobrenome e o título do livro emprestado.

-- ALTERAÇÕES NO BANCO

-- Q6)  A nossa tabela livro representa um exemplar do livro na biblioteca. Mas na nossa biblioteca cada livro tem um número de registro, no formato REG-00000 (quando o livro é comprado pela universidade) ou DOA-00000 (quando o livro foi doado por alguém). Esses números são únicos, ou seja, não há dois livros com número de registro igual. O que fazer para dar de conta dessa lógica?

-- Q7) Agora que nosso livro possui um número de registro, vamos inserir números de registro para os items que não possuímos.

-- Q8) A tabela livro não possui ligação com a tabela situação, ou seja, não temos como cadastrar a situação dos livros. Faça a conexão correta entre essas tabelas e estabeleça para todos os livros atuais o estado de DISPONÍVEL, logo após limpar a tabela de empréstimos.

-- Q9) Agora, faça 2 empréstimos e uma devolução, atribuindo na devolução o status de DANIFICADO para o livro.
