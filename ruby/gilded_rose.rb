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
    item.quality = [50, item.quality].min
    item.quality = [0, item.quality].max
  end

  def self.update_normal_item(item)
    item.sell_in -= 1
    item.quality = item.sell_in.negative? ? item.quality - 2 : item.quality - 1
  end

  def self.update_brie(item)
    item.sell_in -= 1
    item.quality = item.sell_in.negative? ? item.quality + 2 : item.quality + 1
  end

  def self.update_backstage(item)
    item.sell_in -= 1
    # each element of breakpoints is an array whose first element is a
    # breakpoint for sell_in, and whose second element is the update value for
    # quality associated with that breakpoint. Elements should be in asending
    # order by breakpoint.
    breakpoints = [[0, -item.quality], [5, 3], [10, 2]]
    breakpoint = breakpoints.find {|i| item.sell_in < i[0]}
    item.quality = breakpoint ? item.quality + breakpoint[1] : item.quality + 1
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
