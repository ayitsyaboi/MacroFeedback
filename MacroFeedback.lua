-- Default settings
local defaults = {
    fontSize = 26,
    shadow = true,
    outline = true,
    anchorX = 0,
    anchorY = 0,
    cooldown = 0.5,
    duration = 0.8
}

-- Initialize saved variables table
if not MacroFeedbackDB then
    MacroFeedbackDB = {}
end
for k, v in pairs(defaults) do
    if MacroFeedbackDB[k] == nil then
        MacroFeedbackDB[k] = v
    end
end
COOLDOWN = MacroFeedbackDB.cooldown

-- Global state
lastFeedback = {}
currentTextFrame = nil

function MacroFeedback(msg, r, g, b)
    local now = GetTime()
    if lastFeedback[msg] and (now - lastFeedback[msg]) < MacroFeedbackDB.cooldown then
        return
    end
    lastFeedback[msg] = now

    ShowFloatingText(msg, r or 0.1, g or 1, b or 0.1)
end

function ShowFloatingText(msg, r, g, b)
    -- Kill old frame
    if currentTextFrame then
        currentTextFrame:Hide()
        currentTextFrame:SetScript("OnUpdate", nil)
        currentTextFrame = nil
    end

    local f = CreateFrame("Frame", nil, UIParent)
    f:SetWidth(400)
    f:SetHeight(100)
    f:SetPoint("CENTER", UIParent, "CENTER", MacroFeedbackDB.anchorX, MacroFeedbackDB.anchorY)

    local text = f:CreateFontString(nil, "OVERLAY")
    local fontFlags = MacroFeedbackDB.outline and "OUTLINE" or ""
    local fontSize = tonumber(MacroFeedbackDB.fontSize) or 26
    local fontFlags = MacroFeedbackDB.outline and "OUTLINE" or ""
    text:SetFont("Fonts\\FRIZQT__.TTF", fontSize, fontFlags)

    text:SetText(msg)
    text:SetTextColor(r, g, b)

    if MacroFeedbackDB.shadow then
        text:SetShadowColor(1, 1, 1, 1)
        text:SetShadowOffset(1, -1)
    else
        text:SetShadowOffset(0, 0)
    end

    text:SetPoint("CENTER", f, "CENTER", 0, 0)
    f.text = text

    currentTextFrame = f

    local startY = 0
    local endY = 80
    local duration = MacroFeedbackDB.duration
    local elapsed = 0
    local lastUpdate = GetTime()

    f:SetScript("OnUpdate", function()
        local now = GetTime()
        local deltaTime = now - lastUpdate
        lastUpdate = now

        elapsed = elapsed + deltaTime
        local progress = elapsed / duration
        if progress >= 1 then
            f:Hide()
            f:SetScript("OnUpdate", nil)
            currentTextFrame = nil
            return
        end

        local y = startY + (endY - startY) * progress
        text:SetPoint("CENTER", f, "CENTER", 0, y)
        text:SetAlpha(1 - progress)
    end)
end

function CreateMacroFeedbackOptions()
    local f = CreateFrame("Frame", "MacroFeedbackOptionsFrame", UIParent)
    f:SetWidth(240)
    f:SetHeight(400)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 100)

    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })

    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function() f:StartMoving() end)
    f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)

    -- Title text
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", f, "TOP", 0, -10)
    title:SetText("Macro Feedback Settings")

    -- Close button
    local close = CreateFrame("Button", nil, f)
    close:SetWidth(32)
    close:SetHeight(32)
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
    close:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    close:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
    close:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
    close:SetScript("OnClick", function() f:Hide() end)

    -- Font size label
    local sliderLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sliderLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -50)
    sliderLabel:SetText("Font Size:")

    -- Font size value display
    local sliderValue = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    sliderValue:SetPoint("LEFT", sliderLabel, "RIGHT", 10, 0)
    sliderValue:SetText(tostring(MacroFeedbackDB.fontSize or 26))

    -- Font size slider
    local slider = CreateFrame("Slider", "MacroFeedbackFontSizeSlider", f)
    slider:SetWidth(200)
    slider:SetHeight(16)
    slider:SetPoint("TOPLEFT", sliderLabel, "BOTTOMLEFT", 0, -10)
    slider:SetOrientation("HORIZONTAL")
    slider:SetMinMaxValues(10, 72)
    slider:SetValueStep(1)
    slider:SetValue(MacroFeedbackDB.fontSize or 26)

    -- Shadow checkbox
    local shadowCheckbox = CreateFrame("CheckButton", nil, f, "OptionsCheckButtonTemplate")
    shadowCheckbox:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -20)
    shadowCheckbox:SetChecked(MacroFeedbackDB.shadow)
    shadowCheckbox:SetScript("OnClick", function()
    MacroFeedbackDB.shadow = shadowCheckbox:GetChecked()
end)

 local shadowLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
 shadowLabel:SetPoint("LEFT", shadowCheckbox, "RIGHT", 5, 0)
 shadowLabel:SetText("Enable Shadow")

 -- Outline checkbox
 local outlineCheckbox = CreateFrame("CheckButton", nil, f, "OptionsCheckButtonTemplate")
 outlineCheckbox:SetPoint("TOPLEFT", shadowCheckbox, "BOTTOMLEFT", 0, -10)
 outlineCheckbox:SetChecked(MacroFeedbackDB.outline)
 outlineCheckbox:SetScript("OnClick", function()
    MacroFeedbackDB.outline = outlineCheckbox:GetChecked()
end)
 -- Duration label and value
 local durationLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
 durationLabel:SetPoint("TOPLEFT", outlineCheckbox, "BOTTOMLEFT", 0, -20)
 durationLabel:SetText("Time on Screen:")

 local durationValue = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
 durationValue:SetPoint("LEFT", durationLabel, "RIGHT", 10, 0)
 durationValue:SetText(string.format("%.1f", MacroFeedbackDB.duration))

 local durationSlider = CreateFrame("Slider", nil, f)
 durationSlider:SetWidth(200)
 durationSlider:SetHeight(16)
 durationSlider:SetPoint("TOPLEFT", durationLabel, "BOTTOMLEFT", 0, -10)
 durationSlider:SetOrientation("HORIZONTAL")
 durationSlider:SetMinMaxValues(0.2, 3.0)
 durationSlider:SetValueStep(0.1)
 durationSlider:SetValue(MacroFeedbackDB.duration)
 durationSlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
 durationSlider:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 3, right = 3, top = 6, bottom = 6 }
 })
 durationSlider:SetScript("OnValueChanged", function()
    local val = durationSlider:GetValue()
    MacroFeedbackDB.duration = val
    durationValue:SetText(string.format("%.1f", val))
 end)

