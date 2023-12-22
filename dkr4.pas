uses Crt, GraphABC;

const
  NORM = 12; // цвет невыделеного пункта 
  SEL = 10; // цвет выделенного пункта 
  Num = 3; //3 пункта меню

var
  menu: array[1..Num] of string[24];//названия пунктов меню
  punkt: integer;
  ch: char;
  xmenu, ymenu, TextAttr: byte;
  a, b, c, x, d, ff, s, dx, dy: real;
  n: integer;

function f(xx: real): real;
begin
  f := 1 * xx * xx * xx + (-1) * xx * xx + (-2) * xx + 15;
end;

function perv(xx: real): real;
begin
  perv:= ((b**4)/4 - (2*b**3)/3 - (5*b**2)/2 + b) - ((a**4)/4 - (2*a**3)/3 - (5*a**2)/2 + a);
end;

function trapezoidMethod(a, b: real; n: integer): real;
var
  c, s, x: real;
  i: integer;
begin
  c := (b-a)/n;
  x:= a;
  d:= f(a) + f(b);
  for i:= 1 to n-1 do
  begin
    x:= x + c;
    d := d + 2 * f(x);
  end;
  trapezoidMethod:= d * c / 2;
end;

procedure calculateIntegral;
var
  integral, error: real;
begin
  writeln('Введите границы интегрирования: ');
  readln(a, b);
  writeln('Введите количество промежутков: ');
  readln(n);

  integral := trapezoidMethod(a, b, n);
  error := (b-a) * (b-a) * (b-a) * (b-a) / 12 * (b-a) / (n * n) * 5; { Вычисление погрешности }

  writeln('Интеграл равен: ', integral:0:3);
  writeln('Погрешность: ', error:0:3);
end;

procedure punkt1;
begin
  ClrScr;
  calculateIntegral;
  writeln;
  writeln('Процедура завершена вот такие пироги. Нажмите <Enter> для продолжения.');
  repeat
    ch := readkey;
  until ch = #13;
end;

procedure information;
begin
  setfontsize(11);
  setfontcolor(clblack);
  if not ((a = 0) and (b = 0)) then
  begin
    writeln('Нижний предел: ', a);
    writeln('Верхний предел: ', b);
    writeln('Площадь фигуры: ', s:0:3);
    writeln('Погрешность: ', perv(x)-s);
    end
  else writeln('Вы не ввели данные для интегрирования');
end;

procedure punkt2;

const
  W = 1000; H1 = 600; // Размеры графического окна

var
  x0, y0, x, y, xLeft, yLeft, xRight, yRight, ng: integer;
  ag, bg, fmin, fmax, x1, y1, mx, my, num, dx, dy, h: real;
  i: byte;
  s: string;

