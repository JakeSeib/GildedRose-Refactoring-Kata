class GildedRose

  def initialize(items)
    @items = items
  end

  def self.special_item?(item)
    special_items = ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert"]
    special_items.include? item.name
  end

  def update_quality()
    @items.each do |item|
      break if item.name == "Sulfuras, Hand of Ragnaros"

      if GildedRose.special_item?(item)
        # special items

        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          item.quality += 1
          item.quality += 1 if item.sell_in < 11
          item.quality += 1 if item.sell_in < 6
          item.sell_in -= 1
          item.quality = 0 if item.sell_in < 0
        else
          item.quality += 1
          item.sell_in -= 1
          item.quality += 1 if item.sell_in < 0
        end
        item.quality = 50 if item.quality > 50

      else
        # normal items
        item.quality -= 1
        item.sell_in -= 1
        item.quality -= 1 if item.sell_in < 0
        item.quality = 0 if item.quality < 0
      end
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
