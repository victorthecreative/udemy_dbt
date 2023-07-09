WITH
    prod as (
        select 
            ct.category_name
            ,sp.company_name as suppliers
            ,pd.product_name
            ,pd.unit_price
            ,pd.product_id
        from {{source("sources","products")}} as pd
        left join {{source("sources","suppliers")}} as sp ON (pd.supplier_id = sp.supplier_id)
        left join {{source("sources","categories")}} as ct  ON (pd.category_id = ct.category_id)
    )
    ,orderdetail as (
        select
            pd.*
            ,od.order_id
            ,od.quantity
            ,od.discount
        from {{ref("orderdetails")}}  od
        left join prod as pd on (od.product_id = pd.product_id)
    )
    ,ordrs as (
        select
            ord.order_date
            ,ord.order_id
            ,cs.company_name as customer
            ,em.name as employee
            ,em.age
            ,em.lengthofservice    
        from {{source("sources","orders")}} ord
        left join {{ref("customer")}} as cs on (ord.customer_id = cs.customer_id)
        left join {{ref("employees")}} as em on (ord.employee_id = em.employee_id)
        left join {{source("sources","shippers")}} as sh on (ord.ship_via = sh.shipper_id)
    )
    ,final_join as (
        select
            od.*
            ,ord.order_date
            ,ord.customer
            ,ord.employee
            ,ord.age
            ,ord.lengthofservice
        from orderdetail as od
        inner join ordrs as ord on (od.order_id = ord.order_id)
    )
select
*
from
 final_join
limit 3000