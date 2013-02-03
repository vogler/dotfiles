volume_widget = widget({ type = "textbox", name = "tb_volume", align = "right" })

function update_volume(widget)
        local fd = io.popen("amixer sget Master")
        local status = fd:read("*all")
        fd:close()
        
        local volume = string.match(status, "(%d?%d?%d)%%")

        status = string.match(status, "%[(o[^%]]*)%]")

        if string.find(status, "on", 1, true) then
            -- volume = "<span background='#" .. interpol_colour .. "'> "..volume.." </span>"
        else
            volume = "<span color='red'> M </span>"
        end
        widget.text = ' '..volume..' '
end

update_volume(volume_widget)
-- refresh volume every second
-- awful.hooks.timer.register(1, function () update_volume(volume_widget) end)
mytimer = timer({ timeout = 1 })
mytimer:add_signal("timeout", function() update_volume(volume_widget) end)
mytimer:start()
