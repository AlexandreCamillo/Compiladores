#!/bin/bash
output=""
expected=""
isConsole="false"
dust=" undefined: undefined;"
while read input; do 
  if [[ $input == "=== Console ===" ]]; then
    isConsole="true";
  fi
  if [[ $isConsole == "true" ]]; then
    input=$(sed "s/$dust/ /g" <<< "$input")
    output="${output}\n${input}" ;
  fi
done
while read input; do
  expected="${expected}\n${input}" ;
done < testes2/$1/output.txt
arg1=$(sed "s/\n/ /g" <<< "$output")
arg2=$(sed "s/\n/ /g" <<< "$expected")

cond=$(diff -w <(echo "$arg1") <(echo "$arg2"))

if [[ $cond == "" ]]; then
  echo "# Teste $1 passou"
else
  echo -e "\n##############################"
  echo -e "\nFALHOU # $1"
  echo -e "\nEsperado:"
  echo -e $expected
  echo -e "\nEncontrado:"
  echo -e $output
  echo -e "##############################"
fi