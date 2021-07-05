require 'pry'

def consolidate_cart(cart)
  new_cart = {}
  cart.each_index do |index|
    cart[index].each do |item, info|
      count = cart.count {|x| x.include?(item)}
      cart[index][item][:count] = count
    end
  end
  cart.each do |member|
    new_cart.merge!(member)
  end
  new_cart
end

def apply_coupons(cart, coupons)
  cart.clone.each do |item, info|
    count = 0
    coupons.each do |hash|
      hash.each do |key, value|
        if(value == item && cart[item][:count] >= hash[:num])
          cart[item][:count] = cart[item][:count] - hash[:num]
          cart["#{item} W/COUPON"] = {}
          cart["#{item} W/COUPON"][:price] = hash[:cost]
          cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
          if cart[item][:count] < 0
              cart[item][:count] = 0
          end
          if hash[:item] = item
            count += 1
          end
            cart["#{item} W/COUPON"][:count] = count
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    info.each do |key, value|
      if (key == :clearance && value == true)
        new_price = cart[item][:price] - (cart[item][:price] * 0.2)
        cart[item][:price] = new_price
      end
    end
  end
  cart
end

def checkout(cart, coupons)
  total_price = 0
  total = {}
  total = apply_coupons(consolidate_cart(cart), coupons)
  total = apply_clearance(total)
  total.map do |item, info|
    info.each do |key, value|
      if key == :price
      total_price += (value * total[item][:count])
      end
    end
  end
  if (total_price > 100)
    total_price = total_price - (total_price * 0.1)
  end
  total_price
end
