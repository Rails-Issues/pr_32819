# pr_32819

I tried reproducing https://github.com/rails/rails/issues/32819

Requirements:
- ruby 2.4.1
- rails commit id bd53f35

Command:
> ruby -I test pr_1.rb


SQL Output:
```
  SELECT "captains"."id" AS t0_r0, "ships"."id" AS t1_r0, "ships"."captain_id" AS t1_r1, "sails"."id" AS t2_r0, "sails"."ship_id" AS t2_r1, "sails"."color" AS t2_r2, "anchors"."id" AS t3_r0, "anchors"."ship_id" AS t3_r1 FROM "captains" 
  LEFT OUTER JOIN "ships" ON "ships"."captain_id" = "captains"."id" 
  LEFT OUTER JOIN "ships" "ships_captains_join" ON "ships_captains_join"."captain_id" = "captains"."id" 
  LEFT OUTER JOIN "sails" ON "sails"."ship_id" = "ships_captains_join"."id" AND"sails"."color" = 'red' 
  LEFT OUTER JOIN "ships" "ships_captains_join_2" ON "ships_captains_join_2"."captain_id" = "captains"."id" 
  LEFT OUTER JOIN "anchors" ON "anchors"."ship_id" = "ships_captains_join_2"."id"
```

Description:
If you notice the query generated as above, you can notice there are 3 `LEFT OUTER JOIN "ships"`. Fix should generate query with one `LEFT OUTER JOIN "ships"`
