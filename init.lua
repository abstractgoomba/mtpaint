paint = {}
paint.loopmax=50
paint.loops=0
--function
paint.replace = function(user, position, replace, replacer)
  
  if paint.loops > 2000 then return end
  paint.loops = paint.loops + 1
	local node = replacer
	local pos = position
	
	minetest.env:set_node(pos,{name=node})
	
	for i=-1,1,2 do
		local p = {x=pos.x+i, y=pos.y, z=pos.z}
		local n = minetest.env:get_node(p).name
		if n == replace then
			minetest.env:set_node(p,{name=node})
			paint.replace(user,p, replace, replacer)
		end
	end

	for i=-1,1,2 do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
		local n = minetest.env:get_node(p).name
	if n == replace then
			minetest.env:set_node(p,{name=node})
			paint.replace(user,p, replace, replacer)
		end
  end
  
  for i=-1,1,2 do
	  local p = {x=pos.x, y=pos.y, z=pos.z+i}
	  local n = minetest.env:get_node(p).name
	  if n == replace then
	    minetest.env:set_node(p,{name=node})
      paint.replace(user,p, replace, replacer)
	  end
  end
end

--tools
minetest.register_tool("paint:eraser", {
	description = "Eraser",
	inventory_image = "paint_eraser.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			minetest.env:remove_node(pointed_thing.under)
		end
	end,
})

minetest.register_tool("paint:pencil", {
	description = "Pencil",
	inventory_image = "paint_pencil.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local node = user:get_inventory():get_stack("main", 1):get_name()
			if user:get_player_control().sneak then
			  minetest.env:set_node(pointed_thing.under,{name=node})
			else
			  minetest.env:set_node(pointed_thing.above,{name=node})
			end
		end
	end,
	on_place = function(self, user, pointed_thing)
		if pointed_thing.above then
			local node = user:get_inventory():get_stack("main", 2):get_name()
			if user:get_player_control().sneak then
			  minetest.env:set_node(pointed_thing.under,{name=node})
			else
			  minetest.env:set_node(pointed_thing.above,{name=node})
			end
		end
	end,
})

minetest.register_tool("paint:picker", {
	description = "Picker",
	inventory_image = "paint_picker.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing then
			local node = minetest.env:get_node(pointed_thing.under).name
			local oldnode = user:get_inventory():get_stack("main", 1):get_name()
			local stack = ItemStack(oldnode)
			local inv = user:get_inventory()
			inv:set_stack("main", 1, node)
			if inv:contains_item("main", oldnode) then
			else
				if inv:room_for_item("main", stack) then
					inv:add_item("main", oldnode.." 1")
				end
			end
		end
	end,
	on_place = function(self, user, pointed_thing)
		if pointed_thing then
			local node = minetest.env:get_node(pointed_thing.under).name
			local oldnode = user:get_inventory():get_stack("main", 2):get_name()
			local stack = ItemStack(oldnode)
			local inv = user:get_inventory()
			inv:set_stack("main", 2, node)
			if inv:contains_item("main", oldnode) then
			else
				if inv:room_for_item("main", stack) then
					inv:add_item("main", oldnode.." 1")
				end
			end
		end
	end,
})

minetest.register_tool("paint:fill", {
	description = "Fill",
	inventory_image = "paint_fill.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
		  local pos = pointed_thing.under
		  local replace = minetest.env:get_node(pos).name
		  local replacer = user:get_inventory():get_stack("main", 1):get_name()
		  paint.loops = 0
			paint.replace(user, pos, replace, replacer)
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
		  local pos = pointed_thing.under
		  local replace = minetest.env:get_node(pos).name
		  local replacer = user:get_inventory():get_stack("main", 2):get_name()
		  paint.loops = 0
			paint.replace(user, pos, replace, replacer)
		end
	end,
	
})

--[[WIP
minetest.register_tool("paint:select_square", {
	description = "Square selection",
	inventory_image = "paint_select_square.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			minetest.env:remove_node(pointed_thing.under)
		end
	end,
})

minetest.register_tool("paint:select_ellipse", {
	description = "Ellipse selection",
	inventory_image = "paint_select_ellipse.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			minetest.env:remove_node()
		end
	end,
})
]]--