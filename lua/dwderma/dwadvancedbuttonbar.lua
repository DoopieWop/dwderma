PANEL = {}

PANEL.ButtonSound = "ui/buttonclickrelease.wav"
PANEL.Buttons = {}
PANEL.IsExpanded = true
PANEL.IsExpanding = false

function PANEL:Init()
    self.ArrowMat = Material("icon16/arrow_left.png")

    self:DockPadding(0, 32, 0, 0)

    self.ExpandButton = self:Add("DWButton")
    self.ExpandButton:SetTall(32)
    self.ExpandButton:SetText("")
    self.ExpandButton.DoClick = function()
        self:SetExpanded(not self.IsExpanded)
    end
    self.ExpandButton.PaintOver = function(s, w, h)
        local b = self.IsExpanded or self.IsExpanding
        if self.IsExpanded and self.IsExpanding then
            b = false
        end

        local newValue = b and 0 or 180
        s.Rotation = Lerp(FrameTime() * 6, s.Rotation or 180, newValue)
        
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(self.ArrowMat)
        surface.DrawTexturedRectRotated(w / 2, h / 2, 32, 16, s.Rotation)
    end

    self.ExpansionPanel = self:Add("DPanel")
    self.ExpansionPanel:Dock(FILL)
    self.ExpansionPanel.Paint = function() end

    timer.Simple(0, function()
        self:CreateButtons()
        self:PerformLayout()
    end)
end

function PANEL:SetInitialExpansion(b)
    timer.Simple(0, function()
        local var = self.IsExpanded and self.SmallSize or self.BiggestSize

        self.IsExpanding = true
        self:SetWide(var)
        self.IsExpanding = false

        self.IsExpanded = not self.IsExpanded
    end)
end

function PANEL:SetExpanded(b)
    local var = self.IsExpanded and self.SmallSize or self.BiggestSize
    
    self.IsExpanding = true
    self:SizeTo(var, -1, 0.5, 0, -1, function()
        self.IsExpanding = false
        self.IsExpanded = not self.IsExpanded
    end)
end

function PANEL:CreateButtons()
    self.CreatedButtons = {}

    for k, v in ipairs(self.Buttons) do
        if !v.name or !v.func or !v.icon then continue end

        surface.SetFont(v.font or "DermaLarge")
        local textwidth, textsize = surface.GetTextSize(v.name)

        self.SmallSize = self.SmallSize or (textsize * 2) + 10
        self.BiggestSize = (self.BiggestSize or 0) <= (textsize * 2) + textwidth + 20 and (textsize * 2) + textwidth + 20 or self.BiggestSize

        self.CreatedButtons[k] = self.ExpansionPanel:Add("DButton")
        self.CreatedButtons[k]:Dock(TOP)
        self.CreatedButtons[k]:SetSize((textsize * 2) + textwidth + 20, (textsize * 2) + 10)
        self.CreatedButtons[k]:SetText("")
        self.CreatedButtons[k].DoClick = function(s)
            surface.PlaySound(v.ButtonSound or self.ButtonSound)

            v.func(self)
        end
        self.CreatedButtons[k].OnDepressed = function(s)
            self.CreatedButtons[k].matrix:Scale(Vector(0.9, 0.9, 0.9))
        end
        self.CreatedButtons[k].OnReleased = function(s)
            self.CreatedButtons[k].matrix:Scale(Vector(1, 1, 1))
        end
        self.CreatedButtons[k].Paint = function() end

        self.CreatedButtons[k].matrix = Matrix()
        self.CreatedButtons[k].matrix:Translate(Vector(((textsize * 2) + textwidth + 20) / 2, ((textsize * 2) + 10) / 2))

        cam.PushModelMatrix(self.CreatedButtons[k].matrix)
        self.CreatedButtons[k].Icon = self.CreatedButtons[k]:Add("DImage")
        self.CreatedButtons[k].Icon:SetImage(v.icon)
        self.CreatedButtons[k].Icon:SetSize(textsize * 2, textsize * 2)
        self.CreatedButtons[k].Icon:SetPos(5, 5)

        self.CreatedButtons[k].Text = self.CreatedButtons[k]:Add("DLabel")
        self.CreatedButtons[k].Text:SetText(v.name)
        self.CreatedButtons[k].Text:SetFont(v.font or "DermaLarge")
        self.CreatedButtons[k].Text:SetPos(10 + textsize * 2, 5 + ((textsize * 2) + 10) / 4)
        self.CreatedButtons[k].Text:SizeToContents()
        self.CreatedButtons[k].Text.OnDepressed = function(s)
            s.IsPressing = true
        end
        self.CreatedButtons[k].Text.OnReleased = function(s)
            s.IsPressing = false
        end
        self.CreatedButtons[k].Text.IsDown = function(s) 
            return s.IsPressing or false
        end
        self.CreatedButtons[k].Text.Think = function(s)
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
        cam.PopModelMatrix()
    end

    self.ExpandButton:SetWide(self.SmallSize)
end

--[[
function PANEL:PerformLayout()
    if !self.CreatedButtons or table.IsEmpty(self.CreatedButtons) then return end

    self.ExpansionPanel:SetTall(self:GetTall() - 32)

    local sum = #self.CreatedButtons
    local height = self.ExpansionPanel:GetTall()

    for k, v in ipairs(self.CreatedButtons) do
        if !IsValid(v) then continue end

        local segment = height / sum
        local segmentbit = segment * (k - 1)
        local pos, middle = 0, segmentbit + segment / 4

        v:SetPos(pos, middle)
    end
end
--]]

function PANEL:Paint(w, h)
    local blue = Color(52, 51, 58)
    local b = self.IsExpanding or self.IsExpanded

    if b then
        draw.RoundedBoxEx(17, 0, 0, w, h, blue, false, true, false, true)
    else
        draw.RoundedBox(0, 0, 0, w, h, blue)
    end
end

function PANEL:OnSizeChanged()
    self:InvalidateChildren()
end

vgui.Register("DWAdvancedButtonBar", PANEL, "DPanel")