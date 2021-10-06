create table aluno (
    aluno_mat int primary key,
    aluno_nome varchar(100) not null,
    aluno_endereco varchar(100) not null,
    aluno_cidade varchar(30) not null
);

create table disciplina (
    disc_cod varchar(4) primary key,
    disc_nome varchar(50) not null,
    disc_carg_hor int not null
);

create table professor (
    prof_cod int primary key,
    prof_nome varchar(100) not null,
    prof_endereco varchar(100) not null,
    prof_cidade varchar(30) not null
);

create table turma (
    turma_cod int,
    t_disc_cod varchar(4),
    t_prof_cod int,
    turma_ano int,
    turma_horario varchar(8) not null,
    
    primary key(turma_cod, t_disc_cod, t_prof_cod, turma_ano),
    foreign key(t_disc_cod) references disciplina (disc_cod),
    foreign key(t_prof_cod) references professor (prof_cod)
);

create table historico (
    h_aluno_mat int,
    h_turma_cod int,
    h_disc_cod varchar(4),
    h_prof_cod int,
    h_turma_ano int,
    hist_frequencia int not null,
    hist_nota float not null,
    
    primary key(h_aluno_mat, h_turma_cod, h_disc_cod, h_prof_cod, h_turma_ano),
    foreign key(h_aluno_mat) references aluno (aluno_mat),
    foreign key(h_turma_cod, h_disc_cod, h_prof_cod, h_turma_ano) references turma (turma_cod, t_disc_cod, t_prof_cod, turma_ano)
);

insert into aluno values (2015010101, 'Jose De Alencar', 'Rua Das Almas', 'Natal');
insert into aluno values (2015010102, 'João José', 'Avenida Ruy Carneiro', 'João Pessoa');
insert into aluno values (2015010103, 'Maria Joaquina', 'Rua Carrossel', 'Recife');
insert into aluno values (2015010104, 'Maria Das Dores', 'Rua Das Ladeiras', 'Fortaleza');
insert into aluno values (2015010105, 'Josué Claudino Dos Santos', 'Centro', 'Natal');
insert into aluno values (2015010106, 'Josuélisson Claudino Dos Santos', 'Centro', 'Natal');

insert into disciplina values ('BD', 'Banco De Dados', 100);
insert into disciplina values ('POO', 'Programação Com Acesso A Banco De Dados', 100);
insert into disciplina values ('WEB', 'Autoria Web', 50);
insert into disciplina values ('ENG', 'Engenharia De Software', 80);

insert into professor values (212131, 'Nickerson Ferreira', 'Rua Manaíra', 'João Pessoa');
insert into professor values (122135, 'Adorilson Bezerra', 'Avenida Salgado Filho', 'Natal');
insert into professor values (192011, 'Diego Oliveira', 'Avenida Roberto Freire', 'Natal');

insert into turma values (1, 'BD', 212131, 2015, '11H-12H');
insert into turma values (2, 'BD', 212131, 2015, '13H-14H');
insert into turma values (1, 'POO', 192011, 2015, '08H-09H');
insert into turma values (1, 'WEB', 192011, 2015, '07H-08H');
insert into turma values (1, 'ENG', 122135, 2015, '10H-11H');

insert into historico values (2015010101, 1, 'BD', 212131, 2015, 80, 8.0);
insert into historico values (2015010101, 1, 'POO', 192011, 2015, 90, 8.5);
insert into historico values (2015010101, 1, 'WEB', 192011, 2015, 75, 7.0);
insert into historico values (2015010101, 1, 'ENG', 122135, 2015, 90, 9.0);
insert into historico values (2015010102, 1, 'BD', 212131, 2015, 90, 8.5);
insert into historico values (2015010102, 1, 'POO', 192011, 2015, 90, 7.0);
insert into historico values (2015010102, 1, 'WEB', 192011, 2015, 95, 7.5);
insert into historico values (2015010102, 1, 'ENG', 122135, 2015, 90, 8.0);
insert into historico values (2015010103, 1, 'BD', 212131, 2015, 87, 9.5);
insert into historico values (2015010103, 1, 'POO', 192011, 2015, 80, 9.0);
insert into historico values (2015010103, 1, 'WEB', 192011, 2015, 95, 9.0);
insert into historico values (2015010103, 1, 'ENG', 122135, 2015, 78, 9.0);
insert into historico values (2015010104, 2, 'BD', 212131, 2015, 90, 10.0);
insert into historico values (2015010105, 2, 'BD', 212131, 2015, 75, 6.5);
insert into historico values (2015010106, 2, 'BD', 212131, 2015, 94, 7.5);

# Questões
/* a) Encontre a aluno_mat dos alunos com nota em BD em 2015 menor que 5 (obs: BD = código da disciplina). */
select aluno_mat as matricula, aluno_nome as nome, hist_nota as nota
from aluno join historico on aluno_mat = h_aluno_mat
where hist_nota < 5 and h_disc_cod = 'BD' and h_turma_ano = 2015;

/* b) Encontre a aluno_mat e calcule a média das notas dos alunos na disciplina de POO em 2015. */
select disc_nome as nome, round(avg(hist_nota), 2) as media_notas
from disciplina join historico on disc_cod = h_disc_cod
where h_disc_cod = 'POO' and h_turma_ano = 2015;

/* c) Encontre a aluno_mat e calcule a média das notas dos alunos na disciplina de POO em 2015 e que esta média seja superior a 6. */
select disc_nome as nome, round(avg(hist_nota), 2) as media_notas
from disciplina join historico on disc_cod = h_disc_cod
where h_turma_ano = 2015 and h_disc_cod = 'POO' having(avg(hist_nota)) > 6;

/* d) Encontre quantos alunos não são de Natal. */
select * from aluno where aluno_cidade != 'Natal';
