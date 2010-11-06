require "#{File.dirname(__FILE__)}/../spec_helper"

describe SKApi::Resources::Client, "in general" do

  before :all do
    #setup test client to work with
    @client = SKApi::Resources::Client.new(:organisation=>'from testing API2')
    @client.save
  end

  after :all do
    #delete test client
    @client.destroy
    lambda {
      client = SKApi::Resources::Client.find(@client.id)
    }.should raise_error(ActiveResource::ResourceNotFound)
  end

  it "should create a client" do
    @client.number.should_not be_nil
    @client.new?.should be_false
  end

  it "should fail create a client" do
    client = SKApi::Resources::Client.new(:organisation=>'from testing API2')
    client.bank_iban = 'safasf'
    client.save.should == false
    client.errors.count.should == 1
    client.errors.full_messages.should ==  ["Bank iban is invalid"]
  end

  it "should find a single client" do
    client = SKApi::Resources::Client.find(@client.id)
    client.organisation.should == @client.organisation
  end

  it "should find clients" do
    clients = SKApi::Resources::Client.find(:all)
    clients.should_not be_empty
  end

  it "should edit a client" do
    @client.first_name = 'Theodore'
    @client.gender = 'male'
    @client.lock_version.should == 0
    @client.save
    @client.lock_version.should == 1 # because save returns the data
  end

  it "should fail edit a client" do
    @client.last_name = ''
    @client.organisation = ''
    @client.save.should == false
    @client.errors.count.should == 1
    @client.errors.on_base.should == "Organisation or lastname must be present."
  end

  it "should validate raw json object with schema" do
    client = SKApi::Resources::Client.find(@client.id)
    # convert to json and read raw without activeresource assigning classes
    json = client.to_json
    obj = ActiveSupport::JSON.decode(json)
#     puts obj['client']['organisation']
    lambda {
      JSON::Schema.validate(obj['client'],  SKApi::Resources::Client.schema)
    }.should_not raise_error
  end

  it "should validate raw json object with to_hash_with_schema" do
    client = SKApi::Resources::Client.find(@client.id)
    # convert to json and read raw without activeresource assigning classes
    hash_obj =  SKApi::Resources::Client.to_hash_from_schema(client)
#    hash_obj.should == ''
    lambda {
      JSON::Schema.validate(hash_obj['client'],  SKApi::Resources::Client.schema)
    }.should_not raise_error
  end

end

describe SKApi::Resources::Client, "with addresses" do

  before :all do
    #setup test client to work with
    @client = SKApi::Resources::Client.new(:organisation=>'Second from testing API2',
                                            :addresses => [{ :zip => '50374', :city => 'Cologne' }] )
    @client.save
  end

  after :all do
    @client.destroy
    lambda {
      client = SKApi::Resources::Client.find(@client.id)
    }.should raise_error(ActiveResource::ResourceNotFound)
  end

  it "should create an address" do
    @client.addresses.length.should == 1
    @client.addresses.first.zip.should == '50374'
  end

  it "should edit an address" do
    @client.addresses[0].zip = '40001'
    @client.save
    @client.addresses.length.should == 1
    @client.addresses.first.zip.should == '40001'
  end

  it "should add an address" do
    adr = SKApi::Resources::Address.new( { :zip => '50374', :city => 'Cologne' } )
    @client.addresses << adr
    @client.save
    @client.addresses.length.should == 2
#    @client.addresses[0].zip = '40001'
#    @client.addresses.[1].zip.should == '40001'
  end
end