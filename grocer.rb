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
  coupons.each do |item_name|
    item = item_name[:item]
    if cart[item] && cart[item][:count] >= item_name[:num]
      if cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"][:count]+=1
      else
        cart["#{item} W/COUPON"]={:count=>1, :price=> item_name[:cost],:clearance=> cart[item][:clearance]}
      end
      cart[item][:count]-= item_name[:num]
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
  last_cart = apply_clearance(couponed_cart)
  total = 0
  last_cart.each do |item,detail|
      total += detail[:price] * detail[:count]
  end
    if total > 100
      total = total * 0.9
end
  total
end
