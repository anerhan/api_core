module ApiCore
  class Config
    attr_accessor :redis, :redis_secure, :redis_bus, :root_path, :namespace, :logger_prefix

    def paths
      @paths ||= YAML.load_file(File.join(root_path, 'config/paths.yml'))
    end

    def gem_root
      Gem::Specification.find_by_name('api_core').gem_dir
    end

    def common_log_file
      @common_log_file ||= File.new(File.join(root_path, 'log', "#{logger_prefix}.log"), 'a+').tap { |f| f.sync = true }
    end

    def i18n
      @i18n ||= YAML.load_file(File.join(gem_root, 'config/i18n.yml'))
    end

    def errors
      @errors ||= YAML.load_file(File.join(gem_root, 'config/errors.yml'))
    end

    def response_headers
      @response_headers ||= YAML.load_file(File.join(gem_root, 'config/response_headers.yml'))
    end
  end
end
