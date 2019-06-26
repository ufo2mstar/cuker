module Cuker
  class SummaryXLModel < RubyXLModel
    def make_order
# todo: template{:col_key => ["Title text",fill_color,font, etc]},
# todo: tag based reordering
      [
          {:counter => "Sl.No"},
          {:s_type => "Type"},
          {:s_title => "Title"},
          {:tags => special_tag_titles},
          {:other_tags => "Other Tags"},
          {:feature_title => "Feature"},
          {:bg_title => "Background"},
          {:file_s_num => "Scen.no"},
          {:file_name => "File"},
      ]
    end

    def make_title order
      get_values_ary order
    end

    def special_tag_titles
      @special_tag_titles ||= get_values_ary @special_tag_list if @special_tag_list
    end

    def special_tag_lookup
      @special_tag_lookup ||= get_keys_ary @special_tag_list if @special_tag_list
    end

    def filter_special_tags(all_tags)
      return [[], all_tags] unless special_tag_lookup
      ignore_list = all_tags - special_tag_lookup
      select_list = all_tags - ignore_list
      [select_list, ignore_list]
    end

    def other_tags
      # code here
    end

    def make_rows
      if @asts.nil? or @asts.empty?
        @log.debug "No asts to parse!"
        return []
      end

      feat_counter = 1
      feature_title = []
      bg_title = []

      res = []
      @asts.each do |file_path, ast|
        @log.debug "Understanding file: #{file_path}"
        @file_path = file_path
        in_feat_counter = 0

        if ast[:type] == :GherkinDocument
          in_feature(ast) do |feat_tags_ary, feat_title, feat_item|
            in_item(feat_item) do |tags_ary, type, item_title, content_ary, example_ary|
              row_hsh = {}
              feature_title = excel_title FEATURE, feat_title
              if type == :Background or type == :Feature
                bg_title = [excel_title(BACKGROUND, item_title)] + content_ary
              else
                # if type == :Scenario or type == :ScenarioOutline
                scen_title = [excel_title(type.to_s, item_title)] + content_ary

                row_hsh[:counter] = "#{feat_counter}"
                row_hsh[:s_type] = type == :Scenario ? "S" : "SO"
                row_hsh[:s_title] = excel_content_format scen_title

                row_hsh[:tags] = special_tag_lookup
                row_hsh[:other_tags] = other_tags
                row_hsh[:feature_title] = excel_content_format feature_title
                row_hsh[:bg_title] = excel_content_format bg_title
                row_hsh[:file_s_num] = "#{in_feat_counter += 1}"
                row_hsh[:file_name] = file_path

                # row_hsh[:examples] = "" # is nil by default
                if type == :ScenarioOutline
                  row_hsh[:examples] = example_count example_ary
                end
                row_ary = []
                get_keys_ary(@order).each do |k, v|
                  if v.class == Array
                    # v.each { |tag| row_ary << (tag.nil?? EXCEL_BLANK : tag) }
                    v.each {|tag| row_ary << (tag || EXCEL_BLANK)}
                  else
                    row_ary << (row_hsh[k])
                  end
                end
                res << row_ary
              end
              # get_keys_ary(@order).each {|k| row_ary << excel_arg_hilight(row_hsh[k])}
            end
            feat_counter += 1
            feature_title = []
            bg_title = []
          end
        end
      end
      @file_path = nil
      res
    end

  end

end
