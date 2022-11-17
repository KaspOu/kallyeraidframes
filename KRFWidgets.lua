--[[
! Checkbox Widget
Simple checkbutton widget with text
]]
function KRFCheckboxWidget_OnClick(self)
	if ( self:GetChecked() ) then
		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
	else
		PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
	end
end
function KRFCheckboxWidget_OnLoad(self)
	self.type = "checkbox";

	local text = self:GetAttribute("text");
	text = _G[text] or text;

	self.Text:SetText(text);
end
function KRFCheckboxWidget_OnEnter(self)
	if (not self:IsEnabled()) then return end;
	local text = self:GetAttribute("text") or self:GetAttribute("title") or "";
	text = _G[text] or text;

	local tooltip = self:GetAttribute("tooltip") or "";
	tooltip = _G[tooltip] or tooltip;
	tooltip = tooltip ~= text and tooltip or "";

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(WH..text);
	GameTooltip:AddLine(tooltip, 1, 0.82, 0, 1);
	GameTooltip:AppendText("");
end

--[[
! Heading Widget
Using a checkbutton widget and hide checkbox
]]
function KRFHeadingWidget_OnLoad (self)
	local transparent = self:CreateTexture(nil, "BACKGROUND")
	self:SetNormalTexture(transparent);
	self:SetHighlightTexture(transparent);
	self:SetPushedTexture(transparent);

	local text = self:GetAttribute("text");
	text = _G[text] or text;

	local label = self:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	label:SetPoint("TOP")
	label:SetPoint("BOTTOM")
	label:SetJustifyH("CENTER")
	label:SetText(text);

	local left = self:CreateTexture(nil, "BACKGROUND")
	left:SetHeight(8)
	left:SetPoint("LEFT", 3, 0)
	left:SetPoint("RIGHT", label, "LEFT", -5, 0)
	left:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
	left:SetTexCoord(0.81, 0.94, 0.5, 1)

	local right = self:CreateTexture(nil, "BACKGROUND")
	right:SetHeight(8)
	right:SetPoint("RIGHT", -3, 0)
	right:SetPoint("LEFT", label, "RIGHT", 5, 0)
	right:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
	right:SetTexCoord(0.81, 0.94, 0.5, 1);
end
-- disable checked state
function KRFHeadingWidget_OnClick (self)
	self:SetChecked(false);
end

--[[
! Color Widget
]]
function KRFColorWidget_ShowColorPicker(changedCallback, self)
	ColorPickerFrame.Self = self;
	local r,g,b,o = self._RGBA.r, self._RGBA.g, self._RGBA.b, self._RGBA.a ~= nil and 1-self._RGBA.a or nil;
	ColorPickerFrame:SetColorRGB(r,g,b);
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (o ~= nil), o;
	ColorPickerFrame.previousValues = {r,g,b,o};
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
		changedCallback, changedCallback, changedCallback;
	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	ColorPickerFrame:Show();
end
function KRFColorWidget_ColorPickedCallback(restore)
	local newR, newG, newB, newO;
	if restore then
		-- The user bailed, we extract the old color from the table created by ShowColorPicker.
		newR, newG, newB, newO = unpack(restore);
	else
		-- Something changed
		newO, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
	end
	-- Update our internal storage.
	r, g, b, a = newR, newG, newB, 1-newO;
	-- And update any UI elements that use this color...
	ColorPickerFrame.Self.SetColor(ColorPickerFrame.Self, { r = r , g = g, b = b, a = a });
end

function KRFColorWidget_SetColor (self, RGBA)
	self._RGBA = RGBA or self._RGBA;
	self._colorSwatch:SetVertexColor(self._RGBA.r, self._RGBA.g, self._RGBA.b, self._RGBA.a)
end
function KRFColorWidget_GetColor(self)
	return self._RGBA;
end

