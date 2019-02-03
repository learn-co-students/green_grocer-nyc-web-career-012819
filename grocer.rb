require 'pry'

def consolidate_cart(cart_array)
  cart_array.inject(Hash.new) do |hash, item|
    if hash[item.keys[0]] == nil
      hash[item.keys[0]] = item.values[0].merge({ count: 1})
    else
      hash[item.keys[0]][:count] += 1
    end

    hash
  end
end

def apply_coupons(cart, coupons)
  coupon_item_names = coupons.map { |coupon| coupon.values.first }

  cart.inject(Hash.new) do |hash, item|
    item_name = item.first

    if coupon_item_names.include?(item_name)
      coupon = coupons.find { |coupon| coupon[:item] == item_name }

      hash[item_name] = item[1].clone
      hash[item_name][:count] %= coupon[:num]
      
      hash["#{item_name} W/COUPON"] = item[1].clone
      hash["#{item_name} W/COUPON"][:price] = coupon[:cost]
      hash["#{item_name} W/COUPON"][:count] = item[1][:count] / coupon[:num]
    else
      hash[item.first] = item[1]
    end

    hash
  end
end

def apply_clearance(cart)
  clearance_items = cart.select { |item_name, details| details[:clearance] == true }
  clearance_items.each { |item_name, details| !details[:price] = (details[:price] * 0.8).round(3) }
  cart
end

def checkout(cart, coupons)
  one_true_cart = apply_clearance( apply_coupons( consolidate_cart(cart), coupons) )
  last_check = sum_of(one_true_cart)
  last_check > 100.0 ? last_check * 0.9 : last_check
end

def sum_of(cart)
  cart.inject(0.0) do |total, item|
    total += (item[1][:price] * item[1][:count])
  end
end