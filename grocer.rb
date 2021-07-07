def consolidate_cart(cart)
  cart_hash = Hash.new
  cart.each do |item_hash|
    item_hash.each do |item, detail_hash|
      if cart_hash.key?(item)
        cart_hash[item][:count] += 1
      else
        cart_hash[item] = detail_hash
        cart_hash[item][:count] = 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
 coupons.each do |coupon|
    item = coupon[:item]
    if cart[item] && cart[item][:count] >= coupon[:num]
      cart[item][:count] -= coupon[:num]
      
      if cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"][:count] += 1
      else
        cart["#{item} W/COUPON"] = {:price => coupon[:cost], :count => 1, :clearance => cart[item][:clearance]}
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance]
      ans = info[:price] * 0.8
      info[:price] = ans.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consolidated_cart, coupons)
  finalized_cart = apply_clearance(applied_coupons)
  
  total = 0
  finalized_cart.each do |item, info|
    total += info[:price] * info[:count]
  end
  
  if total > 100
    total *= 0.9
  end
  total
end
