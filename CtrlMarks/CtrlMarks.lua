-- CtrlMarks 1.18
-- Eggbert Gaming Studios
-- Click behavior is locked. Icons sit on a gold ring, just inside the stone.

local MARKS = {
  { id = 8, name = "Skull",    tip = "Kill" },
  { id = 7, name = "Cross",    tip = "Second / sheep" },
  { id = 4, name = "Triangle", tip = "Third" },
  { id = 3, name = "Diamond",  tip = "Fourth" },
  { id = 1, name = "Star",     tip = "Star" },
  { id = 2, name = "Circle",   tip = "Circle" },
  { id = 5, name = "Moon",     tip = "Moon" },
  { id = 6, name = "Square",   tip = "Square" },
}

local GROUND = {
  { id = 8, name = "Skull",    tip = "White skull" },
  { id = 4, name = "Cross",    tip = "Red cross" },
  { id = 2, name = "Triangle", tip = "Green triangle" },
  { id = 3, name = "Diamond",  tip = "Purple diamond" },
  { id = 5, name = "Star",     tip = "Yellow star" },
  { id = 6, name = "Circle",   tip = "Orange circle" },
  { id = 7, name = "Moon",     tip = "Silver moon" },
  { id = 1, name = "Square",   tip = "Blue square" },
}

local unitWheel, groundWheel, catcher
local acceptOutside = false

local function HideWheels()
  acceptOutside = false
  if unitWheel then unitWheel:Hide() end
  if groundWheel then groundWheel:Hide() end
  if catcher then catcher:Hide() end
end

local function Place(frame)
  local x, y = GetCursorPosition()
  local scale = UIParent:GetEffectiveScale()
  frame:ClearAllPoints()
  frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale + 40)
end

local function ShowWheel(frame)
  Place(frame)
  frame:Show()
  acceptOutside = false
  if catcher then catcher:Hide() end
  C_Timer.After(0.3, function()
    if frame:IsShown() and catcher and not IsMouseButtonDown("LeftButton") then
      catcher:Show()
      acceptOutside = true
    end
  end)
end

local function MarkMacro(index)
  return string.format("/tm [@target,exists,nodead] %d", index)
end

local function CanMark()
  if not IsInGroup() then
    return true
  end
  return UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
end

local function GroundAllowed()
  if not IsInGroup() then
    print("|cffff8080CtrlMarks:|r ground marking does not work unless you are in a group.")
    return false
  end
  if not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
    print("|cffff8080CtrlMarks:|r you must be the party leader or marked as assist to place ground markers.")
    return false
  end
  return true
end

local function MakeShell()
  local frame = CreateFrame("Frame", nil, UIParent)
  frame:SetSize(250, 250)
  frame:SetFrameStrata("DIALOG")
  frame:SetClampedToScreen(true)
  frame:Hide()
  local border = frame:CreateTexture(nil, "BACKGROUND")
  border:SetTexture("Interface\\AddOns\\CtrlMarks\\Ring")
  border:SetPoint("CENTER")
  border:SetSize(240, 240)
  local gold = frame:CreateTexture(nil, "BORDER")
  gold:SetTexture("Interface\\AddOns\\CtrlMarks\\Gold")
  gold:SetPoint("CENTER")
  gold:SetSize(176, 176)
  return frame
end

local function AddIcon(parent, i, count, texture, macro, tipTitle, tipText, worldMarker)
  local radius = 86
  local angle = math.rad(-90 + (i - 1) * (360 / count))
  local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
  button:SetSize(22, 22)
  button:SetFrameLevel(parent:GetFrameLevel() + 10)
  button:SetPoint("CENTER", parent, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
  button:SetNormalTexture(texture)
  button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
  button:RegisterForClicks("AnyUp", "AnyDown")
  if worldMarker then
    button:SetAttribute("type", "worldmarker")
    button:SetAttribute("marker", worldMarker)
  else
    button:SetAttribute("type", "macro")
    button:SetAttribute("macrotext", macro)
  end
  button:HookScript("PostClick", function()
    HideWheels()
  end)
  button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(tipTitle, 1, 0.82, 0)
    GameTooltip:AddLine(tipText, 1, 1, 1, true)
    GameTooltip:Show()
  end)
  button:SetScript("OnLeave", function() GameTooltip:Hide() end)
  return button
