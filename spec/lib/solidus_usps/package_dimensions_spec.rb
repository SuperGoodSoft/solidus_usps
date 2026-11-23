require 'spec_helper'

RSpec.describe SolidusUsps::PackageDimensions do
  subject(:dimensions) { described_class.new(spree_package) }

  let(:spree_package) { double(contents: content_items) }
  let(:content_items) { [] }

  def content_item(quantity: 1, **variant_dimensions)
    double(quantity: quantity, variant: build_stubbed(:variant, **variant_dimensions))
  end

  context "when none of the variants have dimensions" do
    let(:content_items) { [content_item, content_item] }

    it "uses the minimum package dimensions" do
      expect([dimensions.length, dimensions.width, dimensions.height]).to eq [6.0, 4.0, 0.25]
    end
  end

  context "when the package is empty" do
    it "uses the minimum package dimensions" do
      expect([dimensions.length, dimensions.width, dimensions.height]).to eq [6.0, 4.0, 0.25]
    end
  end

  context "when the variants have dimensions" do
    let(:content_items) do
      [
        content_item(quantity: 2, height: 12.5, width: 12.5, depth: 0.5),
        content_item(quantity: 1, height: 0.4, width: 5.5, depth: 5)
      ]
    end

    it "uses the largest footprint, regardless of which column holds which dimension" do
      expect([dimensions.length, dimensions.width]).to eq [12.5, 12.5]
    end

    it "stacks the items' thicknesses" do
      expect(dimensions.height).to eq 1.4
    end
  end

  context "when an item is smaller than the minimum package dimensions" do
    let(:content_items) { [content_item(height: 3, width: 2, depth: 2)] }

    it "only raises the dimensions that are below the minimum" do
      expect([dimensions.length, dimensions.width, dimensions.height]).to eq [6.0, 4.0, 2.0]
    end
  end

  context "when the minimum package dimensions are configured" do
    around do |example|
      original = SolidusUsps.configuration.minimum_package_dimensions
      SolidusUsps.configuration.minimum_package_dimensions = [10, 8, 1]
      example.run
    ensure
      SolidusUsps.configuration.minimum_package_dimensions = original
    end

    it "uses the configured minimum" do
      expect([dimensions.length, dimensions.width, dimensions.height]).to eq [10.0, 8.0, 1.0]
    end
  end
end
