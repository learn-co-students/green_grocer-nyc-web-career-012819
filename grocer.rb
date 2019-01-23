require "pry"

def consolidate_cart(cart)
  # code here
  new_hash = {}
  cart.each do |x|
    x.each do |item, properties|
        if !new_hash.keys.include?(item)
          new_hash[item] = {count: 1}
        else
          new_hash[item][:count] += 1
        end
        properties.each do |property, value|
          new_hash[item][property] = value
        end
      end
    end
    new_hash
  end



def apply_coupons(cart, coupons)
  # code here
  new_hash = {}
  cart.each do |item, properties|
  coupon_count = 0
  coupons.each do |x|
      if x[:item] == item
        coupon_count += 1
        new_hash["#{item} W/COUPON"] = {price: x[:cost], clearance: properties[:clearance], count: coupon_count}
        properties[:count] -= x[:num]
      end
    end
  end
  cart.merge(new_hash)
end

def apply_clearance(cart)
  # code here
  cart.each do |item, properties|
      if properties[:clearance]
        properties[:price] = (properties[:price]*0.8).round(2)
      end
    end
  end

def checkout(cart, coupons)
  # code here
  total = 0
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  new_cart.each do |item, properties|
    total += properties[:price]*properties[:count]
  end
  if total > 100
    total = total*0.9
  end
  total
end