-- X position
local xLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
xLabel:SetPoint("TOPLEFT", durationSlider, "BOTTOMLEFT", 0, -20)
xLabel:SetText("X Position:")

local xValue = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
xValue:SetPoint("LEFT", xLabel, "RIGHT", 10, 0)
xValue:SetText(tostring(MacroFeedbackDB.anchorX))

local xSlider = CreateFrame("Slider", nil, f)
xSlider:SetWidth(200)
xSlider:SetHeight(16)
xSlider:SetPoint("TOPLEFT", xLabel, "BOTTOMLEFT", 0, -10)
xSlider:SetOrientation("HORIZONTAL")
xSlider:SetMinMaxValues(-300, 300)
xSlider:SetValueStep(1)
xSlider:SetValue(MacroFeedbackDB.anchorX)
xSlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
xSlider:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 3, right = 3, top = 6, bottom = 6 }
})
xSlider:SetScript("OnValueChanged", function()
    local val = xSlider:GetValue()
    MacroFeedbackDB.anchorX = val
    xValue:SetText(string.format("%d", val))
end)

-- Y position
local yLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
yLabel:SetPoint("TOPLEFT", xSlider, "BOTTOMLEFT", 0, -20)
yLabel:SetText("Y Position:")

local yValue = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
yValue:SetPoint("LEFT", yLabel, "RIGHT", 10, 0)
yValue:SetText(tostring(MacroFeedbackDB.anchorY))

local ySlider = CreateFrame("Slider", nil, f)
ySlider:SetWidth(200)
ySlider:SetHeight(16)
ySlider:SetPoint("TOPLEFT", yLabel, "BOTTOMLEFT", 0, -10)
ySlider:SetOrientation("HORIZONTAL")
ySlider:SetMinMaxValues(-300, 300)
ySlider:SetValueStep(1)
ySlider:SetValue(MacroFeedbackDB.anchorY)
ySlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
ySlider:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 3, right = 3, top = 6, bottom = 6 }
})
ySlider:SetScript("OnValueChanged", function()
    local val = ySlider:GetValue()
    MacroFeedbackDB.anchorY = val
    yValue:SetText(string.format("%d", val))
end)


local outlineLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
outlineLabel:SetPoint("LEFT", outlineCheckbox, "RIGHT", 5, 0)
outlineLabel:SetText("Enable Outline")

slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
slider:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
    tile = true, tileSize = 8, edgeSize = 8,
    insets = { left = 3, right = 3, top = 6, bottom = 6 }
})

slider:SetScript("OnValueChanged", function()
    local value = slider:GetValue()
    if type(value) == "number" then
        MacroFeedbackDB.fontSize = value
        sliderValue:SetText(string.format("%d", value))

        if currentTextFrame and currentTextFrame.text then
            local fontFlags = MacroFeedbackDB.outline and "OUTLINE" or ""
            currentTextFrame.text:SetFont("Fonts\\FRIZQT__.TTF", value, fontFlags)
        end
    else
        sliderValue:SetText("Invalid")
    end
end)
    f:Hide()
end



SLASH_MACROFEEDBACK1 = "/mfb"
SlashCmdList["MACROFEEDBACK"] = function()
    if not MacroFeedbackOptionsFrame then
        CreateMacroFeedbackOptions()
    end
    MacroFeedbackOptionsFrame:Show()
end