end

local function BuildWheels()
  catcher = CreateFrame("Button", nil, UIParent)
  catcher:SetAllPoints(UIParent)
  catcher:SetFrameStrata("HIGH")
  catcher:RegisterForClicks("AnyUp")
  catcher:Hide()
  catcher:SetScript("OnClick", function()
    if acceptOutside then
      HideWheels()
    end
  end)

  unitWheel = MakeShell()
  for i, mark in ipairs(MARKS) do
    AddIcon(unitWheel, i, #MARKS, "Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..mark.id, MarkMacro(mark.id), mark.name, mark.tip)
  end
  local clear = AddIcon(unitWheel, 1, 1, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", MarkMacro(0), "Clear", "Clears the mark on your target")
  clear:ClearAllPoints()
  clear:SetPoint("CENTER", unitWheel, "CENTER", 0, 4)

  groundWheel = MakeShell()
  for i, mark in ipairs(GROUND) do
    AddIcon(
      groundWheel, i, #GROUND,
      "Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..({[8]=8,[4]=7,[2]=4,[3]=3,[5]=1,[6]=2,[7]=5,[1]=6})[mark.id],
      "/wm "..mark.id,
      mark.name,
      mark.tip..". Click the icon, then click the ground.",
      mark.id
    )
  end

  local opener = CreateFrame("Button", "CtrlMarksSecureOpen", UIParent, "SecureActionButtonTemplate")
  opener:SetSize(1, 1)
  opener:SetPoint("CENTER")
  opener:Hide()
  opener:RegisterForClicks("AnyUp", "AnyDown")
  opener:SetAttribute("type", "macro")
  opener:SetAttribute("macrotext", "/target [@mouseover,exists,nodead]")
  opener:HookScript("PostClick", function()
    if UnitExists("mouseover") or UnitExists("target") then
      if IsInGroup() and not CanMark() then
        print("|cffff8080CtrlMarks:|r you must be the party leader or marked as assist to mark.")
        return
      end
      ShowWheel(unitWheel)
    else
      if not GroundAllowed() then
        return
      end
      ShowWheel(groundWheel)
    end
  end)
end

function CtrlMarks_Open()
  if not unitWheel then
    return
  end
  if unitWheel:IsShown() or groundWheel:IsShown() then
    HideWheels()
    return
  end
  if UnitExists("mouseover") then
    ShowWheel(unitWheel)
  else
    if not GroundAllowed() then
      return
    end
    ShowWheel(groundWheel)
  end
end

local function Help()
  print("|cff80ff80CtrlMarks 1.11|r Eggbert Gaming Studios")
  print("Point at a player or NPC and Ctrl+left click. The wheel targets it. Pick an icon to mark it. The center button clears that mark. The wheel closes after a choice.")
  print("Click empty screen to cancel.")
  print("Point at empty ground and Ctrl+left click for a ground marker. Pick an icon, then click the ground.")
  print("Ground markers do not work unless you are in a group. In a group, you must be the party leader or marked as assist.")
  print("Bind, out of combat: /run SetBinding(\"CTRL-BUTTON1\", \"CLICK CtrlMarksSecureOpen:LeftButton\"); SaveBindings(2)")
end

local function Slash(msg)
  msg = (msg or ""):lower()
  if msg == "help" then
    Help()
  elseif msg == "hide" then
    HideWheels()
  else
    Help()
  end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
  BuildWheels()
  SLASH_CTRLMARKS1 = "/cm"
  SLASH_CTRLMARKS2 = "/cmark"
  SLASH_CTRLMARKS3 = "/ctrlmarks"
  SlashCmdList.CTRLMARKS = Slash
  print("|cff80ff80Thank you for using the CtrlMarks addon by Eggbert Gaming Studios.|r Type /cm help for more information.")
  print("|cff80ff80CtrlMarks:|r if the mob is not targeted, paste this out of combat: /run SetBinding(\"CTRL-BUTTON1\", \"CLICK CtrlMarksSecureOpen:LeftButton\"); SaveBindings(2)")
end)
