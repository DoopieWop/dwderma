PANEL = {}

function PANEL:SetActiveSetting(setting)
    if !setting then return end

    if !setting.id or !setting.name or !setting.func then return end

    if self.ActiveSetting and self.ActiveSetting == setting.id then return end

    local old = self.ActiveSetting

    if old then
        for k, v in ipairs(self:GetChildren()) do
            v:Remove()
        end
        self:Remove()
    end

    self.ActiveSetting = setting.id

    setting.func(self)

    if self.OnActiveSettingChange then
        self:OnActiveSettingChange(setting)
    end
end

function PANEL:GetActiveSetting()
    return self.ActiveSetting
end

function PANEL:Paint(w, h)
end

vgui.Register("DWMenu", PANEL, "DPanel")