module Cuker
  class SummaryXLModel < RubyXLModel
    def make_order
      [
# todo: template{:col_key => ["Title text",fill_color,font, etc]},
          {:counter => "Sl.No"},
          {:feature => "Feature"},
          {:background => "Background"},
          {:scenario => "Scenario"},
          {:examples => "Examples"},
          {:result => "Result"},
          {:tested_by => "Tested By"},
          {:test_designer => "Test Designer"},
          {:comments => "Comments"},
      ]
# todo: make title order reorderable
# todo: tag based reordering
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

    def make_rows
      if @asts.nil? or @asts.empty?
        @log.debug "No asts to parse!"
        return []
      end

      feat_counter = 1
      feat_content = []
      bg_content = []

      res = []
      @asts.each do |file_path, ast|
        @log.debug "Understanding file: #{file_path}"
        @file_path = file_path
        in_feat_counter = 0

        if ast[:type] == :GherkinDocument
          in_feature(ast) do |feat_tags_ary, feat_title, feat_item|
            in_item(feat_item) do |tags_ary, type, item_title, content_ary, example_ary|
              row_hsh = {}
              feat_content = excel_title FEATURE, feat_title
              if type == :Background or type == :Feature
                bg_content = [excel_title(BACKGROUND, item_title)] + content_ary
              else
                # if type == :Scenario or type == :ScenarioOutline
                scen_content = [excel_title(type.to_s, item_title)] + content_ary

                row_hsh[:counter] = "#{feat_counter}.#{in_feat_counter += 1}"
                row_hsh[:feature] = excel_content_format feat_content
                row_hsh[:background] = excel_content_format bg_content
                row_hsh[:scenario] = excel_content_format scen_content
                row_hsh[:result] = EXCEL_CONSTS::RESULT::PENDING
                row_hsh[:tested_by] = ""
                row_hsh[:test_designer] = ""
                row_hsh[:comments] = ""

                # row_hsh[:examples] = "" # is nil by default
                if type == :ScenarioOutline
                  row_hsh[:examples] = excel_content_format example_ary
                end
                row_ary = []
                get_keys_ary(@order).each {|k| row_ary << (row_hsh[k])}
                # get_keys_ary(@order).each {|k| row_ary << excel_arg_hilight(row_hsh[k])}
                res << row_ary
              end
            end
          end
        end
        feat_counter += 1
        feat_title = []
        bg_content = []
      end
      @file_path = nil
      res
    end

  end
end