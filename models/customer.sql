with 
    markup as (
     select *, 
    first_value(customer_id)
    over(partition by company_name, contact_name
    order by company_name
    rows between unbounded preceding and unbounded following) as result
    from {{source('sources', 'customers')}}
)
    , remove_duplicatas as (
        select distinct result from markup

)
    , final as (
        select * from {{source('sources', 'customers')}} where customer_id in (select result from remove_duplicatas)
    )

select
    *
from final
