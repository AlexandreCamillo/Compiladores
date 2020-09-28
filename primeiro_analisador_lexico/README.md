# Primeiro Analisador Léxico

## Um arquivo LEX que reconhece os tokens descritos a seguir:

||||
|--- |--- |--- |
|**Token**|**Lexemas**|**Padrão**|
|_ID|a b _1 ab1  $tab   _$5|'$', letra ou '_' seguido por letra, dígito, '$' ou '_'|
|_INT|1 221 0|Números inteiros|
|_FLOAT|0.1 1.028 1.2E-4  0.2e+3 1e3|Números de ponto flutuante e  em notação científica|
|_FOR|for For fOr|for, case insensitive|
|_IF|if IF|if, case insensitive|
|_MAIG|>=|>=|
|_MEIG|<=|<=|
|_IG|==|==|
|_DIF|!=|!=|
|_COMENTARIO|/* Um comentário */     /* Outro comentário */// Comentário até o final da linha// /*Esse comentário anula o início/* Esse comentário foi terminado! // */|Um comentário pode se extender por mais de uma linha, e não pode haver comentário dentro de comentário. Não deve juntar comentários que estão separados.|
|_STRING|"hello, world"   "Aspas internas com \" (contrabarra)""ou com "" (duas aspas)"|Uma string começa e termina com aspas. Se houver aspas dentro da string devemos usar contrabarra ou duas aspas. Uma string não pode ir além do final da linha.|
||||

## Identificadores dos Tokens
Quando um token for identificado, o analisador irá retornar o valor referente ao token baseado no `enum`:
```c
enum TOKEN { _ID = 256, _FOR, _IF, _INT, _FLOAT, _MAIG, _MEIG, _IG, _DIF, _STRING, _COMENTARIO };
```

## Comandos

A compilação pode ser feita com o seguinte comando:
```sh
$ make build
```
Arquivos gerados pela compilação podem ser removidos com:
```sh
$ make clean
```

É possível testar o analisador com:
```sh
$ ./vpl_execution
```
