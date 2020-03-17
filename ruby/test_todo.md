tests todo:
1. all names remain unchanged
2. test batteries for:
  a. normal item
  b. aged brie
  c. sulfuras
  d. backstage passes
Test batteries for each should test:
  a. correct sell_in updating logic
  b. correct quality updating logic for sell_in >= 0
  b. correct quality updating logic for sell_in < 0 (note: for aged brie, this means increasing by 2)
  c. updating over multiple days
3. correctly switches update logic over 'break points'
  a. sell_in < 0 for normal items, backstage passes
  b. sell_in < 10 for backstage passes
  c. sell_in < 5 for backstage passes
4. correctly updates multiple different types of items simultaneously
5. Quality never > 50
6. Quality never < 0
7. Test battery for conjured items
8. integrate conjured items into #4
