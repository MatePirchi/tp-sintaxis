echo 'compilar flex'
lex srcF.l
echo 'compilar bison'
bison -yd srcB.y
echo 'compilar c'
gcc y.tab.c  lex.yy.c -o salida
echo 'ejecutar salida'
./salida prueba1.m