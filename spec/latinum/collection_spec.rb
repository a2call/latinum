# Copyright, 2015, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'latinum'
require 'latinum/currencies/global'

require 'set'

module Latinum::CollectionSpec
	describe Latinum::Collection do
		it "can set an initial value" do
			subject["NZD"] = BigDecimal.new("20")
			
			expect(subject["NZD"]).to be == Latinum::Resource.load("20 NZD")
		end
		
		it "should sum up currencies correctly" do
			resource = Latinum::Resource.new("10", "NZD")
			
			subject << resource
			expect(subject["NZD"]).to be == resource
			
			subject << resource
			expect(subject["NZD"]).to be == (resource * 2)
		end
		
		it "should sum up multiple currencies correctly" do
			resources = [
				Latinum::Resource.new("10", "NZD"),
				Latinum::Resource.new("10", "AUD"),
				Latinum::Resource.new("10", "USD"),
				Latinum::Resource.new("10", "NZD"),
				Latinum::Resource.new("10", "AUD"),
				Latinum::Resource.new("10", "USD"),
			]
			
			subject = Latinum::Collection.new
			subject << resources
			
			expect(subject["NZD"]).to be == (resources[0] * 2)
			expect(subject.names).to be == Set.new(["NZD", "AUD", "USD"])
		end
		
		it "can add two collections together" do
			other_resources = [
				Latinum::Resource.new("10", "NZD"),
				Latinum::Resource.new("10", "AUD"),
				Latinum::Resource.new("10", "USD"),
			]
			
			other_collection = Latinum::Collection.new
			other_collection << other_resources
			
			resources = [
				Latinum::Resource.new("10", "NZD"),
				Latinum::Resource.new("10", "AUD"),
				Latinum::Resource.new("10", "USD"),
			]
			
			subject << resources
			subject << other_collection
			
			expect(subject["NZD"]).to be == Latinum::Resource.load("20 NZD")
			expect(subject["AUD"]).to be == Latinum::Resource.load("20 AUD")
			expect(subject["USD"]).to be == Latinum::Resource.load("20 USD")
		end
	end
end
