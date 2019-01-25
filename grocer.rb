require "pry"

def consolidate_cart(cart)
  new_list = {}
  cart.each do |elements|
    elements.each do |key, value|
      if new_list[key]
        value[:count] += 1
      else
        value[:count] = 1
        new_list[key] = value
      end
    end
  end
  new_list
  # new_list = {}
  # counter = 0
  # check_list = cart[0]
  # cart.each do |elements|
  #   new_list[elements.keys[0]] = elements[elements.keys[0]]
  #   binding.pry
  #   if check_list.keys == elements.keys
  #     counter +=1
  #     new_list[new_list.keys[0]][:count] = counter
  #   else
  #     counter = 1
  #     check_list = elements
  #     new_list[elements.keys[0]][:count] = counter
  #   end
  # end
  # new_list
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    coupon_name = name + " W/COUPON"
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart[coupon_name]

        cart[coupon_name][:count] += 1
      else

        cart[coupon_name] = {count: 1, price: coupon[:cost] }
        cart[coupon_name][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -=  coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item_name, des|
    if  cart[item_name][:clearance] == true
      cost = cart[item_name][:price]
      discount = cost * 0.2
      dicounted_cost = 0
      discounted_cost = cost - discount
      cart[item_name][:price] = discounted_cost
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  new_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(new_cart, coupons)
  final_cart = apply_clearance(coupon_cart)
  total_cost = 0
  final_cart.each do |keys, values|
    total_cost += values[:price] * values[:count]
  end
  total_cost = total_cost * 0.9 if total_cost > 100
  binding.pry
  total_cost
end
