
program mergesort;
const N = 6;
type arrays = array[1..N] of integer;
var main_arr:arrays;
var m:integer;

procedure input_arr(var arr:arrays);{ввод массива}
var i,val:integer;
begin

  for i:=1 to N do
    begin
      read(val);
      arr[i]:=val;
    end;
    writeln;

end;

procedure print_arr(arr:arrays;sorted:boolean);{печать массива}
var i:integer;
begin
  if sorted then
    write('отсортированный массив : ');
  for i:=1 to N do
    write(arr[i],' ');
  writeln;
end;

procedure null_arr(var arr:arrays); { приравнивает все элементы массива к нулю}
var i:integer;
begin
  for i:=1 to N do
    arr[i]:=0;
end;


function is_sorted(arr:arrays):boolean; {функция проверяющая отсортирован ли массив}
var res,to_break:boolean;
var i:integer;
begin
  i:=1;
  res:=true;
  to_break:=false;
  while (i<=N-1) and not(to_break) do
    begin
      if arr[i]<arr[i+1] then
        begin
          to_break:=true;
          res:=false
        end;
      i:=i+1;
    end;
  is_sorted:=res;
end;

{функция которая вычисляет границу просматриваемой последовательности (ищет отрезок невозрастания начиная с
cur_ind до lim_ind}
{to_right = true - просматриваем массив слева направо, false - наоборот}
function calc_border(arr:arrays;to_right:boolean;cur_ind,lim_ind:integer):integer;
begin

  if to_right then
    begin
      while (cur_ind<lim_ind-1) and (arr[cur_ind]>=arr[cur_ind+1]) do
        cur_ind:=cur_ind+1;
    end
  else
    begin
      while (cur_ind>lim_ind+1) and (arr[cur_ind]>=arr[cur_ind-1]) do
        cur_ind:=cur_ind-1
    end;
  calc_border:=cur_ind;
end;

{процедура отвечающая за слияние отрезков, и их запись в другой массив}
{в качестве параметров передаются два массива,индексы начала отрезков, количества элементов в
каждом отрезке, а также индекс, начиная с которого будут записываться элементы во второй массив}
procedure merge_sequences(var main_arr,aux_arr:arrays;ind1,ind2,el_count1,el_count2:integer;var write_ind,permutations:integer);
var ind_shift1,ind_shift2,i:integer;
var elem1,elem2:integer;
var count_sum:integer;
begin
  ind_shift1:=0;
  ind_shift2:=0;
  count_sum:=el_count1+el_count2;
  for i:=0 to (el_count1+el_count2-1) do
    begin
      if (el_count1>0) and (el_count2>0) then
        begin
          elem1:=main_arr[ind1+ind_shift1];
          elem2:=main_arr[ind2-ind_shift2];
          if elem1<=elem2 then
            begin
              aux_arr[write_ind+i]:=elem2;
              ind_shift2:=ind_shift2+1;
              el_count2:=el_count2-1;
            end
          else
            begin
              aux_arr[write_ind+i]:=elem1;
              ind_shift1:=ind_shift1+1;
              el_count1:=el_count1-1;
            end;
          permutations:=permutations+1;
        end
      else
        begin
          if (el_count1>0) then
            begin
              elem1:=main_arr[ind1+ind_shift1];
              ind_shift1:=ind_shift1+1;
              aux_arr[write_ind+i]:=elem1;
              el_count1:=el_count1-1;
            end
          else
            begin
              elem2:=main_arr[ind2-ind_shift2];
              ind_shift2:=ind_shift2+1;
              aux_arr[write_ind+i]:=elem2;
              el_count2:=el_count2-1;
            end;
          permutations:=permutations+1;


        end;
    end;
  write_ind:=write_ind+count_sum;


end;
{процедура выполняет один проход по массиву, заполняя вспомогательный массив}
procedure perform_cycle(var main_arr,aux_arr:arrays;var permutations:integer);
var b1,b2,b3,b4:integer;
var elem_count1,elem_count2:integer;
var write_ind:integer;
begin
  write_ind:=1;
  b1:=0;
  b2:=0;
  b3:=N+1;
  b4:=N+1;
  {в этом блоке проиходит вычисление границ последовательностей, стягивание последовательностей к центру массива}
  while ((b3-b2)<>1) and (abs(b3-b2)<12) do
    begin
      elem_count1:=0;
      elem_count2:=0;
      if (b3-b2)>=3 then
        begin
          b1:=b2+1;
          b4:=b3-1;
          elem_count1:=1;
          elem_count2:=1;
        end
      else
        begin
          b1:=b2+1;
          b4:=b3;
          elem_count1:=1;
        end;

      b2:=calc_border(main_arr,true,b1,b4);
      b3:=calc_border(main_arr,false,b4,b2);
      elem_count1:=elem_count1+(b2-b1);
      elem_count2:=elem_count2+(b4-b3);
      merge_sequences(main_arr,aux_arr,b1,b4,elem_count1,elem_count2,write_ind,permutations);

    end;



end;
{основная процедура}
procedure merge_sort(var main_arr:arrays);
var aux_arr:arrays;
var arr_num:1..2;
var to_break:boolean;
var steps,permutations:integer;
begin
  to_break:=false;
  steps:=0;
  permutations:=0;
  {переменная нужна для того чтобы программа понимала, какой массив мы будем сортировать(т.к массивы чередуются}
  arr_num:=1;
  null_arr(aux_arr);
  while not(to_break) do
    begin
      if arr_num=1 then
        to_break:=is_sorted(main_arr)
      else
        to_break:=is_sorted(aux_arr);

      if not(to_break) then
        begin
          steps:=steps+1;
          if arr_num=1 then
            begin
              perform_cycle(main_arr,aux_arr,permutations);
              print_arr(aux_arr,false);
              arr_num:=2;
            end
          else
            begin
              perform_cycle(aux_arr,main_arr,permutations);
              arr_num:=1;
              print_arr(main_arr,false);
            end;

        end;



    end;
  if arr_num=2 then
    main_arr:=aux_arr; {если у нас оказался отсортирован вспомогательный массив, мы копируем его в главный}

  writeln('количество итераций: ',steps);
  writeln('количество перестановок: ', permutations);
  writeln;
  print_arr(main_arr,true);

end;

{1 2 3 4 5 6 - массив который отсортируется за одну итерацию}
begin
  writeln('Введите массив длиной 6');
  input_arr(main_arr);
  write('исходный массив: ');
  print_arr(main_arr,false);
  merge_sort(main_arr);

end.
