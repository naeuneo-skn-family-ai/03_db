# 내장 함수
# - mysql dbms에 이미 구현된 함수
# - 문자형, 숫자형, 날짜형별 함수가 따로 제공
# - 반드시 반환값을 갖는다.

### 문자열 관련 함수
# ASCII : 아스키 코드 값 추출
# CHAR : 아스키 코드로 문자 추출
select ascii('A'), char(65);


# 문자 인코딩 : 컴퓨터 내에서 문자를 표시하는 방법
# UTF-8 : 아스키코드 문자는 1byte, 나머지는 3byte 표시 (mysql 차용)
# UTF-16 : 모든 문자를 2byte(16bit)로 표시

# BIT_LENGTH : 할당된 비트 크기 반환 (1byte = 8bit)
# CHAR_LENGTH : 문자열의 크기 반환
# LENGTH : 할당된 BYTE 크기 반환
select
    bit_length('pie'),
    char_length('pie'),
    length('pie');

select menu_name,
       char_length(menu_name),
       length(menu_name),
       bit_length(menu_name)
from
    tbl_menu;

# CONCAT : 문자열을 이어 붙임
# CONCAT_WS : 구문자와 함께 문자열을 이어 붙임
select concat('호랑이', '기린', '토끼')
select concat_ws(',', '호랑이', '기린', '토끼')
select concat_ws('-', '2023', '05', '31')


# INSTR(기준 문자열, 부분(검색) 문자열)
# - 기준 문자열에서 부분 문자열의 시작 위치 반환
select instr('사과딸기바나나', '딸기') # 3
select instr('사과딸기바나나', '포도') # 0 (없음)

# 메뉴 테이블에서 메뉴명에 '마늘'이 포함된 메뉴만 조회
select
    *
from
    tbl_menu
where
    # menu_name like '%마늘%'
    instr(menu_name, '마늘') > 0;

select * from tbl_menu;


# LPAD : 문자열을 길이만큼 왼쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
# RPAD : 문자열을 길이만큼 오른쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
select lpad('왼쪽', 6, '@'), rpad('오른쪽', 6, '@')
select lpad('오이잉', 5, '@')


# SUBSTRING : 시작 위치부터 길이만큼의 문자를 반환
# (길이를 생략하면 시작 위치부터 끝까지 반환)
select substring('안녕하세요 반갑습니다', 7, 2),
       substring('안녕하세요 반갑습니다', 7),
       substring('안녕하세요 반갑습니다', instr('안녕하세요 반갑습니다', '반갑'))


# CELING : 올림값 반환
# FLOOR : 내림값 반환
# ROUND : 반올림값 반환
# TRUNCATE(숫자, 소수점자리) : 버림
select ceiling(1234.56),
       floor(1234.56),
       round(1234.56),
       truncate(1234.56, 0);

select ceiling(-1.5), # -1
       floor(-1.5), # -2
       round(-1.5), # -2
       truncate(-1.5, 0); # -1

select truncate(1234.56, 1),
       truncate(1234.56, 0),
       truncate(1234.56, -1), # 1의 자리 버림 (0으로 바꿈)
       truncate(1234.56, -2); # 10의 자리 버림


# RAND : 0 이상 1 미만의 실수를 구한다
select rand(),
       rand(),
       rand();


# 1~45 사이 난수 1개
# 0.0 <= rand() < 1.0
# 0.0 <= rand() * 45 < 45.0
# 1.0 <= rand() * 45 < 46.0
# 1 <= floor(rand() * 45 + 1) < 46
select floor(rand() * 45 + 1);


# ===========================================================
# 날짜 관련 함수

# NOW() : 현재 시간
# addDate(date, 차이)
# subDate(date, 차이)

select now(),
       addDate(now(), 1),
       subDate(now(), 1),
       addDate(now(), interval 1 month), # day, month, year, week
       subDate(now(), interval 1 month);


# DATEDIF(날짜1, 날짜2) : 날짜1 - 날짜2의 일수 반환
# TIMEDIF(시간1 - 시간2) : 시간1 - 시간2의 결과를 반환
select
    datediff('2026-11-20', now()),
    timediff('17:07:11', '13:06:10')


# extract(단위 from date)
# - date에서 해당하는 단위를 추출
# - 단위 : year, quater, month, week
#          day, hour, minute, second, microsecond

select
    now(),
    extract(year from now()),
    extract(month from now()),
    extract(day from now());


# date_format(datetime, 형식문자열) -> 문자열
select
    date_format(now(), '%y/%m/%d'), # 26/06/11
    date_format(now(), '%Y-%m-%d'), # 2026-06-11
    date_format(now(), '%h:%i');

# str_to_date(문자열, 형식문자열) -> datetime
select
    str_to_date('25/04/21', '%y/%m/%d'),
    str_to_date('2025/04/21', '%Y/%m/%d'),   # '/'
    cast('2025/04/21' as date); -- 날짜시간형식 유추가 가능한 경우

# 기타함수
# null처리 함수 - ifnull(값, null일때 값)
select
    ifnull(ref_category_code, '미지정') category_code
from
    tbl_category;

# 삼항연산처리 - if(조건식, 참일때 값, 거짓일때 값)
select
    isnull(ref_category_code),
    if(isnull(ref_category_code), '미지정', category_code) category_code
from
    tbl_category;

select
    menu_name,
    menu_price,
    if(menu_price < 10000, '싼', '비싼') as price_clf
from
    tbl_menu;