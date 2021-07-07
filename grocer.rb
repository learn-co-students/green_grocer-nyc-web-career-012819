require 'pry'
def consolidate_cart(cart)
  gcart = {}
  count = 1
  cart.each do |x|
    x.each do |item,data|
      if !gcart.has_key?(item)
        gcart[item] = data.merge({:count => 1})
      else 
        gcart[item][:count] += 1
      end
      
    end
  end
  gcart
end


def apply_coupons(cart, coupons)
  new_hash = {}
  cart.each do |name,info|
    coupons.each do |coupon|
      if name == coupon[:item] && info[:count] >= coupon[:num]
      info[:count] -= coupon[:num]
        if new_hash["#{name} W/COUPON"]
           new_hash["#{name} W/COUPON"][:count] += 1
        else
          new_hash["#{name} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    new_hash[name] = info
  end
  new_hash
end
        

def apply_clearance(cart)
  new = {}
  cart.each do |x,y|
    if y[:clearance] == true
      y[:price]= (y[:price]*0.8).round(2)
      new[x]=y
    else
      new[x] = y
    end
  end
  new
end


def checkout(cart, coupons)
  a = consolidate_cart(cart)
  b = apply_coupons(a, coupons)
  c = apply_clearance(b)
  total = 0
  c.each do |item,data|
    total += data[:price] * data[:count]
  end
  if total > 100
    total = total * 0.9
  end
  total
end