begin
  SetConsoleIO;
  textcolor(12);
  clrscr;
  Writeln('Введите нижнюю границу системы координат по Х: ');
  read(ag);
  Writeln('Введите верхнюю границу системы координат по Х: ');
  read(bg);
  Writeln('Введите единичный отрезок по Х: ');
  read(dx);
  Writeln('Введите нижнюю границу системы координат по Y: ');
  read(fmin);
  Writeln('Введите верхнюю границу системы координат по Y: ');
  read(fmax);
  Writeln('Введите единичный отрезок по Y: ');
  read(dy);
  Writeln('Введите ширину трапеции: ');
  read(h);
  writeln;
  clrscr;
  textcolor(norm);
  Writeln('Нажмите [Enter] и откройте графическое окно');
  repeat
    ch := readkey;
  until ch = #13;
  SetGraphabcIO;
  SetWindowSize(W, H1); // Устанавливаем размеры графического окна
  xLeft := 250;
  yLeft := 50;
  xRight := W - 50;
  yRight := H1 - 50;

  clearwindow;
  mx := (xRight - xLeft) / (bg - ag); // Масштаб по Х
  my := (yRight - yLeft) / (fmax - fmin); // Масштаб по Y
  
  x0 := round(abs(ag) * mx) + xLeft;
  y0 := yRight - round(abs(fmin) * my);

  line(xLeft, y0, xRight + 10, y0); // Ось OX
  line(x0, yLeft - 10, x0, yRight); // Ось OY
  SetFontSize(15); 
  SetFontColor(clSlateGray);
  TextOut(xRight + 20, y0 - 15, 'х');
  TextOut(x0 - 10, yLeft - 30, 'у');
  SetFontSize(10);
  SetFontColor(clGray); 
  setbrushcolor(clWhite);

  //ng := round((bg - ag) / dx) + 1; // Количество засечек по ОХ
  for i := 1 to ng do
  begin
    //num := ag + (i - 1) * dx; // Координата на оси ОХ
    x := xLeft + round(mx * (num - ag));
    Line(x, y0 - 3, x, y0 + 3);
    str(Num:0:1, s);
    if abs(num) > 1E-15 then // Исключаем 0 на оси OX
      TextOut(x - TextWidth(s) div 2, y0 + 10, s)
  end;

  //ng := round((fmax - fmin) / dy) + 1; // Количество засечек по OY
  for i := 1 to ng do
  begin
    y := yRight - round(my * (num - fmin));
    Line(x0 - 3, y, x0 + 3, y);
    str(num:0:0, s);
    if abs(num) > 1E-15 then // Исключаем 0 на оси OY
      TextOut(x0 + 7, y - TextHeight(s) div 2, s)
  end;
  TextOut(x0 - 10, y0 + 10, '0'); // Нулевая точка

  x1 := ag;
  while x1 <= bg do
  begin
    y1 := f(x1); 
    x := x0 + round(x1 * mx);  
    y := y0 - round(y1 * my); 
    SetPixel(x+20, y, clBlack);
    x1 := x1 + 0.001
  end;
  line(x0 + round(b*mx), y0, x0 + round(b*mx), y0 - round(f(b)*my), clBlack); // х = b
  setbrushstyle(bsHatch);
  setbrushhatch(bhPercent10);
  setbrushcolor(clRed);
  x1 := b;
  var hhru : real := (b-a)/h;
  var xxx : real := a - hhru;
  for i := 1 to n do
  begin
    xxx := xxx + hhru;
    line(x0 + round(a*mx) + round(xxx*mx),y0-round(f(xxx)*my),x0 + round(a*mx) + round(xxx*mx),y0);
    line(x0 + round(a*mx) + round(xxx*mx),y0-round(f(xxx)*my),x0 + round(a*mx) + round((xxx+hhru)*mx),y0-round(f(xxx+hhru)*my));
    
  end;
  line(x0 + round(a*mx) + round((xxx+hhru)*mx),y0-round(f(xxx +hhru)*my),x0 + round(a*mx) + round((xxx + hhru)*mx),y0);
  setbrushcolor(clWhite);
  information;
end;


procedure MenuToScr;// вывод меню на экран 
var
  i: integer;
begin
  SetConsoleIO;
  ClrScr;
  for i := 1 to Num do
  begin
    GoToXY(xmenu, ymenu + i - 1);
    write(menu[i]);
  end;
  TextColor(SEL);
  GoToXY(xmenu, ymenu + punkt - 1);
  write(menu[punkt]);// выделим строку меню 
  TextColor(NORM);
end;

begin
  SetConsoleIO;
  ClrScr;
  menu[1] := ' Начать интегрирование ';
  menu[2] := ' Смотреть график ';
  menu[3] := ' Выход ';
  punkt := 1; xmenu := 5; ymenu := 5;
  TextColor(NORM);
  MenuToScr;
  repeat
    ch := ReadKey;
    if ch = #0 then begin
      ch := ReadKey;
      case ch of
        #40:// стрелка вниз 
          if punkt < Num then begin
            GoToXY(xmenu, ymenu + punkt - 1); write(menu[punkt]);
            punkt := punkt + 1;
            TextColor(SEL);
            GoToXY(xmenu, ymenu + punkt - 1); write(menu[punkt]);
            TextColor(NORM);
          end;
        #38:// стрелка вверх 
          if punkt > 1 then begin
            GoToXY(xmenu, ymenu + punkt - 1); write(menu[punkt]);
            punkt := punkt - 1;
            TextColor(SEL);
            GoToXY(xmenu, ymenu + punkt - 1); write(menu[punkt]);
            TextColor(NORM);
          end;
      end;
    end
    else
    if ch = #13 then begin// нажата клавиша <Enter> 
      case punkt of
        1: punkt1;
        2: punkt2;
        3: CloseWindow;// выход 
      end;
      MenuToScr;
    end;
  until ch = #27;
end.