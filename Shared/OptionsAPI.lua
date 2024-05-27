local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end

-- SHARED API options management (default, load, save)
function ns.SetDefaultOptions(DefaultOptions, reset)
	if reset or _G[ns.OPTIONS_NAME] == nil then
		_G[ns.OPTIONS_NAME] = CopyTable(DefaultOptions)
	else
        if ns.RemoveOldOptions then
            ns.RemoveOldOptions(_G[ns.OPTIONS_NAME])
        end
		foreach(DefaultOptions,
			function (optionName, defaultValue)
				if _G[ns.OPTIONS_NAME][optionName] == nil then
					_G[ns.OPTIONS_NAME][optionName] = defaultValue;
				end
			end
		);
	end
end

function ns.FindControl(ControlName)
	if ns.optionsFrame[ControlName] then
		return ns.optionsFrame[ControlName];
	else
		local i = 1
		while(ns.optionsFrame["Options"..i])
		do
			if (ns.optionsFrame["Options"..i][ControlName]) then
				return ns.optionsFrame["Options"..i][ControlName];
			end
			i=i+1;
		end
	end
end

--- Save the current options state, automatically matching the UI controls
--- @param defaultOptions table Table containing the default options
--- @param ComputedReloadOptions function? Function that computes and returns the options (requiring reload) state as a string
function ns.SaveOptions(defaultOptions, ComputedReloadOptions)
    local PreviousOptionsWReload = ComputedReloadOptions and ComputedReloadOptions() or nil;

    -- Auto detect options controls and save them
    foreach(defaultOptions,
        function (optionName, defaultValue)
            local optionsObject = ns.FindControl(optionName);
            if (optionsObject ~= nil) then
                local control = optionsObject;
                local previousValue = _G[ns.OPTIONS_NAME][optionName] or defaultValue;
                local value = nil;

                if control.type == "color" then
                    value = control:GetColor();
                elseif control.type == "dropdown" then
                    value = control:GetValue();
                elseif control.type == CONTROLTYPE_SLIDER then
                    value = control:GetValue();
                elseif type(previousValue) == "boolean" then
                    value = control:GetChecked();
                end
                if value == nil then
                    ns.AddMsgErr(format("Incorrect field value, loading default value for %s...", optionName));
                    value = defaultValue;
                end;
                _G[ns.OPTIONS_NAME][optionName] = value;
            end
        end
    );

    if ComputedReloadOptions and ComputedReloadOptions() ~= PreviousOptionsWReload then
        ns.AddMsgWarn(l.OPTION_RELOAD_REQUIRED, true);
    end
    
    -- OnSave: Modules
    foreach(ns.MODULES,
        function(_, module)
            module:OnSaveOptions(_G[ns.OPTIONS_NAME]);
        end
    );
    if ns.optionsFrame ~= nil and ns.optionsFrame.HandleVis ~= nil then
        ns.optionsFrame:Hide();
    end
end

function ns.RefreshOptions(defaultOptions)
    if ns.optionsFrame ~= nil then
        ns.optionsFrame:Show();
        ns.optionsFrame.HandleVis = true;
    end
    -- Auto detect options controls and load them
    foreach(defaultOptions,
        function (optionName, defaultValue)
            local optionsObject = ns.FindControl(optionName);
            if (optionsObject ~= nil) then
                local control = optionsObject;
                local value = _G[ns.OPTIONS_NAME][optionName];
                if value == nil then
                    value = defaultValue;
                    ns.AddMsgErr(format("Option not found ("..l.YLD.."%s|r), loading default value...", optionName));
                end;

                if control.type == "color" then
                    control:SetColor(value);
                elseif control.type == "dropdown" then
                    control:SetValue(value);
                elseif control.type == CONTROLTYPE_SLIDER then
                    control:SetValue(value);
                elseif type(value) == "boolean" then
                    control:SetChecked(value);
                else
                    ns.AddMsgDebug(format("Type non prevu pour %s - %s, type de valeur: %s", optionName, control.type or "unknown", type(value)));
                end
            end
        end
    );
end


-- SHARED UI
function ns.OptionsEnable(FrameObject, isEnabled, disabledAlpha)
	if isEnabled then
		FrameObject:Enable();
		FrameObject:SetAlpha(1);
	else
		FrameObject:Disable();
		FrameObject:SetAlpha(disabledAlpha or .6);
	end
end
function ns.OptionsSetShownAndEnable(FrameObject, isShowned, isEnabled)
	FrameObject:SetShown(isShowned);
	if (isShowned) then
		ns.OptionsEnable(FrameObject, isEnabled);
	end
end