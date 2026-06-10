-- Q1
/*
 재직 중이고 휴대폰 마지막 자리가 2인 직원 중 입사일이 가장 최근인 직원 3명의 사원번호, 직원명, 전화번호, 입사일, 퇴직여부를 출력하세요.
- 참고. 퇴사한 직원은 퇴직여부 컬럼값이 ‘Y’이고, 재직 중인 직원의 퇴직여부 컬럼값은 ‘N’
 */
select
    EMP_ID,
    EMP_NAME,
    PHONE,
    HIRE_DATE,
    ENT_YN
from
    employee
where
    ENT_YN = 'N' # 재직중
and
    PHONE like '%2' # 전화번호 마지막 2
order by
    HIRE_DATE desc 
limit 3;


-- Q2
# '대리' : JOB_CODE = J6
/*
 재직 중인 ‘대리’들의 직원명, 직급명, 급여, 사원번호, 이메일, 전화번호, 입사일을 출력하세요.
 단, 급여를 기준으로 내림차순 출력하세요.
 */

# 조인 쓰는 버전

select
    JOB_NAME,
    SALARY,
    EMP_ID,
    EMAIL,
    PHONE,
    HIRE_DATE
from employee e
join job j on e.JOB_CODE = j.JOB_CODE
where
    e.ENT_YN = 'N'
and
    j.JOB_CODE = 'J6'
order by
    SALARY desc;