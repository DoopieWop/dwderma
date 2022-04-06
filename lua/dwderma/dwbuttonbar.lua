PANEL = {}

PANEL.IsHorizontal = true
PANEL.ButtonSound = "ui/buttonclickrelease.wav"
PANEL.Buttons = {}

function PANEL:Init()
    timer.Simple(0, function()
        self:CreateButtons()
        self:PerformLayout()
    end)
end

function PANEL:CreateButtons()
    self.CreatedButtons = {}

    for k, v in ipairs(self.Buttons) do
        if !v.name or !v.func then continue end

        self.CreatedButtons[k] = self:Add("DLabel")
        self.CreatedButtons[k]:SetText(v.name)
        self.CreatedButtons[k]:SetFont(v.font or "DermaLarge")
        self.CreatedButtons[k]:SizeToContents()
        self.CreatedButtons[k]:SetMouseInputEnabled(true)
        self.CreatedButtons[k].DoClick = function(s)
            surface.PlaySound(v.ButtonSound or self.ButtonSound)

            v.func(self)
        end
        self.CreatedButtons[k].OnDepressed = function(s)
            s.IsPressing = true
        end
        self.CreatedButtons[k].OnReleased = function(s)
            s.IsPressing = false
        end
        self.CreatedButtons[k].IsDown = function(s) 
            return s.IsPressing or false
        end
        self.CreatedButtons[k].Think = function(s)
            local norm = Color(255, 255, 255)
            local hover = Color(250, 245, 180)
            local depress = Color(255, 240, 75)
        
            local col = norm
            
            if s:IsDown() then
                col = depress
            elseif s:IsHovered() then
                col = hover
            end

            if s:GetTextColor() != col then
                s:SetTextColor(col)
            end
        end
    end
end

function PANEL:PerformLayout()
    if !self.CreatedButtons or table.IsEmpty(self.CreatedButtons) then return end

    local sum = #self.CreatedButtons
    local width, height = self:GetWide(), self:GetTall()

    for k, v in ipairs(self.CreatedButtons) do
        if !IsValid(v) then continue end

        local text = v:GetText()
        local font = v:GetFont()
        surface.SetFont(font)
        local fontsizew, fontsizeh = surface.GetTextSize(text)
        local segment = self.IsHorizontal and width / sum or height / sum
            local segmentbit = (segment * k) - (segment / 2)
            local pos, middle = self.IsHorizontal and segmentbit - (fontsizew / 2) or segmentbit - (fontsizeh / 2), self.IsHorizontal and height / 2 - fontsizeh / 2 or width / 2 - fontsizew / 2

        v:SetPos(pos, middle)
    end
end

function PANEL:Paint(w, h)
end

function PANEL:OnSizeChanged()
    self:InvalidateChildren()
end

vgui.Register("DWButtonBar", PANEL, "DPanel")