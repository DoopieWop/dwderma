PANEL = {}

function PANEL:OnSizeChanged()
	self:InvalidateChildren()
end

function PANEL:Paint(w, h)
    local col = HSVToColor(CurTime() * 50 % 360, 1, 1)
    draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
    surface.SetDrawColor(col.r, col.g, col.b, col.a)
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

vgui.Register("DWPanel", PANEL, "DPanel")