require 'spec_helper'

describe SKApi::Resources::Product, "in general" do

  before :all do
    #setup test product to work with
    @product = SKApi::Resources::Product.new(:name=>'Eis am Stiel', :price => 1.50)
    @product.save.should be_true
  end

  after :all do
    #delete test product
    @product.destroy
    lambda {
      product = SKApi::Resources::Product.find(@product.id)
    }.should raise_error(ActiveResource::ResourceNotFound)
  end

  it "should create a product" do
    @product.number.should_not be_nil
    @product.price.should == 1.50
    @product.new?.should be_false
  end

  it "should fail create a product without name" do
    product = SKApi::Resources::Product.new(:price => 2.50)
    product.save.should == false
    product.errors.count.should == 1
    product.errors.full_messages.should ==  ["Name can't be blank"]
  end

  it "should fail create a product with empty price" do
    product = SKApi::Resources::Product.new(:name => 'No brain', :price =>' ')
    product.save.should be_false
    product.errors.full_messages.should ==  ["Price can't be blank", "Price is not a number"]
  end

  it "should find a product by id" do
    product = SKApi::Resources::Product.find(@product.id)
    product.name.should == @product.name
  end

  it "should edit a product" do
    @product.name = 'A new product name'
    @product.lock_version.should == 0
    @product.save
    @product.lock_version.should == 1 # because save returns the data
  end

  it "should fail edit a product" do
    @product.name = ''
    @product.save.should == false
    @product.errors.count.should == 1
    @product.errors.full_messages.should ==  ["Name can't be blank"]
  end

end