require "s3ush/version"

module S3ush
  module Errors
    InvalidSmusher = Class.new(StandardError)
  end

  module Smushers
    class GenericSmusher
    end

    class YahooSmusher < GenericSmusher
      def initialize
        puts "Using Yahoo"
      end
    end

    class KrakenSmusher < GenericSmusher
      def initialize
        puts "Using Kraken"
      end
    end
  end

  class Smusher
    attr_accessor :smusher
    def initialize(use_smusher='yahoo')
      @smusher = use_smusher
      if (@smusher == 'yahoo')
        @smusher_class = Smushers::YahooSmusher
      elsif (@smusher == 'kraken')
        @smusher_class = Smushers::KrakenSmusher
      else
        raise Errors::InvalidSmusher
      end
    end

    def smush_file(file_path)
      # Make the file public, record it's current ALC
      # Pass it to the service
      # Upload the file to replace the current one
      # Set headers so we don't touch it again
    end

    def list_smushable_files(bucket)
      # Get a list of files in the bucket and filter out ones we can smush
      # Files can be smushed if
      #   They have not been smush yet
      #   They are an image
      #   They are under the filesize for the smushing service
    end
  end
end
