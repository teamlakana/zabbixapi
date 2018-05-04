# encoding: utf-8

require 'spec_helper'

describe 'server' do
  describe 'version' do
    it 'should be string' do
      expect(zbx.server.version).to be_kind_of(String)
    end

    it 'should be 3.2.x or 3.4.x' do
      expect(zbx.server.version).to match(/(3\.[24])\.\d+/)
    end
  end
end
