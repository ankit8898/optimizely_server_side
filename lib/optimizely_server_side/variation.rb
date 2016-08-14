module OptimizelyServerSide
  class Variation

    # Class holding meta data about variation.
    # content: The block / content of the variation
    # Primary: If this is the primary variation. Primary is
    # applicable in the cases of fallback / test is paused.

    attr_reader :primary, :key

    def initialize(primary: false, content: nil, key: nil)
      @primary = primary
      @key     = key
      @content = content
    end

    # Content is a block. Call is calling that block.
    def call
      @content.call
    end

  end
end
