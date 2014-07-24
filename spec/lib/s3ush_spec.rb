require 'spec_helper'
require 's3ush'

describe S3ush::Smusher do
  it "Should use the Yahoo Smusher by default" do
    smush = S3ush::Smusher.new
    expect(smush.smusher).to eq('yahoo')
  end

  it "Should use the Kraken Smusher when asked to" do
    smush = S3ush::Smusher.new('kraken')
    expect(smush.smusher).to eq('kraken')
  end

  it "Should raise an error on an invalid smusher" do
    expect {S3ush::Smusher.new('invalid')}.to raise_error(S3ush::Errors::InvalidSmusher)
  end
end
