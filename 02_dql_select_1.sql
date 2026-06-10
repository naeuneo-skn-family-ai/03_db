/* SQL(Structured Query Language)
   - 구조화 된 질의 언어
   - RDBMS에서 저장된 데이터를 관리, 조작하거나
     DB 구조를 제어할 때 사용하는 언어

## SQL의 종류
   - DQL (Data Query Language)
     - 데이터 질의어
     - 테이블의 데이터를 검색/조회
     - SELECT
   - DML (Data Manipulation Language)
     - 데이터 조작 언어
     - 테이블에 저장된 값을 삽입, 수정, 삭제
     - INSERT, UPDATE, DELETE
   - DDL (Data Definition Language)
     - 데이터 정의 언어
   - DCL (Data Control Language)
     - 데이터 제어 언어
   - TCL (Transaction Control Language)
     - 트랜잭션 제어 언어
 */

 # DQL구조
/*
    select 컬럼명 (5)  -- 필수
    from 테이블 (1)  -- 필수
    where 조건절(필터링) (2)
    group by 그룹핑 (3)
    having 조건절(그룹핑에 대해 필터링) (4)
    order by 정렬기준 (6)
    limit 행수제한 (7)

    1. SELECT : 조회하고자 하는 컬럼명을 기술함. 여러개를 기술하고자 하면 쉼표(,)로 구분하고 모든 컬럼 조회시 '*'을 사용
    2. FROM : 조회 대상 컬럼이 포함된 테이블명을 기술
    3. WHERE :
        행을 선택하는 조건을 기술함.
        여러 개의 제한 조건을 포함할 수 있으며, 각각의 제한 조건은 논리 연산자로 연결함
        제한조건을 만족시키는 행들만 Result Set에 포함됨
    4. ORDER BY : 정렬할 컬럼을 기준으로 오름/내림차순 지정
    5. GROUP BY : 행을 그룹핑함
    6. HAVING : 그룹핑된 행을 선택하는 조건을 기술함
*/

# tbl_menu (메뉴 테이블)의 모든 (*) 컬럼 조회
select
    *
from
    tbl_menu;

# 메뉴 테이블에서 메뉴명, 가격 조회
select
    menu_name, menu_price
from
    tbl_menu;

## 조회되는 칼럼에서 연산 가능
# 메뉴 테이블에서 메뉴명, 가격, 부가세(10%), 부가세 포함 전체 가격
select
    menu_name,
    menu_price,
    menu_price * 0.1,
    menu_price + menu_price * 0.1
from
    tbl_menu;

# ==============================================================
# RESULT SET : SELECT 조회 결과 행의 집합
# 컬럼명 as 별칭 : ResultSet에 표기되는 컬럼명에 별칭(alias) 부여 가능
# ==============================================================

select
    menu_name as 메뉴명,
    menu_price as "메뉴 가격", # 쌍 따옴표를 이용해서 띄어쓰기 된 칼럼 묶기
    menu_price * 0.1 부가세,
    menu_price + menu_price * 0.1 "부가세 포함 가격"
from
    tbl_menu;

# 산술 연산
select
    10 + 3,
    10 - 3,
    10 * 3,
    10 / 3,
    10 div 3, # pyrhon == // (몫)
    10 % 3,
    10 mod 3 # % == modulo (나머지)

# 문자열 연결 처리 (이어 쓰기)
# concat('abc', 'def') = 'abcdef'
# 메뉴 테이블에서 메뉴명, 메뉴 가격(원)
select
    menu_name,
    concat('금 ', menu_price, '원') as "메뉴 가격 (원)"
from
    tbl_menu;

# DISTINCT 컬럼 값 중복 제거
# - 지정된 컬럼의 값이 중복되는 행을 제거해서 조회
select
    distinct category_code
from tbl_menu;


# ==============================================================
# order by 절
# - 조회 결과(ResultSet)의 정렬 순서를 지정하는 구문
# - 특정 컬럼을 기준으로 삼아서 오름차순(ASC), 내림차순(DESC)
# - 기준으로 삼은 컬럼이 여러 개 존재하면 그룹화된 정렬이 수행된다.
# ==============================================================

# 메뉴 테이블을 조회 (가격 오름차순)
select
    menu_name,
    menu_price
from
    tbl_menu
order by menu_price asc;

# 메뉴 테이블을 조회 (가격 내림차순)
select
    menu_name,
    menu_price
from
    tbl_menu
order by menu_price desc;

# 문자열(유니코드 순서), 날짜(과거~미래)도 정렬 기준이 될 수 있다
# 메뉴명 오름차순
select
    menu_name
from
    tbl_menu
order by
    menu_name asc;

# select 절에 작성되지 않은 컬럼도 정렬 기준이 될 수 있다
select
    menu_name
from
    tbl_menu
order by
    menu_price asc;

# 기준으로 삼은 컬럼이 여러 개 존재하면 그룹화된 정렬이 수행
# 메뉴 테이블에서
# 메뉴명, 카테고리 코드, 가격을 조회
# 단, 카테고리 코드 오름차순, 가격 내림차순으로
# 1) 카테고리 코드로 오름차순 정렬을 먼저 수행
# 2) 같은 카테고리 코드를 지닌 행들끼리 붙어 있게 됨
# 3) 같은 카테코리 코드를 지닌 행 내에서 가격 내림차순 정렬
select
    menu_name,
    category_code,
    menu_price
from
    tbl_menu
order by
    category_code asc, menu_price desc;