require "pry"

def consolidate_cart(cart)
  new_list = {}
  counter = 0
  check_list = cart[0]
  cart.each do |elements|
    new_list[elements.keys[0]] = elements[elements.keys[0]]
    if check_list.keys == elements.keys
      counter +=1
      new_list[new_list.keys[0]][:count] = counter
    else
      counter = 1
      check_list = elements
      new_list[elements.keys[0]][:count] = counter
    end
  end
  new_list
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
  # binding.pry
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item_name, des|
    if  cart[item_name][:clearance] == true
      cost = cart[item_name][:price]
      discount = cost*20/100
      dicounted_cost = 0
      discounted_cost = cost - discount
      cart[item_name][:price] = discounted_cost
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  cost = {}
  # binding.pry
  cart.each do |items|
    items.each do |item_name, des|
      coupons.each do |coupon|
        if (item_name == coupons[:item]) && items[item_name][:count] >= coupons[:num]
          no_of_coupons_applied = (items[item_name][:count])/coupons[:num]
          no_coupons_not_applied = (items[item_name][:count])%coupons[:num]
          cost["after_coupon"] = ((no_of_coupons_applied * coupons[:cost])+ (no_coupons_not_applied * items[item_name][:price]))

        else
          cost["normal_cost"] = (items[item_name][:count] * items[item_name][:price])
          binding.pry
        end
      end
    end
  end
end
