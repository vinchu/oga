require 'spec_helper'

describe Oga do
  describe 'parsing XML' do
    it 'parses an XML document' do
      document = described_class.parse_xml('<root>foo</root>')

      document.is_a?(Oga::XML::Document).should == true
    end

    it 'raises an error when parsing an invalid document in strict mode' do
      block = proc { described_class.parse_xml('<root>foo', :strict => true) }

      block.should raise_error(LL::ParserError)
    end
  end

  describe 'parsing HTML' do
    it 'parses an HTML document' do
      document = described_class.parse_xml('<html><body></body></html>')

      document.is_a?(Oga::XML::Document).should == true
    end
  end

  describe 'SAX parsing' do
    before do
      klass = Class.new do
        attr_reader :name

        def on_element(namespace, name, attrs = {})
          @name = name
        end
      end

      @handler = klass.new
    end

    it 'parses an XML document using the SAX parser' do
      described_class.sax_parse_xml(@handler, '<foo />')

      @handler.name.should == 'foo'
    end

    it 'raises an error when parsing an invalid XML document in strict mode' do
      block = proc { Oga.sax_parse_xml(@handler, '<foo>', :strict => true) }

      block.should raise_error(LL::ParserError)
    end

    it 'parses an HTML document using the SAX parser' do
      described_class.sax_parse_html(@handler, '<link>')

      @handler.name.should == 'link'
    end
  end
end
