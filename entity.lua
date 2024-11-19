-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Emitter = require("emitter")


local Entity = Emitter:extend()


function Entity:new(order)
    self.created_at = love.timer.getTime() / 1e7
    self.is_alive = true -- delete this entity in the next frame
    self.is_visible = true -- ignore this entity in the draw loop
    self.is_active = true -- ignore this entity in the update loop

    self:set_order(order or 0)
end


function Entity:set_visible(visible)
    self.is_visible = visible
end


function Entity:enable_sort_y()
    self.should_sort_y = true
end


function Entity:mark_as_ui()
    self.is_ui = true
end


function Entity:mark_as_permanent()
    self.is_permanent = true
end


-- this function is used on the y-sort. If you enable the y-sort
-- and you don't have that function overrided, the game will intentionally crash.
function Entity:bottom()
    error("not overriden")
end


function Entity:set_order(order)
    self.order = order + self.created_at
end


-- since we use flags to mark entities as unactive,
-- we need to wait the next frame until the entity get real destroyed.
-- There are cases where the entity is flagged as "kill" before it execution,
-- so in that case the entity will be destroyed at same frame. 
function Entity:destroy()
    if not self.is_permanent then
        self.is_alive = false
    end
end


function Entity:set_tag(...)
    if not self.tags then
        self.tags = { }
    end

    for i = 1, select("#", ...) do
        local name = select(i, ...)
    
        self.tags[name] = true
    end
end


function Entity:are(tag_name)
    if not self.tags then
        return false
    end

    return self.tags[tag_name] == true
end


function Entity:update(dt)
end


function Entity:draw()
end


function Entity:debug()
end


function Entity:destruct()
end


function Entity:cull(x, y, w, h)
    return true
end


return Entity