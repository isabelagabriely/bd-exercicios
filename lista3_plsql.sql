create table produto (
    id number(4) primary key,
    nome varchar2(120) not null,
    preco number(6,2) not null,
    
    constraint unique_nome_produto unique(nome)
);

insert into produto values (1, 'Caneta', 2.50);
insert into produto values (2, 'Papel', 12.30);
insert into produto values (3, 'Borracha', 0.45);
insert into produto values (4, 'Lápis', 1.50);
insert into produto values (5, 'Pincél', 6);

create table pessoa (
    id number(4) primary key,
    nome varchar2(120) not null,
    
    constraint unique_nome_pessoa unique(nome)
);

insert into pessoa values (1, 'João Silva');
insert into pessoa values (2, 'Maria Silva');
insert into pessoa values (3, 'Claudia Souza');
insert into pessoa values (4, 'Jurema Pachoal');
insert into pessoa values (5, 'André Paulo');

-- 1) Crie um script que crie as SEQUENCEs para as tabelas do enunciado.
create sequence seq_produto
    minvalue 1
    maxvalue 999
    start with 6
    increment by 1;
    
create sequence seq_pessoa
    minvalue 1
    maxvalue 999
    start with 6
    increment by 1;
    
-- 2) Desenvolva um script que cria uma tabela nova chamada LOG_PRODUTO que deverá conter: ID, ID_PRODUTO, PRECO_ANTES, PRECO_DEPOIS, DATA_ALTERACAO. Criar as devidas referências de PRIMARY KEY e FOREIGN KEY, e SEQUENCE, quando aplicável.
create table log_produto (
    id number primary key,
    id_produto number,
    preco_antes number(6,2),
    preco_depois number(6,2),
    data_alteracao date,
    
    constraint fk_id_prod foreign key (id_produto) references produto(id)
);

create sequence seq_log_prod
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
    
-- 3) Criar um Trigger que preencha a tabela LOG_PRODUTO toda vez que o valor de um poduto for alterado.
create or replace trigger trigger_log_produto
after update of preco on produto
for each row
declare
        data_atual date;
begin
    select to_date(sysdate, 'DD/MM/YYYY') into data_atual from dual;
    insert into log_produto values (seq_log_prod.nextval, :old.id, :old.preco, :new.preco, data_atual);
end;

-- 4) Criar um pacote, chamado PESSOA_ADMIN, que deverá implementar:
--    Uma função para incluir uma nova pessoa e retornar o ID da pessoa nova;
--    Uma procedure que exclui uma pessoa;
--    Uma procedure que recebe um ID como parâmetro de entrada e retorna o nome da pessoa como parâmetro de saída.
create sequence seq_id_pessoa
    minvalue 1
    maxvalue 999999
    start with 6
    increment by 1;

create or replace package pessoa_admin as
    function incluir_pessoa(nome_pessoa varchar2) return number;
    procedure excluir_pessoa(id_pessoa number);
    procedure retornar_nome(id_pessoa number, nome_pessoa out varchar2);
end pessoa_admin;

create or replace package body pessoa_admin as
    function incluir_pessoa(nome_pessoa varchar2)
    return number
        is 
            id_pessoa number;
        begin
            insert into pessoa values (seq_id_pessoa.nextval, nome_pessoa);
            return id_pessoa;
        end;
        
    procedure excluir_pessoa(id_pessoa number)
    is
        cont number;
        begin
            select count(*) into cont from pessoa where id = id_pessoa;
            
            if cont = 1 then
                delete from pessoa
                where id = id_pessoa;
            
            else
                dbms_output.put_line('ID não encontrado.');
                
            end if;
        end;
        
    procedure retornar_nome(id_pessoa number, nome_pessoa out varchar2)
    is
        begin
            select nome into nome_pessoa from pessoa
            where id = id_pessoa;
            
            exception
            when no_data_found then
                nome_pessoa := 'Pessoa não encontrada.';
        end;
end pessoa_admin;

-- testando o package pessoa_admin

declare
    pessoa_nome varchar2(120);

begin
    dbms_output.put_line(pessoa_admin.incluir_pessoa('Isabela Sousa'));
    pessoa_admin.excluir_pessoa(10);
    pessoa_admin.retornar_nome(5, pessoa_nome);
    dbms_output.put_line(pessoa_nome);
end;

select * from pessoa;