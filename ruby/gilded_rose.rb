class GildedRose

  def initialize(items)
    @items = items
  end

  def self.special_item?(item)
    special_items = ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert"]
    special_items.include? item.name
  end

  def self.update_special_item(item)
    GildedRose.update_backstage(item) if item.name == "Backstage passes to a TAFKAL80ETC concert"
    GildedRose.update_brie(item) if item.name == "Aged Brie"
  end

  def self.validate_quality(item)
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality.negative?
  end

  def self.update_normal_item(item)
    item.sell_in -= 1
    item.quality = if item.sell_in.negative?
                     item.quality - 2
                   else
                     item.quality - 1
                   end
  end

  def self.update_brie(item)
    item.quality += 1
    item.sell_in -= 1
    item.quality += 1 if item.sell_in.negative?
  end

  def self.update_backstage(item)
    item.quality += 1
    item.quality += 1 if item.sell_in < 11
    item.quality += 1 if item.sell_in < 6
    item.sell_in -= 1
    item.quality = 0 if item.sell_in < 0
  end

  def update_quality()
    @items.each do |item|
      break if item.name == "Sulfuras, Hand of Ragnaros"

      if GildedRose.special_item?(item)
        # special items
        GildedRose.update_special_item(item)
      else
        # normal items
        GildedRose.update_normal_item(item)
      end
      # ensure quality between 0 and 50
      GildedRose.validate_quality(item)
    end
    self
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
