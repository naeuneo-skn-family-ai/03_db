# DDL (Data Definition Language)
# - 데이터베이스 스키마(객체_를
#   만들고(CREATE), 수정하고(ALTER), 삭제(DROP)하는 구문
# - DDL 구문은 실행시 바로 DB에 반영된다

# [주의사항]
# *** 절대 DML과 DDL을 혼용해서 작성하지 말자 ***
# 1. DML 구문 수행 -> 트랜잭션에 담김
# 2. 중간에 DDL구문 수행
# 3. 트랜잭션 내용이 자동 COMMIT

# =======================================================
### create table
/* [작성법]
    create table [if not exists] 테이블명(
      컬럼1 자료형 [제약조건|auto increment] [default] [comment],
      컬럼2 자료형 [제약조건] [default] [comment],
      컬럼3 자료형 [제약조건] [default] [comment],
      ...
   );
 */

# auto_increment : 숫자 자동 증가 옵션
# 기본적으로 PK 컬럼에만 사용 가능

create table product(
    id int primary key auto_increment comment '상품식별코드',
    name varchar(100) not null comment '상품명',
    price int not null default  0 comment '가격',
    created_at datetime default current_timestamp comment '상품등록일시'
);

# 생성한 테이블 조회
select * from product;

# 생성한 DDL 구문 확인
show create table product;


# 생성한 테이블 설명 조회
desc product;

# 테이블의 메타정보를 조회하는 구문
select
    *
from
    information_schema.tables
where
    TABLE_SCHEMA = 'menudb'
and
    TABLE_NAME = 'product';

# product 테이블에 데이터 추가 (INSERT)
insert into product(name) values ('텀블러');
insert into product(name, price) values ('머그컵', 5000);

select * from product;

commit;

# =======================================================
# 제약조건 (constraint)
# - 테이블 컬럼에 붙어
#   INSERT, UPDATE 시 각 컬럼에 기록되는 값에 대한 조건을 설정하는 방법
# - 데이터 무결성을 보장하는 목적으로 사용
# - 종류 : NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK


# 제약조건 확인 방법
desc product;

select
    *
from
    information_schema.table_constraints
where
    constraint_schema = 'menudb'
and
    table_name = 'tbl_menu';


# NOT NULL : 지정된 컬럼은 NULL일 수 없다 == 값 필수
# UNIQUE : 지정된 컬럼에는 중복되는 값을 저장할 수 없다


# UNIQUE 제약조건 위배
DROP TABLE IF EXISTS user_unique;
CREATE TABLE IF NOT EXISTS user_unique (
    user_no INT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255)
    # , UNIQUE (phone)
) ENGINE=INNODB;

INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_unique;

# UNIQUE 제약조건 위배
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');

# phone 값 변경 -> UNIQUE 제약 조건 위배 해결
# + NOT NULL 제약조건 위배
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, null, 'pass03', '이순신', '남', '010-777-8888', 'lee222@gmail.com');

# NOT NULL 제약조건 해결
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user03', 'pass03', '이순신', '남', '010-777-8888', 'lee222@gmail.com');

select * from user_unique;

# PRIMARY KEY (** 중요 **)
# - 테이블 내 행을 구별하기 위한 식별자 역할의 컬럼에 추가하는 제약조건
# - NOT NULL + UNIQUE 특징을 가짐 : 중복되지 않는 값 필수
# - PRIMARY KEY 는 테이블 내의 1개만 설정 가능
#   단, PK 설정이 적용되는 컬럼은 1개 또는 여러개 묶음(복합키) 가능

DROP TABLE IF EXISTS user_primarykey;
CREATE TABLE IF NOT EXISTS user_primarykey (
--     user_no INT PRIMARY KEY,
    user_no INT,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    PRIMARY KEY (user_no)
) ENGINE=INNODB;

INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_primarykey;

desc user_primarykey;

# PK 컬럼에 NULL 작성
# [23000][1048] Column 'user_no' cannot be null
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(null, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');

# PK 컬럼에 중복값 작성
# [23000][1062] Duplicate entry '2' for key 'user_primarykey.PRIMARY'
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(2, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');


### PK 복합키 확인
create table order_composite_pk (
    user_id int,
    prod_id int,
    count int default 1,
    ordered_at datetime default (current_timestamp),
    primary key(user_id, prod_id, ordered_at)
);
insert into order_composite_pk
values (1, 1, 10, now());
insert into order_composite_pk
values (2, 1, 5, now());
insert into order_composite_pk
values (3, 100, default, now());


# pk 컬럼 3개 값이 모두 일치하는 중복 데이터 삽입
# [23000][1062] Duplicate entry '3-100-2026-06-12 11:31:42' for key 'order_composite_pk.PRIMARY'
insert into order_composite_pk
(select * from order_composite_pk where user_id = 3);


### FOREIGN KEY (외래키)
# - 참조(REFERENCE)된 다른 테이블에서 제공하는 값만 사용 가능
# - 참조 무결성을 위배하지 않기 위해 사용
# - 다른 테이블의 PK또는 UNIQUE가 설정된 컬럼만 참조 가능하다
# - FK 제약조건 설정시 두 테이블 간의 관계(RELATIONSHIP)이 형성된다

# - 부모 테이블 : 참조를 당해서 컬럼값을 제공하는 테이블
# - 자식 테이블 : 참조를 이용해서 다른 테이블의 컬럼값을 사용하는 테이블
# - 제공되는 값 외에 NULL 사용 가능

DROP TABLE IF EXISTS user_grade;
CREATE TABLE IF NOT EXISTS user_grade (
    grade_code INT NOT NULL UNIQUE,
    grade_name VARCHAR(255) NOT NULL
) ENGINE=INNODB;

INSERT INTO user_grade
VALUES
(10, '일반회원'),
(20, '우수회원'),
(30, '특별회원');

SELECT * FROM user_grade;