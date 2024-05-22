-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------


KRF_VERS_TITLE    = format("%s %s", KRF_TITLE, KRF_VERSION);

-- Whats new info
KRF_WHATSNEW = " What's new:\n"
    .."- Added enemy colored nameplates option.\n"
    .."- UI enhancements (info button, gradient background).\n"
    .."- |cffff1111Wow Classic|r & |cffc16600Cata|r versions!\n"
  ;
KRF_WHATSNEW = KRF_Globals.YL..KRF_VERS_TITLE.." -"..KRF_Globals.YLL..KRF_WHATSNEW;

KRF_SUBTITLE      = "Raid frames support";
KRF_DESC          = "Enhance raid frames and nameplates on friendly units\n\n"
.." - Highlight raid frames background on low health\n\n"
.." - Inverted frames will use your choice of colors\n\n"
.." - Transparency when unit out of range";
KRF_OPTIONS_TITLE = format("%s - Options", KRF_VERS_TITLE);

-- Messages
KRF_MSG_LOADED         = format("%s loaded", KRF_VERS_TITLE);
KRF_MSG_SDB            = "Kallye options frame";

KRF_INIT_FAILED = format("%s not initialized correctly!", KRF_VERS_TITLE);


KRF_OPTION_RAID_HEADER = "Party / Raid";
KRF_OPTION_HIGHLIGHTLOWHP = "Highlight players HP loss (dynamic colors)";
KRF_OPTION_REVERTBAR = KRF_Globals.YL.."Revert|r HP bars (less life = bigger bar !) "..KRF_Globals.YL.."*";
KRF_OPTION_HEALTH_LOW = "Almost dead!";
KRF_OPTION_HEALTH_LOW_TOOLTIP = "Low health color applied "..KRF_Globals.YLL.."BELOW|r this limit\n\n"
  .."i.e.: Red below 25%";
KRF_OPTION_HEALTH_WARN = "Warning";
KRF_OPTION_HEALTH_WARN_TOOLTIP = "Warn health color applied "..KRF_Globals.YLL.."AT|r this limit exactly\n\n"
  .."i.e.: Yellow at 50%";
KRF_OPTION_HEALTH_OK = "Health ok";
KRF_OPTION_HEALTH_OK_TOOLTIP = "OK health color applied "..KRF_Globals.YLL.."AFTER|r this limit\n\n"
  .."i.e.: Green after 75%";
KRF_OPTION_MOVEROLEICONS = "Adjust role icons on top left";
KRF_OPTION_HIDEDAMAGEICONS = "Hide 'dps' role icon";
KRF_OPTION_HIDEREALM = "Hide players realm";
KRF_OPTION_HIDEREALM_TOOLTIP = "Realm names will be masked, "..KRF_Globals.YLL.."Illidan - Varimathras|r will become "..KRF_Globals.YLL.."Illidan (*)|r";
KRF_OPTION_ICONONDEATH = "Add "..KRF_Globals.RT8.." to dead players names";
KRF_OPTION_FRIENDSCLASSCOLOR = "Names colored by class";
KRF_OPTION_FRIENDSCLASSCOLOR_TOOLTIP = "Enhance player color according to their class (party/raid frames)";
KRF_OPTION_BLIZZARDFRIENDSCLASSCOLOR = "Blizzard: "..KRF_OPTION_FRIENDSCLASSCOLOR;
KRF_OPTION_BLIZZARDFRIENDSCLASSCOLOR_TOOLTIP = "Base raid class colors option";
KRF_OPTION_NOTINRANGE = "Transparency when out of range";
KRF_OPTION_NOTINRANGE_TOOLTIP = KRF_Globals.CY.."Wow default: 55%";
KRF_OPTION_NOTINCOMBAT = "Raid transparency out of combat";
KRF_OPTION_NOTINCOMBAT_TOOLTIP = KRF_Globals.CY.."Wow default: 100%";
KRF_OPTION_SOLORAID = KRF_Globals.CY.."Display raid frames while solo "..KRF_Globals.YL.."*";
KRF_OPTION_SOLORAID_TOOLTIP = "Always display party/raid frames";

