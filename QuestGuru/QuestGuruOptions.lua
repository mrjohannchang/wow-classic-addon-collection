	-- Local vars and funcs
local addonName, QUESTGURUADDON = ...;

QUESTGURUADDON_G.TOOLTIP = { };
ESTGURUADDON_G.TOOLTIP.OBJECTIVE= "Selects which sound to use for objectives";
QUESTGURUADDON_G.TOOLTIP.COMPLETED = "Selects which sound to use for completed quest";
QUESTGURUADDON_G.TOOLTIP.MUTE = "Mute all quest sounds";
QUESTGURUADDON_G.TOOLTIP.SHOWQUESTLEVELS = "Show quest levels in QuestGuru";
QUESTGURUADDON_G.TOOLTIP.QGTOOLTIP = "Enable tooltips in QuestGuru";

-- Temp global & player options
local QuestGuruTempConfig = {};
local QuestGuruTempPlayerConfig = {};

function QUESTGURUADDON_G.Options_OnLoad(self)

    QuestGuru_Options_Title:SetText(QUESTGURUADDON.NAME);

    self.name = QUESTGURUADDON.NAME;
    self.default = QUESTGURUADDON.Options_SetDefaults;
    self.refresh = QUESTGURUADDON.Options_Init;
--    self.okay = QUESTGURUADDON.Options_OkayButton;
    self.cancel = QUESTGURUADDON.Options_CancelButton;

    InterfaceOptions_AddCategory(self);

end




function QUESTGURUADDON.Options_Init()

    QuestGuruTempConfig = CopyTable(QuestGuruConfig);
    QuestGuruTempPlayerConfig = CopyTable(QuestGuruPlayerConfig);

    UIDropDownMenu_SetSelectedValue(QuestGuru_Options_Objective, QuestGuruPlayerConfig.Objective);
    UIDropDownMenu_SetText(QuestGuru_Options_Objective, QuestGuruPlayerConfig.Objective);

    UIDropDownMenu_SetSelectedValue(QuestGuru_Options_Completed, QuestGuruPlayerConfig.Completed);
    UIDropDownMenu_SetText(QuestGuru_Options_Completed, QuestGuruPlayerConfig.Completed);

	QuestGuru_Options_Mute:SetChecked(QuestGuruPlayerConfig.Mute);

    QuestGuru_Options_ShowQuestLevels:SetChecked(QuestGuruPlayerConfig.ShowQuestLevels);
    QUESTGURUADDON_G.Options_ShowQuestLevels_OnClick(QuestGuru_Options_ShowQuestLevels, true);

    QuestGuru_Options_QGTooltip:SetChecked(QuestGuruPlayerConfig.QGTooltip);
    QUESTGURUADDON_G.Options_QGTooltip_OnClick(QuestGuru_Options_QGTooltip, true);

    if (QUESTGURUADDON.framePositioned == true) then
        QUESTGURUADDON.GetAll();
    end
end

function QUESTGURUADDON.Options_Objective_OnClick(self)
    i = self:GetID();
    UIDropDownMenu_SetSelectedID(QuestGuru_Options_Objective, i);
    QuestGuruPlayerConfig.Objective = QUESTGURUADDON.MODE_DROPDOWN_LIST[i];
    QUESTGURUADDON.Set_UNIT_IDs();
    QUESTGURUADDON.ResizeWindow();
end

function QUESTGURUADDON.Options_Objective_Initialize()
    local info;
    for i = 1, #QUESTGURUADDON.MODE_DROPDOWN_LIST do
        info = {
            text = QUESTGURUADDON.MODE_DROPDOWN_LIST[i],
            func = QUESTGURUADDON.Options_Objective_OnClick
        };
        UIDropDownMenu_AddButton(info);
    end
end

function QUESTGURUADDON_G.Options_Objective_OnLoad(self)
    UIDropDownMenu_Initialize(self, QUESTGURUADDON.Options_Objective_Initialize);
    UIDropDownMenu_SetWidth(self, 90);
end

function QUESTGURUADDON.Options_Completed_OnClick(self)
    i = self:GetID();
    UIDropDownMenu_SetSelectedID(QuestGuru_Options_Completed, i);
    QuestGuruPlayerConfig.Completed = QUESTGURUADDON.SORTORDER_DROPDOWN_LIST[i];
    QUESTGURUADDON.PositionAllPlayerFrames();
end

