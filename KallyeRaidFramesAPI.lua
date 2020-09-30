function KRF_SetDefaultOptions(DefaultOptions, reset)
	if reset or KallyeRaidFramesOptions == nil then
		KallyeRaidFramesOptions = CopyTable(DefaultOptions)
	else
		foreach(DefaultOptions,
			function (k, v)
				if KallyeRaidFramesOptions[k] == nil then
					KallyeRaidFramesOptions[k] = v;
				end
			end
		);
	end
end


function UnitInPartyOrRaid(Unit)
	return UnitInParty(Unit) or UnitInRaid(Unit) or UnitIsUnit(Unit, "player")
end

function FrameIsCompact(frame)
	return strsub(frame:GetName(), 0, 7) == "Compact"
end


--[[
! Managing Health & Alpha
]]
function KRF_UpdateHealth(frame, health)
	if KallyeRaidFramesOptions.UpdateHealthColor then
		if not KallyeRaidFramesOptions.RevertBar then
			UpdateHealth_Regular(frame, health)
		else
			UpdateHealth_Reverted(frame, health)
		end
	end
end

--[[
! Managing Alpha depending on range
]]
function KRF_UpdateInRange(frame)
	if FrameIsCompact(frame) then
		local isInRange, hasCheckedRange = UnitInRange(frame.displayedUnit)
		if KallyeRaidFramesOptions.AlphaNotInRange < 1 and hasCheckedRange and not isInRange then
			frame:SetAlpha(KallyeRaidFramesOptions.AlphaNotInRange);
		elseif not InCombatLockdown() and not _G.KRF_IsDebugFramesTimerActive and KallyeRaidFramesOptions.AlphaNotInCombat < 1 then
			frame:SetAlpha(KallyeRaidFramesOptions.AlphaNotInCombat);
		else
			frame.name:SetAlpha(1);
		end
	end
end
--[[
! Managing Health color: background
]]
function UpdateHealth_Regular(frame, health)
	if not frame:IsForbidden() and frame.background and UnitInPartyOrRaid(frame.displayedUnit) and FrameIsCompact(frame) then
		health = health or UnitHealth(frame.displayedUnit)
		local unitHealthMax = UnitHealthMax(frame.displayedUnit);
		local healthPercentage = ceil((health / unitHealthMax * 100))

		local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];
		if c and frame.optionTable.useClassColors then
			frame.healthBar:SetStatusBarColor(darken(c.r, c.g, c.b, .2, .95))
		end
		if healthPercentage > 0 then
			frame.background:SetColorTexture(GetHPSeverity(healthPercentage/100, false))
			if frame.wasDead then
				KRF_UpdateNameColor(frame); -- reset color according options
				frame.wasDead = false;
			end
		else
			-- Unit is dead
			frame.healthBar:SetStatusBarColor(darken(KallyeRaidFramesOptions.BGColorLow.r, KallyeRaidFramesOptions.BGColorLow.g, KallyeRaidFramesOptions.BGColorLow.b, .8, .3));
			frame.name:SetTextColor(KallyeRaidFramesOptions.BGColorLow.r, KallyeRaidFramesOptions.BGColorLow.g, KallyeRaidFramesOptions.BGColorLow.b)
			frame.wasDead = true;
		end
	end
end

