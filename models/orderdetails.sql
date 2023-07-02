with
    calculadas as (
        select  
            s.order_id,
            s.product_id,
            s.unit_price,
            s.quantity,
            a.product_name,
            a.supplier_id,
            a.category_id,
            s.unit_price * s.quantity as total,
            (a.unit_price - s.quantity) - total as discount
        from {{source('sources', 'order_details')}} as s
        left join {{source('sources', 'products')}} as a
        on (s.product_id = a.product_id)
    )

select * from calculadas