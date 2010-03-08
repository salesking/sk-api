require "#{File.dirname(__FILE__)}/../spec_helper"

describe SKApi::Resources::Invoice, "in general" do

  before :all do
    @client = SKApi::Resources::Client.new(:organisation=>'Invoice API-Tester')
    @client.save.should be_true
    @doc = SKApi::Resources::Invoice.new()
    @doc.title = 'A Document from the API'
    @doc.client_id = @client.id
    @doc.save.should be_true
  end

  after :all do
    delete_test_data(@doc, @client)
  end

  it "should find a doc" do
    doc = SKApi::Resources::Invoice.find(@doc.id)
    doc.title.should == @doc.title
  end
end

describe SKApi::Resources::Invoice, "a new invoice" do

  before :all do
    @client = SKApi::Resources::Client.new(:organisation=>'Invoice API-Tester')
    @client.save.should be_true
  end
  after :all do
    @client.destroy
  end

  it "should create a doc" do
    doc = SKApi::Resources::Invoice.new()
    doc.title = 'A Document from the API'
    doc.client_id = @client.id
    doc.save
    doc.errors.should be_empty
    doc.new?.should be_false
    doc.destroy
  end

  it "should fail create a doc" do
    doc = SKApi::Resources::Invoice.new()
    doc.save.should == false
    doc.errors.count.should == 1
    doc.errors.on(:client_id).should == "can't be blank"
  end

end

describe SKApi::Resources::Invoice, "Edit an invoice" do

  before :all do
    #setup test doc to work with
    # create client
    @client = SKApi::Resources::Client.new(:organisation=>'Invoice API-Tester')
    @client.save.should be_true
    @doc = SKApi::Resources::Invoice.new()
    @doc.title = 'A Document from the API'
    @doc.client_id = @client.id
    @doc.save.should be_true
  end

  after :all do
    delete_test_data(@doc, @client)
  end

  it "should edit a doc" do
    old_lock_version = @doc.lock_version
    @doc.notes_before = 'You will recieve the amout of:'
    @doc.notes_before = 'Payment made to you bank Account'
    @doc.title = 'Changed doc title'

    @doc.save.should be_true
    @doc.lock_version.should > old_lock_version # because save returns the data
  end

  it "should fail edit without a client" do
    @doc.client_id = ''
    @doc.save.should == false
    @doc.errors.count.should == 1
    @doc.errors.on(:client_id).should == "can't be blank"
  end
end

describe SKApi::Resources::Invoice, "with line items" do

  before :all do
    @client = SKApi::Resources::Client.new(:organisation=>'Credit Note API-Tester')
    @client.save.should be_true
    #setup test doc to work with
    @doc = SKApi::Resources::Invoice.new(:client_id => @client.id,
                                          :line_items => [{ :position=>1, :description => 'Pork Chops', :quantity => 12, :price_single =>'10.00' }] )
    @doc.save.should be_true
  end

  after :all do
    delete_test_data(@doc, @client)
  end

  it "should create a line item" do
    @doc.line_items.length.should == 1
    @doc.line_items.first.description.should == 'Pork Chops'
    @doc.price_total.should == 120.0
  end

  it "should edit line item" do
    @doc.line_items[0].description = 'Egg Sandwich'
    @doc.save
    @doc.line_items.length.should == 1
    @doc.line_items.first.description.should == 'Egg Sandwich'
  end

  it "should add line item" do
    item = SKApi::Resources::LineItem.new( {  :position=>2, :description => 'Goat-Pie', :price_single => 10, :quantity=>10} )
    product = SKApi::Resources::Product.new(:name=>'Eis am Stiel', :price => 1.50, :tax=>19, :description => 'Mmmhh lecker Eis')
    product.save.should be_true
    item1 = SKApi::Resources::LineItem.new( { :position=>3, :use_product => 1, :product_id=> product.id, :quantity => 10 } )
    @doc.line_items << item
    @doc.line_items << item1
    @doc.save
    @doc.line_items.length.should == 3
    @doc.price_total.should == 235.0
  end

end
=begin
describe SKApi::Resources::Invoice, "with line items" do

  before :all do
    @client = SKApi::Resources::Client.new(:organisation=>'Credit Note API-Tester')
    @client.save.should be_true
    #setup test doc to work with
    @doc = SKApi::Resources::Invoice.new(:client_id => @client.id,
                                          :line_items => [{ :position=>1, :description => 'Pork Chops', :quantity => 12, :price_single =>'10.00' }] )
    @doc.save.should be_true
  end

  after :all do
    delete_test_data(@doc, @client)
  end

  it "should create a line item" do
    @doc.line_items.length.should == 1
    @doc.line_items.first.description.should == 'Pork Chops'
    @doc.price_total.should == 120.0
  end

  it "should edit line item" do
    @doc.line_items[0].description = 'Egg Sandwich'
    @doc.save
    @doc.line_items.length.should == 1
    @doc.line_items.first.description.should == 'Egg Sandwich'
  end

  it "should add line item" do
    item = SKApi::Resources::LineItem.new( {  :position=>2, :description => 'Goat-Pie', :price_single => 10, :quantity=>10} )
    product = SKApi::Resources::Product.new(:name=>'Eis am Stiel', :price => 1.50, :tax=>19, :description => 'Mmmhh lecker Eis')
    product.save.should be_true
    item1 = SKApi::Resources::LineItem.new( { :position=>3, :use_product => 1, :quantity => 10 } )
    @doc.line_items << item
    @doc.line_items << item1
    @doc.save
    @doc.line_items.length.should == 3
    @doc.price_total.should == 220.0
  end

  xit "should add line item and use product information" do

    @doc.line_items << item
    @doc.save
    @doc.line_items.length.should == 3
    @doc.price_total.should == 15.0

    product.destroy
  end
=end
