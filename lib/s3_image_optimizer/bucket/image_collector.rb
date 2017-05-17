require_relative 'performer'
module S3ImageOptimizer::Bucket
  class ImageCollector < Performer
    attr_accessor :images

    def initialize(bucket, options)
      super
      @images = []
      collect_images(@options[:dir])
    end

    def collect_images(prefix)
      @images = @bucket.objects(:prefix => prefix).map(&:key)
      if @options[:only_filenames]
        @images = @images.select { |i|
          @options[:only_filenames].any? { |str|
            str.include?(File.basename(i))
          }
        }
      end
      if @options[:key_contains]
        @images = @images.select { |i|
          @options[:key_contains].any? { |str|
            i.include?(str)
          }
        }
      end
      @images
    end
  end
end