--[[
! Managing Health color: reverted bar
TODO : réduire la barre en hauteur, mettre un contour comme sRaidFrames
]]
function UpdateHealth_Reverted(frame, health)
	-- frame.optionTable.colorNameBySelection
	-- frame.optionTable.useClassColors
	-- frame.myHealPredictionBar
	-- frame.otherHealPredictionBar
	if not frame:IsForbidden() and UnitInPartyOrRaid(frame.displayedUnit) and FrameIsCompact(frame) then
		health = health or UnitHealth(frame.displayedUnit)
		local unitHealthMax = UnitHealthMax(frame.displayedUnit);
		local healthPercentage = ceil((health / unitHealthMax * 100))
		local healthLost = unitHealthMax - health;

		frame.name:SetAlpha(1);
		local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.unit))];

		if c and frame and frame.background and frame.optionTable.useClassColors then
			frame.background:SetColorTexture(darken(c.r, c.g, c.b, .7, .8))
			frame.name:SetShadowColor(c.r, c.g, c.b, .3)
		end

		if healthPercentage > 0 then
			frame.healthBar:SetStatusBarColor(GetHPSeverity(healthPercentage/100, true));
			if frame.wasDead then
				KRF_UpdateNameColor(frame); -- reset color according options
				frame.wasDead = false;
			end
		else
			-- Unit is dead
			frame.healthBar:SetStatusBarColor(darken(KallyeRaidFramesOptions.RevertBGColorLow.r, KallyeRaidFramesOptions.RevertBGColorLow.g, KallyeRaidFramesOptions.RevertBGColorLow.b, .8, .3));
			frame.name:SetTextColor(KallyeRaidFramesOptions.RevertBGColorLow.r, KallyeRaidFramesOptions.RevertBGColorLow.g, KallyeRaidFramesOptions.RevertBGColorLow.b, KallyeRaidFramesOptions.RevertBGColorLow.a);
			frame.wasDead = true;
		end

		if ( frame.optionTable.smoothHealthUpdates ) then
			if ( frame.newUnit ) then
				frame.healthBar:ResetSmoothedValue(healthLost);
				frame.newUnit = false;
			else
				frame.healthBar:SetSmoothedValue(healthLost);
			end
		else
			frame.healthBar:SetValue(healthLost);
		end
	end
end

--[[
! UpdateRoleIcon
Role Icon on top left, visible only for tanks / heals
]]
function KRF_UpdateRoleIcon(frame)
	if KallyeRaidFramesOptions.HideDamageIcons or KallyeRaidFramesOptions.MoveRoleIcons then
		local icon = frame.roleIcon;
		if not icon then
			return;
		end

		local offset = icon:GetWidth() / 4;

		if KallyeRaidFramesOptions.MoveRoleIcons then
			icon:ClearAllPoints();
			icon:SetPoint("TOPLEFT", -offset, offset);
		end

		local role = UnitGroupRolesAssigned(frame.unit);
		if KallyeRaidFramesOptions.HideDamageIcons and role == "DAMAGER" then
			icon:Hide();
		end
	end
end

--[[
! Manage buffs
Scale buffs / debuffs
Max buffs to display (max 3!)
]]
function KRF_ManageBuffs (frame,numbuffs)
	for i=1, #frame.buffFrames do
		frame.buffFrames[i]:SetScale(KallyeRaidFramesOptions.BuffsScale);
	end

	for i=1, #frame.debuffFrames do
		frame.debuffFrames[i]:SetScale(KallyeRaidFramesOptions.DebuffsScale);
	end

	if KallyeRaidFramesOptions.MaxBuffs > 0 then
		frame.maxBuffs = KallyeRaidFramesOptions.MaxBuffs;
	end
end


--[[
! Manage names (partyframes & nameplates)
- Hide realm
- Change name color, according to class
- PartyFrames: reposition name
]]
function KRF_UpdateName(frame)
	KRF_UpdateNameColor(frame);
	if not frame:IsForbidden() then
		-- https://eu.forums.blizzard.com/en/wow/t/improving-default-blizzardui/2890

		local UnitIsPlayerControlled = UnitIsPlayer(frame.displayedUnit)
		if UnitIsPlayerControlled then
			local name = frame.name;

			if KallyeRaidFramesOptions.HideRealm then
				local playerNameServer = GetUnitName(frame.displayedUnit, true);
				local playerName = GetUnitName(frame.displayedUnit, false);
				if playerName ~= playerNameServer then
					if strsub(playerName, -3) == "(*)" then
						-- ? playerName can already contains (*) if name has unicode chars
						name:SetText(playerName);
					else
						name:SetText(playerName.." (*)");
					end
				end
			end
		end
	end
end

