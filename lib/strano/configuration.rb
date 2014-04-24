# -*- coding: utf-8 -*-
module Strano
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a
    # {Strano::API.
    VALID_OPTIONS_KEYS = [:clone_path].freeze

    # The file path to where local repos will be cloned to.
    DEFAULT_CLONE_PATH = Rails.root.join("vendor/repos")

    attr_accessor *VALID_OPTIONS_KEYS

    # Public: When this module is extended, set all configuration options to
    # their default values.
    def self.extended(base)
      base.reset
    end


    # Public: Convenience method to allow configuration options to be set in a
    # block.
    # 
    # Examples
    # 
    #   Strano.configure do |config|
    #     config.consumer_key = 'anotherkey'
    #   end
    def configure
      yield self
    end

    # Public: Create a hash of options and their values.
    # 
    # Returns the Hash of options.
    def options
      options = {}
      VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
      options
    end

    # Public: Reset all configuration options to defaults.
    # 
    # Returns self.
    def reset
      self.clone_path = DEFAULT_CLONE_PATH
      self
    end
  end
end
