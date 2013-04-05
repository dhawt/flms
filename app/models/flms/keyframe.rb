module Flms
  class Keyframe < ActiveRecord::Base
    attr_accessible :layer,
                    :scroll_start, :scroll_duration,
                    :width, :height,
                    :position_x, :position_y,
                    :opacity, :scale, :blur,
                    :opacity_percent, :scale_percent, :blur_percent, :position_name

    belongs_to :layer

    validates_numericality_of :scroll_start, greater_than_or_equal_to: 0, allow_nil: true
    validates_numericality_of :scroll_duration, greater_than_or_equal_to: 0, allow_nil: true
    validates_numericality_of :width, greater_than_or_equal_to: 0, allow_nil: true
    validates_numericality_of :height, greater_than_or_equal_to: 0, allow_nil: true
    validates_numericality_of :opacity, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, allow_nil: true
    validates_numericality_of :scale, greater_than_or_equal_to: 0, allow_nil: true

    # Flms provides some 'friendly' position values to hide the details of setting x,y values for CSS positioning of layers.
    # Below we store a list of valid position names, and corresponding x,y coordinates for each
    POSITION_NAMES = %w[center top-left top top-right right bottom-right bottom bottom-left left]
    POSITION_COORDINATES = [[0.5, 0.5], [0.0, 0.0], [0.5, 0.0], [1.0, 0.0], [1.0, 0.5], [1.0, 1.0], [0.5, 1.0], [0.0, 1.0], [0.0, 0.5]]

    def position_name_valid? position_name
      POSITION_NAMES.include?(position_name)
    end

    def position_coordinates_valid? position_coordinates
      POSITION_COORDINATES.include? position_coordinates
    end

    def position_name_to_coordinates position_name
      raise 'position name invalid' unless position_name_valid?(position_name)
      POSITION_COORDINATES[POSITION_NAMES.index(position_name)]
    end

    def position_coordinates_to_name position_coordinates
      raise 'position coordinates invalid' unless position_coordinates_valid?(position_coordinates)
      POSITION_NAMES[POSITION_COORDINATES.index(position_coordinates)]
    end

    def opacity_percent
      (self.opacity * 100).to_i
    end

    def opacity_percent= val
      self.opacity = val.to_i / 100.0
    end

    def scale_percent
      (self.scale * 100).to_i
    end

    def scale_percent= val
      self.scale = val.to_i / 100.0
    end

    def blur_percent
      (self.blur * 100).to_i
    end

    def blur_percent= val
      self.blur = val.to_i / 100.0
    end

    def position_name
      position_coordinates_to_name [self.position_x, self.position_y]
    end

    def position_name= val
      coordinates = position_name_to_coordinates val
      self.position_x = coordinates[0]
      self.position_y = coordinates[1]
    end

  end
end