function KRF_UpdateNameColor(frame)
	if not frame:IsForbidden() then
		local isUnitPlayer = UnitIsPlayer(frame.displayedUnit)
		if isUnitPlayer then
			local name = frame.name;
			local isInParty = UnitInPartyOrRaid(frame.displayedUnit);
			if (not isInParty and KallyeRaidFramesOptions.FriendsClassColor_Nameplates) or (isInParty and KallyeRaidFramesOptions.FriendsClassColor) then
				local c = RAID_CLASS_COLORS[select(2,UnitClass(frame.displayedUnit))];
				if c then
					name:SetTextColor(c.r, c.g, c.b)
					name:SetShadowColor(c.r, c.g, c.b, 0.2)
				end
			else
				if name._InitialColor == nil then
					local r, g, b, a = name:GetTextColor();
					name._InitialColor = { r=r, g=g, b=b, a=a };
				else
					name:SetTextColor(name._InitialColor.r, name._InitialColor.g, name._InitialColor.b, name._InitialColor.a)
				end
			end

			if FrameIsCompact(frame) and KallyeRaidFramesOptions.MoveRoleIcons then
				name:SetPoint("TOPLEFT", 5, -5);
			end
		end
	end
end


--[[
! SoloPartyFrames
]]
local Blizzard_GetDisplayedAllyFrames = GetDisplayedAllyFrames; -- protect original behavior
function SoloRaid_GetDisplayedAllyFrames()
	-- Call original default behavior
	local daf = Blizzard_GetDisplayedAllyFrames()

	if not daf then
		return 'party'
	else
		return daf
	end
end

--[[
! SoloPartyFrames
]]
local Blizzard_CompactRaidFrameContainer_OnEvent = CompactRaidFrameContainer_OnEvent;  -- protect original behavior
function SoloRaid_CompactRaidFrameContainer_OnEvent(self, event, ...)
	-- Call original default behavior
	Blizzard_CompactRaidFrameContainer_OnEvent(self, event, ...)

	-- If all these are true, then the above call already did the TryUpdate
	local unit = ... or ""
	if ( unit == "player" or strsub(unit, 1, 4) == "raid" or strsub(unit, 1, 5) == "party" ) then
		return
	end
	-- Always update the RaidFrame
	if ( event == "UNIT_PET" ) and ( self.displayPets ) then
		CompactRaidFrameContainer_TryUpdate(self)
	end
end

function mergeRGBA(r1, v1, b1, a1, r2, v2, b2, a2, percent)
	return r1*(1-percent) + r2*percent, v1*(1-percent) + v2*percent, b1*(1-percent) + b2*percent, a1*(1-percent) + a2*percent
end
function mergeRGB(r1, v1, b1, r2, v2, b2, percent, alpha)
	return r1*(1-percent) + r2*percent, v1*(1-percent) + v2*percent, b1*(1-percent) + b2*percent, alpha
end
function mergeColors(color1, color2, percent)
	return mergeRGBA(color1.r, color1.g, color1.b, color1.a, color2.r, color2.g, color2.b, color2.a, percent)
end
function darken(r, v, b, percent, alpha)
	return r*(1-percent), v*(1-percent), b*(1-percent), alpha or 1
end
function lighten(r, v, b, percent, alpha)
	return r*(1-percent) + percent, v*(1-percent) + percent, b*(1-percent) + percent, alpha or 1
end

function GetHPSeverity(percent, revert)
	local BGColorOK=revert and KallyeRaidFramesOptions.RevertBGColorOK or KallyeRaidFramesOptions.BGColorOK
	local BGColorWarn=revert and KallyeRaidFramesOptions.RevertBGColorWarn or KallyeRaidFramesOptions.BGColorWarn
	local BGColorLow=revert and KallyeRaidFramesOptions.RevertBGColorLow or KallyeRaidFramesOptions.BGColorLow

	if percent > KallyeRaidFramesOptions.LimitOk and percent > KallyeRaidFramesOptions.LimitWarn then
		return BGColorOK.r, BGColorOK.g, BGColorOK.b, BGColorOK.a or 1
	elseif percent > KallyeRaidFramesOptions.LimitWarn then
		return mergeColors(BGColorWarn, BGColorOK, (percent - KallyeRaidFramesOptions.LimitWarn)/ (KallyeRaidFramesOptions.LimitOk - KallyeRaidFramesOptions.LimitWarn))
	elseif percent > KallyeRaidFramesOptions.LimitLow then
		return mergeColors(BGColorLow, BGColorWarn, (percent - KallyeRaidFramesOptions.LimitLow) / (KallyeRaidFramesOptions.LimitWarn - KallyeRaidFramesOptions.LimitLow))
	else
		return BGColorLow.r, BGColorLow.g, BGColorLow.b, BGColorLow.a or 1
	end
