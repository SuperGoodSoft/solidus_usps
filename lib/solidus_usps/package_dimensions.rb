# frozen_string_literal: true

module SolidusUsps
  # Estimates the outer dimensions of a package, in inches, from the
  # dimensions of the variants it contains.
  #
  # The items are assumed to be stacked flat: the parcel is as long and as
  # wide as its largest item, and as tall as all of the items' thicknesses
  # added together. Items with missing dimensions contribute nothing, and the
  # result is never smaller than the configured minimum package dimensions.
  #
  # Stores whose variants don't carry dimensions can supply their own class
  # via `SolidusUsps.configuration.package_dimensions_class`. Subclasses only
  # need to implement #item_dimensions.
  class PackageDimensions
    def initialize(spree_package)
      @spree_package = spree_package
    end

    def length
      [items.map { |item| item[:length] }.max.to_f, minimum[0]].max.round(2)
    end

    def width
      [items.map { |item| item[:width] }.max.to_f, minimum[1]].max.round(2)
    end

    def height
      [items.sum { |item| item[:height] * item[:quantity] }.to_f, minimum[2]].max.round(2)
    end

    private

    attr_reader :spree_package

    # @return [Array<Numeric>] the length, width, and thickness of a single
    #   unit of the given content item, in inches.
    def item_dimensions(content_item)
      variant = content_item.variant

      [variant.height, variant.width, variant.depth].map(&:to_f).sort.reverse
    end

    def items
      @items ||= spree_package.contents.map do |content_item|
        length, width, height = item_dimensions(content_item).map(&:to_f)

        { length: length, width: width, height: height, quantity: content_item.quantity }
      end
    end

    def minimum
      SolidusUsps.configuration.minimum_package_dimensions.map(&:to_f)
    end
  end
end
