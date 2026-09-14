PRODUCT_SELECT = """
    SELECT item.item_no, item.item_type, item.item_category, item.item_name,
           item.item_description, item.made_in, item.display_tone, item.display_type,
           item.product_tag, price.rate, price.previous_price, price.currency
    FROM bus_item_master AS item
    INNER JOIN bus_price_list AS price ON price.item_no = item.item_no
    WHERE item.active_status = 'Y' AND price.active_status = 'Y'
"""
