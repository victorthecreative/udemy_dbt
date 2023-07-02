with
    calculadas as (
        select 
            first_name|| ' ' || last_name name,
            date_part(year, current_date) - date_part(year, birth_date) age,
            date_part(year, current_date) - date_part(year, hire_date) lengthofservice
            ,*
        from {{source('sources', 'employees')}}
)

select * from calculadas 


