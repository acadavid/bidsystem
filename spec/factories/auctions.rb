FactoryGirl.define do
  factory :auction do
    item_name "Derp item"
    current_price 50
    active true
  end

  factory :auction_with_auctioner, :parent => :auction do
    user
  end

end
