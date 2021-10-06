-- 1. Criar uma procedure que receba um código de pessoa como parâmetro de entrada e através de um parâmetro de saída retorne o nome da pessoa. Caso, o código seja inexistente, retorne: Pessoa não encontrada.

create table pessoa (
    id number(4) primary key,
    nome varchar2(120) not null,
    
    constraint unique_nome_pessoa unique(nome)
);

insert into pessoa (id, nome) values (1, 'João Silva');
insert into pessoa (id, nome) values (2, 'Maria Silva');
insert into pessoa (id, nome) values (3, 'Claudia Souza');
insert into pessoa (id, nome) values (4, 'Jurema Paschoal');
insert into pessoa (id, nome) values (5, 'André Paulo');


create procedure nome_pessoa(pessoa_id number, pessoa_nome out varchar2)
is 
    
    begin
        select nome into pessoa_nome from pessoa where id = pessoa_id;
        
        exception
            when no_data_found then
                pessoa_nome := 'Pessoa não encontrada.';
    end;


declare
    pessoa_nome varchar2(120);

begin
    nome_pessoa(NULL, pessoa_nome);
    dbms_output.put_line(pessoa_nome);
end;


-- 2. Criar uma função que receba como parâmetro de entrada o código do produto e o número que representa o percentual de aumento do produto em questão.

create table produto (
    id number(4) primary key,
    nome varchar(120) not null,
    preco number(6, 2) not null,
    
    constraint unique_nome_produto unique(nome)
);

insert into produto values (1, 'Caneta', 2.50);
insert into produto values (2, 'Papel', 12.30);
insert into produto values (3, 'Borracha', 0.45);
insert into produto values (4, 'Lápis', 1.50);
insert into produto values (5, 'Pincel', 6);


create function alterar_preco(codigo number, percentual number)
    return varchar2
    is mensagem varchar2(30) := 'Preço alterado.';
    
    cont number;
    
    begin
        select count(*) into cont from produto where id = codigo;
        
        if cont = 1 then
            update produto
            set preco = preco + preco * percentual / 100
            where id = codigo;
            
        else
            mensagem := 'Produto não encontrado.';
            
        end if;
        
        return mensagem;
    end;


begin
    dbms_output.put_line(alterar_preco(3, 100));
end;

select * from produto;


-- 3. Criar um bloco PL/SQL anônimopara imprimir a tabuada.

begin 
    for i in 1..10 loop
        dbms_output.put_line('tabuada ' || i);
        for j in 1..10 loop
            dbms_output.put_line(i || 'x' || j || '=' || i*j);
        end loop;
        dbms_output.put_line('---');
    end loop;
end;


-- 4. Criar um bloco PL/SQL para apresentar os anos bissextos entre 2000 e 2100. Um ano será bissexto quando for possível dividi‐lo por 4, mas não por 100 ou quando for possível dividi‐lo por 400.

begin
    for i in 2000..2100 loop
        if mod(i, 4) = 0 and mod(i, 100) != 0 or mod(i, 400) = 0 then
            dbms_output.put_line(i);
        end if;
    end loop;
end;


-- 5. Criar um bloco PL/SQL para imprimir a sequência de Fibonacci: 0 1 1 2 3 5 8 13 21 34 55

declare
    f1 number(2) := 1;
    f2 number(2) := 1;
    fib number(2) := 0;

begin
    for i in 1..11 loop
        f1 := f2;
        f2 := fib;
        dbms_output.put_line(fib);
        fib := f1 + f2;
    end loop;
end;


-- 6. Criar uma função que deverá receber um número inteiro e retornar se o mesmo é primo ou não.

create function e_primo(numero number)
    return varchar2
    is mensagem varchar2(15) := 'É primo';
    
    begin
        for i in 2..numero-1 loop
            if mod(numero, i) = 0 then
                mensagem := 'Não é primo';
            end if;
        end loop;
        
        return mensagem;
    end;


begin   
    dbms_output.put_line(e_primo(31));
end;


-- 7. Criar uma função que deverá receber um valor correspondente à temperatura em graus Fahrenheit e retornar o equivalente em graus Celsius. Fórmula para conversão: C = (F ‐32) / 1.8

create or replace function converter_celsius(fahrenheit number)
    return number
    is celsius number;
    
    begin
        celsius := (fahrenheit - 32) / 1.8;
        return celsius;
    end;


begin   
    dbms_output.put_line(converter_celsius(88.7));
end;

