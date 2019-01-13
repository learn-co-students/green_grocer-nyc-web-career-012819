require'pry'

def consolidate_cart(cart)
  new_cart={}
    cart.collect do |item|
      item.collect do |item_name, info|
        info.collect do |detail, amount|
        if new_cart[item_name]
          new_cart[item_name][detail]=amount
          new_cart[item_name][:count]=cart.count(item)
        else
          new_cart[item_name]={detail=>amount}
        end
      end
    end
  end
  return new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |items|
    name = items[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  new_cart=cart
  cart.each do |x,y|
    if cart[x][:clearance]==true
      new_cart[x][:price]-=new_cart[x][:price]*0.20
    end
  end
  new_cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |name,property|
      total += property[:price] * property[:count]
  end
  total = total * 0.9 if total > 100
  total
  end
