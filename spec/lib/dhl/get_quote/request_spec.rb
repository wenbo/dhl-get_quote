require 'spec_helper'
require 'dhl-get_quote'

describe Dhl::GetQuote::Request do

  let(:valid_params) do
    {
      :site_id  => 'SomeId',
      :password => 'p4ssw0rd'
    }
  end

  let(:klass) { Dhl::GetQuote::Request }

  subject do
    klass.new(valid_params)
  end

  describe ".new" do
    it "must return an instance of Dhl::GetQuote" do
      klass.new(valid_params).must be_an_instance_of(Dhl::GetQuote::Request)
    end

    it "must throw an error if a site id is not passed" do
      lambda do
        klass.new(valid_params.merge(:site_id => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end

    it "must throw an error if a password is not passed" do
      lambda do
        klass.new(valid_params.merge(:password => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end
  end

  describe '#from' do
    it 'requires a country code as and postal code as parameters' do
      subject.from('US', '84111')

      subject.from_country_code.must == 'US'
      subject.from_postal_code.must == '84111'
    end

    it 'converts postal codes to strings' do
      subject.from('US', 84111)

      subject.from_postal_code.must == '84111'
    end

    it 'must raise error if country code is not 2 letters long' do
      lambda do
        subject.from('DDF', '84111')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)

      lambda do
        subject.from('D', '84111')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end

    it 'must raise error if country code is not upper case' do
      lambda do
        subject.from('us', '84111')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end
  end

  describe '#to' do
    it 'requires a country code as and postal code as parameters' do
      subject.to('CA', 'T1H 0A1')

      subject.to_country_code.must == 'CA'
      subject.to_postal_code.must == 'T1H 0A1'
    end

    it 'converts postal codes to strings' do
      subject.to('CA', 1111)

      subject.to_postal_code.must == '1111'
    end

    it 'must raise error if country code is not 2 letters long' do
      lambda do
        subject.from('DDF', 'T1H 0A1')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)

      lambda do
        subject.from('D', 'T1H 0A1')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end

    it 'must raise error if country code is not upper case' do
      lambda do
        subject.from('ca', 'T1H 0A1')
      end.must raise_exception(Dhl::GetQuote::CountryCodeError)
    end
  end

  describe "#dutiable?" do
    it "must be true if dutiable set to yes" do
      subject.instance_variable_set(:@is_dutiable, true)
      subject.dutiable?.must be_true
    end

    it "must be false if dutiable set to no" do
      subject.instance_variable_set(:@is_dutiable, false)
      subject.dutiable?.must be_false
    end

    it "must default to false" do
      subject.dutiable?.must be_false
    end
  end

  describe "#dutiable" do
    it "must set dutiable to true if passed a true value" do
      subject.dutiable(true)
      subject.dutiable?.must be_true
    end

    it "must set dutiable to false if passed a false value" do
      subject.dutiable(false)
      subject.dutiable?.must be_false
    end
  end

  describe "#dutiable!" do
    it "must set dutiable() to true" do
      subject.dutiable?.must be_false #sanity

      subject.dutiable!
      subject.dutiable?.must be_true
    end
  end

  describe "#not_dutiable!" do
    it "must set dutiable() to false" do
      subject.instance_variable_set(:@is_dutiable, true)
      subject.dutiable?.must be_true #sanity

      subject.not_dutiable!
      subject.dutiable?.must be_false
    end
  end

  describe "#weight_unit" do
    it "must return the set weight unit" do
      subject.instance_variable_set(:@weight_unit, "LB")
      subject.weight_unit.must == "LB"
    end

    it "must default to KG if not otherwise set" do
      subject.instance_variable_set(:@weight_unit, nil)
      subject.weight_unit.must == "KG"
    end
  end

  describe "#dimensions_unit" do
    it "must return the set weight unit" do
      subject.instance_variable_set(:@dimensions_unit, "IN")
      subject.dimensions_unit.must == "IN"
    end

    it "must default to CM if not otherwise set" do
      subject.instance_variable_set(:@dimensions_unit, nil)
      subject.dimensions_unit.must == "CM"
    end
  end

  describe "#centimeters!" do
    it "must set the dimensions_unit to centimeters" do
      subject.instance_variable_set(:@dimensions_unit, nil)

      subject.centimeters!
      subject.dimensions_unit.must == "CM"
    end
  end

  describe "#inches!" do
    it "must set the dimensions_unit to inches" do
      subject.instance_variable_set(:@dimensions_unit, nil)

      subject.inches!
      subject.dimensions_unit.must == "IN"
    end
  end

  describe "#inches?" do
    it "must be true if dimensions unit is set to inches" do
      subject.instance_variable_set(:@dimensions_unit, "IN")
      subject.inches?.must be_true
    end

    it "must be false if dimensions unit is not set to inches" do
      subject.instance_variable_set(:@dimensions_unit, "CM")
      subject.inches?.must be_false
    end
  end

  describe "#centimeters?" do
    it "must be true if dimensions unit is set to centimeters" do
      subject.instance_variable_set(:@dimensions_unit, "CM")
      subject.centimeters?.must be_true
    end

    it "must be false if dimensions unit is not set to centimeters" do
      subject.instance_variable_set(:@dimensions_unit, "IN")
      subject.centimeters?.must be_false
    end
  end

  describe "#kilograms!" do
    it "must set the weight unit to kilograms" do
      subject.instance_variable_set(:@weight_unit, nil)

      subject.kilograms!
      subject.weight_unit.must == "KG"
    end
  end

  describe "#pounds!" do
    it "must set the weight unit to pounds" do
      subject.instance_variable_set(:@weight_unit, nil)

      subject.pounds!
      subject.weight_unit.must == "LB"
    end
  end

  describe "#kilograms?" do
    it "must be true if weight unit is set to kilograms" do
      subject.instance_variable_set(:@weight_unit, "KG")
      subject.kilograms?.must be_true
    end

    it "must be false if dimensions unit is not set to inches" do
      subject.instance_variable_set(:@weight_unit, "LB")
      subject.kilograms?.must be_false
    end
  end

  describe "#pounds?" do
    it "must be true if weight unit is set to pounds" do
      subject.instance_variable_set(:@weight_unit, "LB")
      subject.pounds?.must be_true
    end

    it "must be false if weight unit is not set to pounds" do
      subject.instance_variable_set(:@weight_unit, "KG")
      subject.pounds?.must be_false
    end
  end

  describe "#to_xml" do
    before(:each) do
      subject.from('US', 84010)
      subject.to('CA', 'T1H 0A1')
    end

    let(:time) { Time.now }

    let(:mock_piece) do
      mock(:piece,
        :to_xml => [
          "<Piece>",
          "#{" "*20}<Height>20</Height>",
          "#{" "*20}<Depth>20</Depth>",
          "#{" "*20}<Width>20</Width>",
          "#{" "*20}<Weight>19</Weight>",
          "#{" "*16}</Piece>"
        ].join("\n"),
        :validate! => nil,
        :piece_id= => nil
      )
    end

    # gsub here removes leading whitespace which may be variable.
    let(:xml_output) { subject.to_xml.gsub(/^\s+/, '') }

    it "must return an XML version of the object including Pieces" do

      subject.pieces << mock_piece
      subject.stub(:validate!)

      correct_response = <<eos
<?xml version="1.0" encoding="UTF-8"?>
<p:DCTRequest xmlns:p="http://www.dhl.com" xmlns:p1="http://www.dhl.com/datatypes" xmlns:p2="http://www.dhl.com/DCTRequestdatatypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com DCT-req.xsd ">
<GetQuote>
<Request>
<ServiceHeader>
<SiteID>SomeId</SiteID>
<Password>p4ssw0rd</Password>
</ServiceHeader>
</Request>
<From>
<CountryCode>US</CountryCode>
<Postalcode>84010</Postalcode>
</From>
<BkgDetails>
<PaymentCountryCode>US</PaymentCountryCode>
<Date>#{time.strftime("%Y-%m-%d")}</Date>
<ReadyTime>#{subject.ready_time(time)}</ReadyTime>
<ReadyTimeGMTOffset>+00:00</ReadyTimeGMTOffset>
<DimensionUnit>#{subject.dimensions_unit}</DimensionUnit>
<WeightUnit>#{subject.weight_unit}</WeightUnit>
<Pieces>
<Piece>
<Height>20</Height>
<Depth>20</Depth>
<Width>20</Width>
<Weight>19</Weight>
</Piece>
</Pieces>
<IsDutiable>N</IsDutiable>
</BkgDetails>
<To>
<CountryCode>CA</CountryCode>
<Postalcode>T1H 0A1</Postalcode>
</To>
</GetQuote>
</p:DCTRequest>
eos
      xml_output.must == correct_response
    end

    context "one special service is specified" do

      before(:each) { subject.add_special_service("D") }

      it "must add SpecialServiceType tags to XML" do
        sst_xml = "<QtdShp>
      <QtdShpExChrg>
          <SpecialServiceType>D</SpecialServiceType>
      </QtdShpExChrg>
  </QtdShp>"
        xml_output.must =~ /#{(sst_xml.gsub(/^\s+/, ''))}/
      end
    end

    context "many special services are specified" do

      before(:each) do
        subject.add_special_service("D")
        subject.add_special_service("SA")
      end

      it "must add SpecialServiceType tags to XML" do
        sst_xml = <<eos
<QtdShp>
<QtdShpExChrg>
<SpecialServiceType>D</SpecialServiceType>
</QtdShpExChrg>
<QtdShpExChrg>
<SpecialServiceType>SA</SpecialServiceType>
</QtdShpExChrg>
</QtdShp>
eos
        xml_output.must =~ /#{(sst_xml.gsub(/^\s+/, ''))}/
      end
    end
  end

  describe "#post" do
    let(:mock_httparty_response) do
      mock(:httparty_response, :body => nil)
    end
    let(:mock_response_object) { mock(:response_object) }
    before(:each) do
      subject.stub(:to_xml).and_return('<xml></xml>')
      subject.stub!(:validate!)
      HTTParty.stub!(:post).and_return(
        mock(:httparty, :response => mock_httparty_response)
      )
      Dhl::GetQuote::Response.stub!(:new).and_return(mock_response_object)
    end

    it "must validate the object" do
      subject.must_receive(:validate!)

      subject.post
    end

    it "must post to server" do
      HTTParty.must_receive(:post).with(
        Dhl::GetQuote::Request::URLS[:production],
        {
          :body => '<xml></xml>',
          :headers => { 'Content-Type' => 'application/xml' }
        }
      )

      subject.post
    end

    it "must return a new Response object" do
      subject.post.must == mock_response_object
    end

  end

  describe "#add_special_service" do
    before(:each) { subject.special_services.must == [] }
    it "should accept a single string of the special service type code and add it to the list" do
      subject.add_special_service("D")
      subject.special_services.must == ["D"] #sanity
    end

    it "should not add the same service twice" do
      subject.add_special_service("SA")
      subject.add_special_service("SA")
      subject.special_services.must == ["SA"]
    end

    it "should not add anything if service type code passed is blank" do
      subject.add_special_service("")
      subject.special_services.must == []
    end
  end

  describe "#remove_special_service" do
    before(:each) do
      subject.instance_variable_set(:@special_services_list, Set.new(["D"]))
    end

    it "should accept a single string of the special service type code and remove it from the list" do
      subject.remove_special_service("D")
      subject.special_services.must == [] #sanity
    end

    it "should throw an error if service to be removed does not exist in list" do
      subject.remove_special_service("SA")
      subject.special_services.must == ["D"]
    end

    it "should not add anything if service type code passed is blank" do
      subject.remove_special_service("")
      subject.special_services.must == ["D"]
    end
  end

  describe "#special_services" do
    before(:each) do
      subject.instance_variable_set(:@special_services_list, Set.new(["D"]))
    end

    it "must return an array of the special service codes" do
      subject.special_services.must == ["D"]
    end
  end

  describe "#test_mode?" do
    it "must be false if not in test mode" do
      subject.instance_variable_set(:@test_mode, false)

      subject.test_mode?.must be_false
    end

    it "must be false if not in test mode" do
      subject.instance_variable_set(:@test_mode, true)

      subject.test_mode?.must be_true
    end
  end

  describe "#test_mode!" do
    it "must set test_mode to true" do
      subject.instance_variable_set(:@test_mode, false)

      subject.test_mode!
      subject.instance_variable_get(:@test_mode).must be_true
    end
  end

  describe "#production_mode!" do
    it "must set test_mode to false" do
      subject.instance_variable_set(:@test_mode, true)

      subject.production_mode!
      subject.instance_variable_get(:@test_mode).must be_false
    end
  end
end
