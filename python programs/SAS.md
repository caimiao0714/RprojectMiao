<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>

<div class='altmetric-embed' data-badge-type='donut' data-doi="10.1212/WNL.0000000000200546"></div>

# sas macro

data test;
 input id $ group $ t0 :yymmdd10. hx_a :yymmdd10. hx_b :yymmdd10. hx_c :yymmdd10. oc_a :yymmdd10. oc_b :yymmdd10. oc_c :yymmdd10.;
    format t0 hx_a hx_b hx_c oc_a oc_b oc_c yymmdd10.;
    cards;
1 treat 2022/01/01 . . 2021/01/01 2022/06/30 . .
2 treat 2022/01/01 2021/01/01 . . . . 2022/09/30
3 treat 2022/01/01 . 2021/01/01 . . . .
4 control 2022/01/01 2021/01/01 . 2021/01/01 . 2022/04/30 .
5 control 2022/01/01 . 2021/01/01 . 2022/01/30 . .
6 control 2022/01/01 . . . 2023/01/30 2022/08/01 .
;
run;

proc contents data=test out=list(keep=NAME) order=varnum noprint;
 run;

data list;
 set list;
 if  find(NAME,"hx_")>0;
 variable=scan(NAME,-1,"_");
run;

proc sql noprint;
 select count(*) into:varnum from list;
 select variable into:var_1 -:%sysfunc(compress(var_&varnum.)) from list;
 quit;
data table;
 length group$8. total 8. case1 8. case2 8. case3 8. disease $8.;
 stop;
run;
%macro test;
%do n =1 %to &varnum.;
 proc sql noprint;

 create table &&var_&n.. as
 select group,
  count(*) as total,
     sum(case when . < oc_&&var_&n..-t0 <= 30 then 1 else 0 end) as case1,
        sum(case when 30 < oc_&&var_&n..-t0 <= 180 then 1 else 0 end) as case2,
        sum(case when 180 < oc_&&var_&n..-t0 <= 360 then 1 else 0 end) as case3,
  "&&var_&n.." as disease
 from test
 where missing(hx_&&var_&n..)
 group by group
 ;
 quit;

 data table;
  set table &&var_&n..;
 run;
%end;
%mend;

%test;

