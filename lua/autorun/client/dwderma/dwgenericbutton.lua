PANEL = {}

PANEL.ButtonSound = "ui/buttonclickrelease.wav"

function PANEL:Paint(w, h)
    local norm = Color(50, 50, 50)
    local hover = Color(75, 75, 75)
    local depress = Color(100, 100, 100)
    local borderdepress = Color(125, 125, 125)

    local col = norm
    local borcol = hover

    if self:IsHovered() then
        col = hover
        borcol = depress
    elseif self:IsDown() then
        col = depress
        borcol = borderdepress
    end

    draw.RoundedBox(0, 0, 0, w, h, col)
    surface.SetDrawColor(borcol:Unpack())
    surface.DrawOutlinedRect(0, 0, w, h, 1)
end

function PANEL:OnDepressed()
    surface.PlaySound(self.ButtonSound)
end

vgui.Register("DWGenericButton", PANEL, "DButton")