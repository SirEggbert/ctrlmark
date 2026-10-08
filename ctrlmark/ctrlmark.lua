-- Stub. Replace this file with the ctrlmark you already tested in game.
local addonName = ...
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, name)
  if event == "ADDON_LOADED" and name == addonName then
    print("ctrlmark loaded (stub). Real marking logic is not in this file yet.")
  end
end)
