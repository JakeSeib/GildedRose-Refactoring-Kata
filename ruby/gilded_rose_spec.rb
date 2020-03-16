require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  basic_item_list = nil

  before(:each) do
    # test basic behavior for up to 20 days
    basic_item_list = [
      Item.new("Boots of Speed", 30, 20),
      Item.new("Aged Brie", 30, 20),
      Item.new("Backstage passes to a TAFKAL80ETC concert", 30, 20),
      Item.new("Sulfuras, Hand of Ragnaros", 30, 20)
    ]
  end

  describe "#update_quality" do
    it "does not change the name" do
      items = basic_item_list.map(&:clone)
      GildedRose.new(items).update_quality()
      expect(items.map(&:name)).to eq(basic_item_list.map(&:name))
    end

    it "updates normal items" do
      items = [
        Item.new("Boots of Speed", 30, 20),
        Item.new("Dire Flail", 0, 20)
      ]
      initial_items = items.map(&:clone)
      days = 3
      gilded_rose = GildedRose.new(items).update_quality()
      expect(items.map(&:sell_in)).to eq(initial_items.map { |item| item.sell_in - 1} )
      expect(items[0].quality).to eq(initial_items[0].quality - 1)
      expect(items[1].quality).to eq(initial_items[1].quality - 2)
      (1..days).each do
        gilded_rose.update_quality()
      end
      # update_quality has been called days + 1 times
      expect(items.map(&:sell_in)).to eq(initial_items.map { |item| item.sell_in - (days + 1)} )
      expect(items[0].quality).to eq(initial_items[0].quality - (days + 1))
      expect(items[1].quality).to eq(initial_items[1].quality - (2*(days + 1)))
    end

    it "updates Aged Brie" do
      items = [
        Item.new("Aged Brie", 30, 20),
        Item.new("Aged Brie", 0, 20)
      ]
      initial_items = items.map(&:clone)
      days = 3
      gilded_rose = GildedRose.new(items).update_quality()
      expect(items.map(&:sell_in)).to eq(initial_items.map { |item| item.sell_in - 1} )
      expect(items[0].quality).to eq(initial_items[0].quality + 1)
      expect(items[1].quality).to eq(initial_items[1].quality + 2)
      (1..days).each do
        gilded_rose.update_quality()
      end
      # update_quality has been called days + 1 times
      expect(items.map(&:sell_in)).to eq(initial_items.map { |item| item.sell_in - (days + 1)} )
      expect(items[0].quality).to eq(initial_items[0].quality + (days + 1))
      expect(items[1].quality).to eq(initial_items[1].quality + (2*(days + 1)))
    end

    it "updates Sulfuras" do
      items = [
        Item.new("Sulfuras, Hand of Ragnaros", 30, 20),
        Item.new("Sulfuras, Hand of Ragnaros", 0, 20)
      ]
      initial_items = items.map(&:clone)
      days = 3
      gilded_rose = GildedRose.new(items).update_quality()
      expect(items.map(&:sell_in)).to eq(initial_items.map(&:sell_in))
      expect(items.map(&:quality)).to eq(initial_items.map(&:quality))
      (1..days).each do
        gilded_rose.update_quality()
      end
      expect(items.map(&:sell_in)).to eq(initial_items.map(&:sell_in))
      expect(items.map(&:quality)).to eq(initial_items.map(&:quality))
    end

    it "updates Backstage Passes" do
      items = [
        Item.new("Backstage passes to a TAFKAL80ETC concert", 30, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20)
      ]
      initial_items = items.map(&:clone)
      days = 3
      gilded_rose = GildedRose.new(items).update_quality()
      expect(items.map(&:sell_in)).to eq(initial_items.map { |item| item.sell_in - 1} )
      expect(items[0].quality).to eq(initial_items[0].quality + 1)
      expect(items[1].quality).to eq(0)
      (1..days).each do
        gilded_rose.update_quality()
      end
      # update_quality has been called days + 1 times
      expect(items.map(&:sell_in)).to eq(initial_items.map { |item| item.sell_in - (days + 1) })
      expect(items[0].quality).to eq(initial_items[0].quality + (days + 1))
      expect(items[1].quality).to eq(0)
    end

    it "updates correctly at breakpoints" do
      items = [
        Item.new("Boots of Speed", 2, 20),
        Item.new("Aged Brie", 2, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 2, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 7, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 12, 20)
      ]
      initial_items = items.map(&:clone)
      days = 4
      gilded_rose = GildedRose.new(items)
      (1..days).each do
        gilded_rose.update_quality()
      end
      expect(items.map(&:sell_in)).to eq(initial_items.map { |item| item.sell_in - days })
      expect(items[0].quality).to eq(initial_items[0].quality - 6)
      expect(items[1].quality).to eq(initial_items[1].quality + 6)
      expect(items[2].quality).to eq(0)
      expect(items[3].quality).to eq(initial_items[3].quality + 10)
      expect(items[4].quality).to eq(initial_items[4].quality + 6)
    end

    it "updates quality of different types of items simultaneously" do
      items = basic_item_list.map(&:clone)
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq(basic_item_list[0].quality - 1)
      expect(items[1].quality).to eq(basic_item_list[1].quality + 1)
      expect(items[2].quality).to eq(basic_item_list[2].quality + 1)
      expect(items[3].quality).to eq(basic_item_list[3].quality)
    end

    it "doesn't set quality over 50" do
      items = [
        Item.new("Aged Brie", 30, 49),
        Item.new("Aged Brie", -1, 49),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 2, 48),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 7, 49),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 12, 49)
      ]
      GildedRose.new(items).update_quality()
      items.each { |item|
        expect(item.quality).to eq(50)
      }
    end
    
    it "doesn't set negative quality" do
      items = [
        Item.new("Boots of Speed", 30, 0),
        Item.new("Dire Flail", -1, 1)
      ]
      GildedRose.new(items).update_quality()
      items.each { |item|
        expect(item.quality).to eq(0)
      }
    end
  end
end
