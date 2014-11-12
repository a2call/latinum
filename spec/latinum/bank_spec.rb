# encoding: UTF-8
#
# Copyright, 2012, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

module Latinum::BankSpec
	describe Latinum::Bank do
		before(:all) do
			@bank = Latinum::Bank.new
			@bank.import(Latinum::Currencies::Global)
			
			@bank << Latinum::ExchangeRate.new("NZD", "AUD", "0.5")
		end
		
		it "should format the amounts correctly" do
			resource = Latinum::Resource.new("10", "NZD")
			
			expect(@bank.format(resource, :format => :full)).to be == "$10.00 NZD"
			expect(@bank.format(resource, :format => :compact)).to be == "$10.00"
			
			resource = Latinum::Resource.new("391", "AUD")
			expect(@bank.format(resource)).to be == "$391.00 AUD"
			
			resource = Latinum::Resource.new("-100", "NZD")
			expect(@bank.format(resource)).to be == "-$100.00 NZD"
			
			resource = Latinum::Resource.new("1.12345678", "BTC")
			expect(@bank.format(resource)).to be == "B⃦1.12345678 BTC"
		end
		
		it "should exchange currencies from NZD to AUD" do
			nzd = Latinum::Resource.new("10", "NZD")
			
			aud = @bank.exchange nzd, "AUD"
			expect(aud).to be == Latinum::Resource.new("5", "AUD")
		end
		
		it "should parser strings into resources" do
			expect(@bank.parse("$5")).to be == Latinum::Resource.new("5", "USD")
			expect(@bank.parse("$5 NZD")).to be == Latinum::Resource.new("5", "NZD")
			expect(@bank.parse("€5")).to be == Latinum::Resource.new("5", "EUR")
			
			expect(@bank.parse("5 NZD")).to be == Latinum::Resource.new("5", "NZD")
		end
	end
end