function QUESTGURUADDON.Options_Completed_Initialize()
    local info;
    for i = 1, #QUESTGURUADDON.SORTORDER_DROPDOWN_LIST do
        info = {
            text = QUESTGURUADDON.SORTORDER_DROPDOWN_LIST[i],
            func = QUESTGURUADDON.Options_Completed_OnClick
        };
        UIDropDownMenu_AddButton(info);
    end
end

function QUESTGURUADDON_G.Options_Completed_OnLoad(self)
    UIDropDownMenu_Initialize(self, QUESTGURUADDON.Options_Completed_Initialize);
--    UIDropDownMenu_SetText(self, QuestGuruPlayerConfig.Completed);
    UIDropDownMenu_SetWidth(self, 90);
end
--[[

function QUESTGURUADDON.Options_AnchorPoint_OnClick(self)
    i = self:GetID();
    UIDropDownMenu_SetSelectedID(QuestGuru_Options_AnchorPoint, i);
    QuestGuruPlayerConfig.AnchorPoint = QUESTGURUADDON.ANCHORPOINT_DROPDOWN_LIST[i];
    QUESTGURUADDON.GetPoint(QuestGuruFrame, QUESTGURUADDON.ANCHORPOINT_DROPDOWN_MAP[QuestGuruPlayerConfig.AnchorPoint]);
end

function QUESTGURUADDON.Options_AnchorPoint_Initialize()
    local info;
    for i = 1, #QUESTGURUADDON.ANCHORPOINT_DROPDOWN_LIST do
        info = {
            text = QUESTGURUADDON.ANCHORPOINT_DROPDOWN_LIST[i],
            func = QUESTGURUADDON.Options_AnchorPoint_OnClick
        };
        UIDropDownMenu_AddButton(info);
    end
end

function QUESTGURUADDON_G.Options_AnchorPoint_OnLoad(self)
    UIDropDownMenu_Initialize(self, QUESTGURUADDON.Options_AnchorPoint_Initialize);
--    UIDropDownMenu_SetText(self, QuestGuruPlayerConfig.AnchorPoint);
    UIDropDownMenu_SetWidth(self, 100);
end
]]

function QUESTGURUADDON_G.Options_Mute_OnClick(self)
    if (self:GetChecked()) then
        QuestGuruPlayerConfig.Mute = true;
    else
        QuestGuruPlayerConfig.Mute = false;
    end
end

function QUESTGURUADDON_G.Options_ShowQuestLevels_OnClick(self, suppressRefresh)
    if (self:GetChecked()) then
        QuestGuruPlayerConfig.ShowQuestLevels = true;
        QUESTGURUADDON_G.Options_EnableCheckbox(QuestGuru_Options_ShowQuestLevels);
    else
        QuestGuruPlayerConfig.ShowQuestLevels = false;
        if QuestGuruPlayerConfig.ShowCastableBuffs == false then
          QUESTGURUADDON_G.Options_DisableCheckbox(QuestGuru_Options_ShowQuestLevels);
        end
    end
end

function QUESTGURUADDON_G.Options_QGTooltip_OnClick(self, ...)
    if (self:GetChecked()) then
        QuestGuruPlayerConfig.QGTooltip = true;
        QUESTGURUADDON_G.Options_EnableCheckbox(QuestGuru_Options_QGTooltip);
    else
        QuestGuruPlayerConfig.QGTooltip = false;
        if QuestGuruPlayerConfig.QGTooltip == false then
          QUESTGURUADDON_G.Options_DisableCheckbox(QuestGuru_Options_QGTooltip);
        end
    end
end

function QUESTGURUADDON.Options_SetDefaults()
    QuestGuruConfig = CopyTable(QUESTGURUADDON.DEFAULTS);
    QuestGuruPlayerConfig = CopyTable(QUESTGURUADDON.PLAYER_DEFAULTS);
end

--[[
function QUESTGURUADDON.Options_OkayButton()
-- Temporary disabled until the RAID filter is working again, or a new method is found
QuestGuruPlayerConfig.ShowCastableBuffs = false;
end
]]

function QUESTGURUADDON.Options_CancelButton()
    QuestGuruConfig = CopyTable(QuestGuruTempConfig);
    QuestGuruPlayerConfig = CopyTable(QuestGuruTempPlayerConfig);
    QUESTGURUADDON.Options_Init();
    QUESTGURUADDON.GetAllBuffs();
end

function QUESTGURUADDON_G.Options_EnableCheckbox(checkbox)
    checkbox:Enable();
    _G[checkbox:GetName().."Text"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
end

function QUESTGURUADDON_G.Options_DisableCheckbox(checkbox)
    checkbox:Disable();
    _G[checkbox:GetName().."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
end