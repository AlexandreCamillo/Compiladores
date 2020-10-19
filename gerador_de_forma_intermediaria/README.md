# Gerador de Forma Intermediária

## Um arquivo lex que gera código em forma intermediária
O código gerado está em [notação polonesa reversa](https://pt.wikipedia.org/wiki/Nota%C3%A7%C3%A3o_polonesa_inversa)

## Exemplos
> **Ps:** Não há pulo de linha nos outputs reais, nos exemplos está assim para melhor entendimento do funcionamento do tradutor
### Exemplo 1
Input:
```
a = "hello";
b = a + " world" + "!";
print b;
```
Output:
```
a "hello" = 
b a @ "world" + "!" + = 
b @ print #
```

### Exemplo 2
Input:
```
x = 3.14;
a = max( 2, 3 * 7 + x );
print a;
```
Output:
```
x 3.14 =
a 2 3 7 * x @ + max # =
a @ print #
```

## Notações
 - O símbolo **@** será usado para buscar o valor de uma variável na tabela de variáveis.
 - O símbolo **#** será usado para chamar uma função na tabela de funções.

## Como utilizar

A compilação pode ser feita com o seguinte comando:
```sh
$ make build
```
Arquivos gerados pela compilação podem ser removidos com:
```sh
$ make clean
```

É possível testar o tradutor com:
```sh
$ ./tradutor
```
