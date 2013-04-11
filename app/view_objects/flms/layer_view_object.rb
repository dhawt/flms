module Flms

  # Create DOM for this layer, including all the necessary 'data-*' attributes to
  # animate it as desired  via skrollr.
  class LayerViewObject

    def initialize(layer)
      @layer = layer
    end

    def view_partial_name
      @layer.class.name.demodulize.underscore
    end

    # Generate a hash of data to be provided to skrollr that describes the keyframe animation for this layer
    def keyframe_data_hash
      data = { }
      data['data-anchor-target'] = '#pagescroller'

      initial_pos = @layer.start_state_keyframe.scroll_start
      target_start_pos = @layer.target_state_keyframe.scroll_start
      target_end_pos = @layer.end_state_keyframe.scroll_start
      final_pos = @layer.end_state_keyframe.scroll_start + @layer.end_state_keyframe.scroll_duration

      start_presenter = Flms::KeyframeViewObject.new(@layer.start_state_keyframe)
      target_presenter = Flms::KeyframeViewObject.new(@layer.target_state_keyframe)
      end_presenter = Flms::KeyframeViewObject.new(@layer.end_state_keyframe)

      data['data-0'] = 'display:none;'
      data["data-#{initial_pos}"] = 'display:block; ' + start_presenter.styles
      data["data-#{target_start_pos}"] = target_presenter.styles
      data["data-#{target_end_pos}"] = target_presenter.styles
      data["data-#{final_pos}"] = 'display:none; ' + end_presenter.styles

      data
    end
  end
end