# Adapted from: 
# https://github.com/Neozaru/fluent-plugin-lookup/blob/master/lib/fluent/plugin/out_lookup.rb
require 'fluent/filter'
# coding: utf-8
require "csv" 
module Fluent
	class LookupCSVFilter < Filter
		include Fluent::HandleTagNameMixin
		
		Fluent::Plugin.register_filter('LookupCSV', self)
		config_param :table_file, :string, :default => nil
		config_param :input_field, :string, :default => nil
		config_param :output_field, :string, :default => nil
		config_param :strict, :bool, :default => false
	def handle_row(lookup_table, row)
      if (row.length < 2)
        return handle_row_error(row, "Too few columns : #{row.length} instead of 2")
      end
      # If too much columns
      if (strict && row.length > 2)
        return handle_row_error(row, "Too much columns : #{row.length} instead of 2")
      end
      # If duplicates
      if (strict && lookup_table.has_key?(row[0]))
        return handle_row_error(row, "Duplicate entry")
      end
      lookup_table[row[0]] = row[1]
#$log.warn "csv pair ", row[0], row[1]
    end
    def create_lookup_table(file)
      lookup_table = {}
      CSV.foreach(file) do |row|
        handle_row(lookup_table, row)
      end
      if (strict && lookup_table.length == 0)
        raise ConfigError, "Lookup file is empty"
      end
      return lookup_table
    rescue Errno::ENOENT => e
      handle_file_err(file, e)
    rescue Errno::EACCES => e
      handle_file_err(file, e)
    end
		def configure(conf)
			super
			if (input_field.nil? || output_field.nil? || table_file.nil?)
				raise ConfigError, "LookupCSV: 'input_field', 'output_field', and 'table_file' are required to be set."
			end
			@lookup_table = create_lookup_table(table_file)
			@field = input_field.split(".")
#			@output_field = output_field.split(".")
		end
		def start
			super
		end
		def shutdown
			super
		end
		def filter(tag, time, record)
#			key = record[@input_field] value = key 
#super(tag, time, record) value = lookupValue(record, @field) $log.warn 
#"value=", value/
			mykey = "#{record[@input_field]}"
#$log.warn "key=", mykey
			value = @lookup_table[mykey] || mykey
# || mykey
#			if (@lookup_table.has_key?(mykey)) $log.warn 
#"key found in csv"
#				value = @lookup_table[mykey] end 
#$log.warn "value=", value
			record[@output_field] = value
			record
		end
							
				
    end end
