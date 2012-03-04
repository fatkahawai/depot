require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end    
  
  test "product price must be positive" do
    product = Product.new(:title => "test",
                          :description => "test",
                          :image_url => "test.jpg", 
                          :price => 1)
    product.price = -1
    assert product.invalid?
    assert product.errors[:price].any?
    
    product.price = 0
    assert product.invalid?
    assert product.errors[:price].any?

    product.price = 1
    assert product.valid?
  end
  
  test "image url" do
    def new_product(image_url)
      product = Product.new(:title => "test",
                          :description => "test",
                          :image_url => image_url, 
                          :price => 1)
    end
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG Fred.GIF http:/a.com/b/c.PNG }
    bad = %w{ fred.bat Fred.jpeg fred.gif/more test.gif.other }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldnt be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should be invalid"
    end

  end

  test "product is not valid without a unique title" do
    product = Product.new(:title => products(:ruby).title,
                          :description => "blah",
                          :image_url => "test.jpg",
                          :price => 1)
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join(': ')
  end
  
end
