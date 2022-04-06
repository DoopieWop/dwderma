PANEL = {}

function PANEL:Init()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:DockPadding(5, 32, 5, 5)

	self.CloseButton = self:Add("DWGenericButton")
	self.CloseButton:SetSize(24, 24)
	self.CloseButton:SetPos(self:GetWide() - 28, 4)
	self.CloseButton:SetText("X")
	self.CloseButton.DoClick = function(s)
		self:Close()
	end
	self.CloseButton.PerformLayout = function(s)
		s:SetPos(self:GetWide() - 29, 4)
	end
end

function PANEL:OnSizeChanged()
	self:InvalidateChildren()
end

function PANEL:Paint(w, h)
    local col = HSVToColor(CurTime() * 50 % 360, 1, 1)
    draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
    surface.SetDrawColor(col.r, col.g, col.b, col.a)
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

vgui.Register("DWFrame", PANEL, "DFrame")