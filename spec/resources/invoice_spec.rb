require "#{File.dirname(__FILE__)}/../spec_helper"

describe SKApi::Resources::Invoice, "in general" do

  before :all do
    #setup test doc to work with
    # create client
    @client = SKApi::Resources::Client.new(:organisation=>'Invoice API-Tester')
    @client.save.should be_true
#    @doc = SKApi::Resources::Invoice.new()
        @doc = SKApi::Resources::Invoice.new(:client_id => @client.id,
                                          :line_items => [{ :position=>1, :description => 'Pork Chops', :quantity => 12, :price_single =>'10.00' }] )
    @doc.save.should be_true
#    @doc.title = 'A Document from the API'
#    @doc.client_id = @client.id
#    @doc.save
#    @doc.errors.full_messages.should == 'adfd'
    @doc.save.should be_true
  end

  after :all do
    #delete test doc
    @doc.destroy
    @client.destroy
    lambda {
      doc = SKApi::Resources::Invoice.find(@doc.id)
    }.should raise_error(ActiveResource::ResourceNotFound)
    lambda {
      client = SKApi::Resources::Client.find(@client.id)
    }.should raise_error(ActiveResource::ResourceNotFound)
  end

  it "should create a doc" do
    @doc.errors.should be_empty
    @doc.new?.should be_false
  end

  it "should fail create a doc" do
    doc = SKApi::Resources::Invoice.new()
    doc.save.should == false
    doc.errors.count.should == 1
    doc.errors.on(:client_id).should == "can't be blank"
  end

  it "should find a doc" do
    doc = SKApi::Resources::Invoice.find(@doc.id)
    doc.title.should == @doc.title
  end

  it "should validate raw json object with schema" do
    doc = SKApi::Resources::Invoice.find(@doc.id)
#    doc.number.should=='23'
    # convert to json and read raw without activeresource assigning classes
    json = doc.to_json    
    obj = Rufus::Json.decode(json)
    lambda {
      JSON::Schema.validate(obj,  SKApi::Resources::Invoice.schema)
    }.should_not raise_error
  end

  it "should edit a doc" do
#    @doc.lock_version.should == 0 # dont work cause doc is saved twice, for recalc of totals
    old_lock_version = @doc.lock_version
    @doc.notes_before = 'You will recieve the amout of:'
    @doc.notes_before = 'Payment made to you bank Account'
    @doc.title = 'Changed doc title'
    
    @doc.save.should be_true
    @doc.lock_version.should > old_lock_version # because save returns the data
  end

  it "should fail edit a doc" do
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
    @client.destroy #also destroys all docs
#    @doc.destroy
    lambda {
      doc = SKApi::Resources::Invoice.find(@doc.id)
    }.should raise_error(ActiveResource::ResourceNotFound)
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
    @doc.line_items << item
    @doc.save
    @doc.line_items.length.should == 2
    @doc.price_total.should == 220.0
#    @doc.line_items[0].zip = '40001'
#    @doc.line_items.[1].zip.should == '40001'
  end
end