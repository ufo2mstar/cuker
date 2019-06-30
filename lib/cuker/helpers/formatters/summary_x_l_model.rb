module Cuker
  class SummaryXLModel < RubyXLModel

    EXCEL_BLANK = nil

    def initialize ast_map, tags_list
      init_logger

      @log.trace "initing #{self.class}"
      @log.debug "has #{ast_map.size} items"

      @asts = ast_map

      @special_tag_list = tags_list
      # special_tag_titles

      @order = make_order
      @title = make_title @order
      @data = make_rows
    end

    def make_order
      [
          {:counter => "Sl.No"},
          {:s_type => "Type"},
          {:s_title => "Title"},
          {:tags => special_tag_titles},
          {:other_tags => "Other Tags"},
          {:feature_title => "Feature Title"},
          {:feature_count => "Feature"},
          {:bg_title => "Background"},
          {:file_s_num => "Scen.no"},
          {:file_name => "File"},
      ]
    end

    def make_title order
      get_values_ary order
    end

    def special_tag_titles
      @special_tag_titles ||= @special_tag_list if @special_tag_list
    end

    def special_tags
      @special_tags ||= @special_tag_list if @special_tag_list
    end

    def filter_special_tags(all_tags)
      return [[], all_tags] unless special_tags
      ignore_list = all_tags - special_tags
      select_list = all_tags - ignore_list
      ordered_list = []
      special_tag_titles.each {|tag| ordered_list << (select_list.include?(tag) ? tag : EXCEL_BLANK)}
      [ordered_list, ignore_list, select_list]
    end

    def make_rows
      if @asts.nil? or @asts.empty?
        @log.debug "No asts to parse!"
        return []
      end

      feat_counter = 0
      feature_title = []
      feature_tags_ary = []
      bg_title = []
      bg_tags_ary = []

      res = []
      @asts.each do |file_path, ast|
        @log.debug "Understanding file: #{file_path}"
        @file_path = file_path
        in_feat_counter = 0
        @no_feature_content = false

        if ast[:type] == :GherkinDocument
          # feat_counter += 1
          if ast[:feature]
            in_feature(ast) do |feat_tags_ary, feat_title, feat_item|
              @no_feature_content = true
              if feat_item
                in_item(feat_item) do |tags_ary, type, item_title, content_ary, example_ary|
                  feature_title = feat_title
                  feature_tags_ary = feat_tags_ary
                  if type == :Background or type == :Feature
                    # bg_title = [excel_title(BACKGROUND, item_title)] + content_ary
                    bg_title = item_title
                    bg_tags_ary = tags_ary
                    next
                  end
                    row_hsh = {}
                    # if type == :Scenario or type == :ScenarioOutline
                    # scen_title = [excel_title(type.to_s, item_title)] + content_ary
                    scen_title = item_title

                    row_hsh[:counter] = feat_counter += 1
                    row_hsh[:s_type] = type == :Scenario ? "S" : "SO"
                    row_hsh[:s_title] = excel_content_format scen_title

                    all_tags = [feat_tags_ary, bg_tags_ary, tags_ary].flatten.compact
                    ordered_list, ignore_list, select_list = filter_special_tags(all_tags)
                    row_hsh[:tags] = ordered_list
                    row_hsh[:other_tags] = ignore_list.join ", "
                    row_hsh[:feature_title] = excel_content_format feature_title
                    row_hsh[:bg_title] = excel_content_format bg_title
                    row_hsh[:file_s_num] = in_feat_counter += 1
                    row_hsh[:feature_count] = in_feat_counter == 1 ? 1 : 0
                    row_hsh[:file_name] = file_path

                    # row_hsh[:examples] = "" # is nil by default
                    if type == :ScenarioOutline
                      row_hsh[:examples] = example_count example_ary
                    end
                    row_ary = []
                    get_keys_ary(@order).each do |k|
                      if k == :tags
                        # v.each { |tag| row_ary << (tag.nil?? EXCEL_BLANK : tag) }
                        tags_ary = row_hsh[k]
                        tags_ary.each {|tag| row_ary << tag}
                      else
                        row_ary << (row_hsh[k])
                      end
                    end
                    res << row_ary
                    @no_feature_content = false
                  # end
                  # get_keys_ary(@order).each {|k| row_ary << excel_arg_hilight(row_hsh[k])}
                end
              end

            end

            if @no_feature_content
              @log.warn "No 'Scenario:' or 'Scenario Outline:' found in file @ #{@file_path}"

              row_hsh = {}
              feat_counter += 1

              row_hsh[:bg_title] = excel_content_format bg_title
              row_hsh[:feature_title] = excel_content_format feature_title
              row_hsh[:file_s_num] = in_feat_counter += 1
              row_hsh[:feature_count] = in_feat_counter == 1 ? 1 : 0
              all_tags = [feature_tags_ary, bg_tags_ary].flatten.compact
              ordered_list, ignore_list, select_list = filter_special_tags(all_tags)
              row_hsh[:tags] = ordered_list
              row_hsh[:other_tags] = ignore_list.join ", "

              write_empty_row res, row_hsh, feat_counter, file_path
            end

            feature_title = []
            feature_tags_ary = []
            bg_title = []
            bg_tags_ary = []

          else
            # todo: blank feature fill!
            @log.warn "No 'Feature:' found in file @ #{@file_path}"

            row_hsh = {}
            feat_counter += 1

            write_empty_row res, row_hsh, feat_counter, file_path
          end
        end
      end
      @file_path = nil
      res
    end

    def in_feature(hsh)
      if hsh[:feature]
        feat = hsh[:feature]

        feat_tags = get_tags feat
        feat_title = get_title_ary feat

        children = feat[:children]
        children.each {|child| yield feat_tags, feat_title, child}
        yield feat_tags, feat_title, nil if children.empty?
      else
        @log.warn "No Features found in file @ #{@file_path}"
      end
    end

    def example_count example_ary
      # [0] title
      # [1] table = [[0] title [...] examples]
      # [2] blank
      sum = []
      (1..example_ary.size).step(3).each {|i| sum << (example_ary[i].size - 1)}
      sum.inject('+')
    end

    def write_empty_row res, row_hsh, feat_counter, file_path
      row_hsh[:feature_count] ||= 0
      row_hsh[:file_s_num] ||= 0
      row_hsh[:counter] = feat_counter
      row_hsh[:s_type] = nil
      row_hsh[:file_name] = file_path
      row_hsh[:tags] = Array.new(@special_tag_list.size)

      row_ary = []
      get_keys_ary(@order).each do |k|
        if k == :tags
          tags_ary = row_hsh[k]
          tags_ary.each {|tag| row_ary << tag}
        else
          row_ary << (row_hsh[k])
        end
      end
      res << row_ary
      @no_feature_content = false
    end
  end

end