KRF_OPTION_EDITMODE_PARTY = "#";
KRF_OPTION_EDITMODE_PARTY_NOTE = "#";
KRF_OPTION_EDITMODE_PARTY_TOOLTIP = "#";
KRF_OPTION_DEBUG_ON = "! Test raid frames !";
KRF_OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames, reclick to stop it!";
KRF_OPTION_DEBUG_OFF = "! STOP Test !";
KRF_OPTION_DEBUG_OFF_MESSAGE = "Test stopped, have fun!";

KRF_OPTION_BUFFS_HEADER = "Buffs / Debuffs";
KRF_OPTION_BUFFSSCALE = "Buffs relative size"..KRF_Globals.YL.."*";
KRF_OPTION_BUFFSSCALE_TOOLTIP = KRF_Globals.CY.."Set to 1 if you experience some addon conflict";
KRF_OPTION_DEBUFFSSCALE = "Debuffs relative size"..KRF_Globals.YL.."*";
KRF_OPTION_DEBUFFSSCALE_TOOLTIP = KRF_Globals.CY.."Set to 1 if you experience some addon conflict";
KRF_OPTION_MAXBUFFS = "Max buffs";
KRF_OPTION_MAXBUFFS_TOOLTIP = "Max buffs to display";
KRF_OPTION_MAXBUFFS_FORMAT = "%d |4buff:buffs";

KRF_OPTION_OTHERS_HEADER = "Nameplates";
KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES = "Players nameplates colored by class (outside instances)";
KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES_TOOLTIP = "Change player nameplate (on the head) color according to class (doesn't work inside instances)";
KRF_OPTION_ENEMIESCLASSCOLOR_NAMEPLATES = "Activate for enemies nameplates";
KRF_OPTION_ENEMIESCLASSCOLOR_NAMEPLATES_TOOLTIP = KRF_OPTION_FRIENDSCLASSCOLOR_NAMEPLATES_TOOLTIP;

KRF_OPTION_RESET_OPTIONS = "Reset options";
KRF_OPTION_RELOAD_REQUIRED = "Some changes require reloading (write: "..KRF_Globals.YL.."/reload|r )";
KRF_OPTIONS_ASTERIX = KRF_Globals.YL.."*|r"..KRF_Globals.WH..": Options requiring reloading";

KRF_OPTION_SHOWMSGNORMAL = KRF_Globals.GYL.."Display messages";
KRF_OPTION_SHOWMSGWARNING = KRF_Globals.GYL.."Display warnings";
KRF_OPTION_SHOWMSGERR = KRF_Globals.GYL.."Display errors";
KRF_OPTION_WHATSNEW = "What's new";

-- Edit Mode - Since DragonFlight (10)
if (EditModeManagerFrame.UseRaidStylePartyFrames) then
  if (not EditModeManagerFrame:UseRaidStylePartyFrames()) then
    KRF_OPTION_SOLORAID_TOOLTIP = "I suggest you to activate option "..KRF_Globals.YLL..HUD_EDIT_MODE_SETTING_UNIT_FRAME_RAID_STYLE_PARTY_FRAMES.."|r ("..HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL..")";
    KRF_DESC = KRF_DESC.."\n\n - "..KRF_OPTION_SOLORAID_TOOLTIP;
  end
  KRF_OPTION_EDITMODE_PARTY = HUD_EDIT_MODE_MENU..": "..HUD_EDIT_MODE_PARTY_FRAMES_LABEL;
  KRF_OPTION_EDITMODE_PARTY_NOTE = "Note: Use "..KRF_Globals.YL.."/reload|r after "..HUD_EDIT_MODE_MENU..", to avoid possibles errors";
  KRF_OPTION_EDITMODE_PARTY_TOOLTIP = "Enter "..KRF_Globals.YL..HUD_EDIT_MODE_MENU.."|r, and open "..KRF_Globals.YL..HUD_EDIT_MODE_PARTY_FRAMES_LABEL.."|r options window.\n\n"..KRF_Globals.CY..KRF_OPTION_EDITMODE_PARTY_NOTE.."|r";
  KRF_OPTION_DEBUG_ON_MESSAGE = "Testing party / raid frames (you can test in "..HUD_EDIT_MODE_MENU..")\n"
                    .."Reclick to stop it!";
end


-- end
