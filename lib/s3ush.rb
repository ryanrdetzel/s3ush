require "s3ush/version"
require "aws/s3"
require 'json'
require 'httpclient'

module S3ush
  class Smusher
    attr_accessor :smusher

    def initialize(aws_key, aws_secret, use_smusher='yahoo')
      set_smusher(use_smusher)
      setup_s3_connection(aws_key, aws_secret)
    end

    def smush_file(filename, bucket, force=false)
      # Pass it to the service
      # Upload the file to replace the current one
      # Set headers so we don't touch it again
      #

      verify_file(filename, bucket)
      smushed_file = run_through_smush_service(filename, bucket)
      upload_smushed_file(filename, bucket, smushed_file)
    end

    def list_smushable_files(bucket)
      # Get a list of files in the bucket and filter out ones we can smush
      # Files can be smushed if
      #   They have not been smush yet
      #   They are an image
      #   They are under the filesize for the smushing service
    end

    private

    def upload_smushed_file(filename, bucket, smushed_file)
      puts "Uploading"
      AWS::S3::S3Object.store(filename, smushed_file, bucket, :access => :public_read)
    end

    def run_through_smush_service(filename, bucket)
      url = "http://s3.amazonaws.com/#{bucket}/#{filename}"
      @smusher_class.smush_it(url)
    end

    def verify_file(filename, bucket)
      @file ||= AWS::S3::S3Object.find filename, bucket

      check_has_public_read(filename, bucket)
      check_valid_image(@file)
      check_file_size(@file)
      check_already_smushed(@file)
    end

    def check_already_smushed(file)
      if file.metadata.has_key?('x-s3ush')
        raise "Already Smushed"
      end
    end

    def check_valid_image(file)
      content_type = file.about['content-type']
      puts content_type
      #TODO: raise
    end

    def check_file_size(file)
      content_length = file.about['content-length']
      puts content_length
      #TODO: raise
    end

    def check_has_public_read(filename, bucket)
      policies = AWS::S3::S3Object.acl filename, bucket
      policies.grants.each do |grant|
        if grant.permission == "READ" &&
           grant.grantee.uri == "http://acs.amazonaws.com/groups/global/AllUsers"
          return
        end
      end
      #TODO: raise
    end

    def set_smusher(use_smusher)
      @smusher = use_smusher
      if (@smusher == 'yahoo')
        @smusher_class = Smushers::YahooSmusher
      elsif (@smusher == 'kraken')
        @smusher_class = Smushers::KrakenSmusher
      else
        raise Errors::InvalidSmusher
      end
    end

    def setup_s3_connection(aws_key, aws_secret)
      AWS::S3::Base.establish_connection!(
        access_key_id: aws_key,
        secret_access_key: aws_secret
      )
    end
  end

  module Errors
    InvalidSmusher = Class.new(StandardError)
  end

  module Smushers
    class GenericSmusher
    end

    class YahooSmusher < GenericSmusher
      YAHOO_URL = 'http://ypoweb-01.experf.gq1.yahoo.com/ysmush.it/ws.php'
      def self.smush_it(url)
        response = HTTPClient.post YAHOO_URL, 'img' => url
        response = JSON.parse(response.body)
        raise "smush.it: #{response['error']}" if response['error']
        image_url = response['dest']
        raise "no dest path found" unless image_url
        puts image_url
        open(image_url) { |source| source.read() }
      end
    end

    class KrakenSmusher < GenericSmusher
    end
  end

end