end


--[[
!  Default chat
]]
function KRF_AddMsg(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgNormal)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", YLL, msg));
	end
end
--[[
!  Warning chat
]]
function KRF_AddMsgWarn(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgWarning)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s|r", CY, msg));
	end
end
--[[
!  Error chat
]]
function KRF_AddMsgErr(msg, force)
	if (DEFAULT_CHAT_FRAME and (force or KallyeRaidFramesOptions.ShowMsgError)) then
		DEFAULT_CHAT_FRAME:AddMessage(format("%s%s: %s|r", RDL, KRF_TITLE, msg));
	end
end

function KRF_AddMsgD(msg, r, g, b)
	if (r == nil) then r = 0.5; end
	if (g == nil) then g = 0.8; end
	if (b == nil) then b = 1; end
	if (DEFAULT_CHAT_FRAME and O and O.Debug) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	end
end

function KRF_OptionsEnable(FrameObject, isEnabled)
	if isEnabled then
		FrameObject:Enable();
		FrameObject:SetAlpha(1);
	else
		FrameObject:Disable();
		FrameObject:SetAlpha(.6);
	end
end

function KRF_ApplyFuncToRaidFrames(func, ...)
	for member = 1, 40 do
		local frame = _G["CompactRaidFrame"..member];
		if frame and frame:IsVisible() then
			func(frame, ...);
		end
	end
	for member = 1, 5 do
		local frame = _G["CompactPartyFrameMember"..member];
		if frame and frame:IsVisible() then
			func(frame, ...);
		end
	end
	for raid = 1, 8 do
		if _G["CompactRaidGroup"..raid] ~= nil and _G["CompactRaidGroup"..raid]:IsVisible() then
			for member = 1, 5 do
				local frame = _G["CompactRaidGroup"..raid.."Member"..member];
				if frame == nil or not frame:IsVisible() then
					break;
				end
				func(frame, ...);
			end
		end
	end
end

function KRF_RaidFrames_ResetHealth(frame, testMode)
	local health = UnitHealth(frame.displayedUnit);
	if testMode then
		if frame._testHealthPercentage == nil then
			frame._testHealthPercentage = fastrandom(0,100)
		end

		local unitHealthMax = UnitHealthMax(frame.displayedUnit);
		frame._testHealthPercentage = (frame._testHealthPercentage == 0) and 100 or math.max(0, frame._testHealthPercentage - 5);
		health = ceil(health * frame._testHealthPercentage / 100);
		frame.statusText:SetText(format("%d%%", frame._testHealthPercentage));
	end
	frame.healthBar:SetValue(health);
	KRF_UpdateHealth(frame, health);
end

function KRF_DebugFrames(toggle)
	if toggle == true then
		_G.KRF_IsDebugFramesTimerActive = not _G.KRF_IsDebugFramesTimerActive;
		KRF_AddMsgWarn(_G.KRF_IsDebugFramesTimerActive and KRF_OPTION_DEBUG_ON_MESSAGE or KRF_OPTION_DEBUG_OFF_MESSAGE);
	end
	if _G.KRF_IsDebugFramesTimerActive then
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, true)
	else
		KRF_ApplyFuncToRaidFrames(KRF_RaidFrames_ResetHealth, false)
	end
	if _G.KRF_IsDebugFramesTimerActive then
		C_Timer.After(.5, KRF_DebugFrames)
	end
end

--[[
? Help : https://github.com/fgprodigal/BlizzardInterfaceCode_zhTW/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/CompactUnitFrame.lua
? Depuis http://www.wowinterface.com/forums/showthread.php?t=56237
? Réf Blizzard http://wowwiki.wikia.com/wiki/Widget_API

? /fstack /dump
]]