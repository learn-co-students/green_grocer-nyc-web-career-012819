def consolidate_cart(cart)
  new_cart = {}
  cart.each_with_index do |hash, ind|
    hash.each do |food, value|
    if new_cart[food]
      new_cart[food][:count] += 1
    else
      new_cart[food] = value
      new_cart[food][:count] = 1
    end
  end
end      
  new_cart
end

def apply_coupons(cart, coupons)
  result= {}
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if result["#{food} W/COUPON"]
          result["#{food} W/COUPON"][:count] += 1
        else
          result["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    result[food] = info
  end
  result
end

def apply_clearance(cart)
  cart.each do |food, info|
    if info[:clearance] == true
      info[:price] = info[:price] - (info[:price] * 0.2)
    end
  end
  cart
end

def checkout(cart = [], coupons = [])
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |food, value|
    total += (value[:price] * value[:count])
  end
  if total > 100
    final = total - (total * 0.1) 
  else
    final = total
end
final
end