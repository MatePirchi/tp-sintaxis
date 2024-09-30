echo 'compilar bison'
bison -yd srcBison.y
echo 'compilar flex'
lex srcFlex.l
echo 'compilar c'
gcc y.tab.c  lex.yy.c -o salida
echo 'ejecutar salida'
./salida prueba1.m