function KRFColorWidget_OnLoad (self)
	self.type = "color";

	local text = self:GetAttribute("text");
	text = _G[text] or text;

	self._RGBA = { r=1, g=1, b=1, a=1}
	self.SetColor = KRFColorWidget_SetColor;
	self.GetColor = KRFColorWidget_GetColor;

	self:EnableMouse(true)

	local transparent = self:CreateTexture(nil, "BACKGROUND")
	self:SetNormalTexture(transparent)

	local colorSwatch = self:CreateTexture(nil, "OVERLAY")
	colorSwatch:SetWidth(20)
	colorSwatch:SetHeight(20)
	colorSwatch:SetTexture(130939) -- Interface\\ChatFrame\\ChatFrameColorSwatch
	colorSwatch:SetPoint("LEFT", 4, 0)
	self._colorSwatch = colorSwatch

	local texture = self:CreateTexture(nil, "BACKGROUND")
	colorSwatch.background = texture
	texture:SetWidth(16)
	texture:SetHeight(16)
	texture:SetColorTexture(1, 1, 1)
	texture:SetPoint("CENTER", colorSwatch)
	texture:Show()

	local checkers = self:CreateTexture(nil, "BACKGROUND")
	colorSwatch.checkers = checkers
	checkers:SetWidth(14)
	checkers:SetHeight(14)
	checkers:SetTexture(188523) -- Tileset\\Generic\\Checkers
	checkers:SetTexCoord(.25, 0, 0.5, .25)
	checkers:SetDesaturated(true)
	checkers:SetVertexColor(1, 1, 1, 0.75)
	checkers:SetPoint("CENTER", colorSwatch)
	checkers:Show()

	self.Text:SetText(text);
end
function KRFColorWidget_OnClick(self)
	PlaySound(852) -- SOUNDKIT.IG_MAINMENU_OPTION
	KRFColorWidget_ShowColorPicker(KRFColorWidget_ColorPickedCallback, self);
end
function KRFColorWidget_OnEnter(self)
	if (not self:IsEnabled()) then return end;
	local text = self:GetAttribute("text") or self:GetAttribute("title") or "";
	text = _G[text] or text;
	local tooltip = self:GetAttribute("tooltip") or "";
	tooltip = _G[tooltip] or tooltip;
	tooltip = tooltip ~= text and tooltip or "";

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(WH..text);
	GameTooltip:AddLine(tooltip, 1, 0.82, 0, 1);
	GameTooltip:AppendText("");
end

--[[
! Slider Widget
]]
function KRFSliderWidget_SetValue (self, value)
	self:SetDisplayValue(value);
	self._Value = value;
end
function KRFSliderWidget_GetValue(self)
	return self._Value;
end
function KRFSliderWidget_OnLoad (self)
	self.type = CONTROLTYPE_SLIDER;

	local wowtocversion  = select(4, GetBuildInfo());
	if (wowtocversion > 90000) then
		BackdropTemplateMixin.OnBackdropLoaded(self);
	end

	local name = self:GetName();
	local text = self:GetAttribute("text");
	text = _G[text] or text;

	self._Value = 0;

	self.tooltipText = tooltip;
	self.name = text;
	self.SetDisplayValue = self.SetValue;
	self.SetValue = KRFSliderWidget_SetValue
	self.GetCurrentValue = KRFSliderWidget_GetValue
	_G[name.."Text"]:SetFontObject("OptionsFontSmall");
	_G[name.."Text"]:SetText(text);
	_G[name.."High"]:Hide();

	self.Label = _G[name.."Low"];
	self.Label:ClearAllPoints();
	self.Label:SetPoint("LEFT", self, "RIGHT", 3.5, 1);
end
function KRFSliderWidget_OnValueChanged(self, value)
	local name = self:GetName();
	local format = self:GetAttribute("format") or nil;
	format = _G[format] or format;
	self.Label = _G[name.."Low"];
	local formatRatio = self:GetAttribute("formatRatio") or 1;
	if format ~= nil then
		self.Label:SetFormattedText(format, value * tonumber(formatRatio));
	else
		self.Label:SetText(value * tonumber(formatRatio));
	end
	self:SetValue(value);
end
function KRFSliderWidget_OnEnter(self)
	if (not self:IsEnabled()) then return end;
	local text = self:GetAttribute("text") or self:GetAttribute("title") or "";
	text = _G[text] or text;

	local tooltip = self:GetAttribute("tooltip") or "";
	tooltip = _G[tooltip] or tooltip;
	tooltip = tooltip ~= text and tooltip or "";

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(WH..text);
	GameTooltip:AddLine(tooltip, 1, 0.82, 0, 1);
	GameTooltip:AppendText("");
end