


function UIEFFECT_ON_INIT(addon, frame)

	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'UIEFFECT_CHANGE_CLIENT_SIZE');
	UIEFFECT_CHANGE_CLIENT_SIZE(frame);
	frame:ShowWindow(1);

end

function END_SNIPE()

	local frame = ui.GetFrame("uieffect");
	local child = frame:GetChild("SNIPER");

	child:StopUpdateScript("UPDATE_SNIPE_POSITION");
	child:ShowWindow(0);

end

function GET_CURRENT_SNIPE_POS()
	local frame = ui.GetFrame("uieffect");
	local child = frame:GetChild("SNIPER");
	local x = tonumber(child:GetUserValue("CURX"));
	local y = tonumber(child:GetUserValue("CURY"));
	local pos = frame:FramePosToScreenPos(x, y);
	return pos.x, pos.y;
end

function START_SNIPE(sx, sy)

	local frame = ui.GetFrame("uieffect");
	
	local centerX, centerY;
	local child = frame:GetChild("SNIPER");
	if child == nil then
		local skinSize = ui.GetSkinImageSize("snipe_center");	
		child = frame:CreateControl("groupbox", "SNIPER", 0, 0, frame:GetWidth() * 2 + skinSize.x * 4, frame:GetHeight() * 2 + skinSize.y * 4);
		child:SetSkinName("None");
		local createX = math.floor(frame:GetWidth() * 2 / skinSize.x) + 1;
		local createY = math.floor(frame:GetHeight() * 2 / skinSize.y) + 1;
		for i = 0 , createX - 1 do
			for j = 0 , createY - 1 do
				local x = i * skinSize.x;
				local y = j * skinSize.y;
				local childName = "PIC_" .. i .. "_" .. j;
				local pic = child:CreateControl("picture", childName, x, y, skinSize.x, skinSize.y);
				AUTO_CAST(pic);
				if i == math.floor(createX / 2) and j == math.floor(createY / 2) then
					local centerOffsetX = x + skinSize.x * 1.5;
					local centerOffsetY = y + skinSize.y * 0.75;
					child:SetUserValue("CENTER_X", centerOffsetX / 2);
					child:SetUserValue("CENTER_Y", centerOffsetY / 2);
					pic:SetImage("snipe_center");
					child:SetUserValue("CENTERNAME", childName);
					centerX = x;
					centerY = y;

				else
					pic:SetImage("snipe_bg");
				end
			end
		end

		local text = child:CreateControl("richtext", "POSTEXT", centerX + skinSize.x - 60, centerY + skinSize.y - 50, 300, 20);
	text:SetText("{#FF0000}1313");
	text:RunUpdateScript("AUTOCHANGETEXT");
	end

	

	child:ShowWindow(1);
	UI_PLAYFORCE(frame, "appearWithAlpha");
	
	if sx == nil then
		SNIPE_SETPOS(child, frame:GetWidth() / 2, frame:GetHeight() / 2);
	else
		local pt = frame:ScreenPosToFramePos(sx, sy);
		SNIPE_SETPOS(child, pt.x, pt.y);
	end

	child:RunUpdateScript("UPDATE_SNIPE_POSITION",  0.01, 0.0, 0, 1);
end

function AUTOCHANGETEXT(ctrl)

	local x, y = GET_CURRENT_SNIPE_POS();
	local text = "{#FF0000}" .. x .. ", " .. y;
	ctrl:SetText(text);
	return 1;
end

					

function UPDATE_SNIPE_POSITION(child, totalTime, elapsedTime)

	local x = tonumber(child:GetUserValue("CURX"));
	local y = tonumber(child:GetUserValue("CURY"));
	
	local spd = 1000 * elapsedTime;
	local changed = false;
	if 1 == keyboard.IsKeyPressed("LEFT") then
			x = x - spd;
			changed = true;
	end
	
	if 1 == keyboard.IsKeyPressed("RIGHT") then
			x = x + spd;
			changed = true;
		--			print(x);
	end

	if 1 == keyboard.IsKeyPressed("UP") then
			y = y - spd;
			changed = true;
	end
	
	if 1 == keyboard.IsKeyPressed("DOWN") then
			y = y + spd;
			changed = true;
	end
	
	if changed == true then
		SNIPE_SETPOS(child, x, y);
	end
	
	return 1;
end

function SNIPE_SETPOS(child, x, y)
	
	local frame = child:GetTopParentFrame();
	x = CLAMP(x, 0, frame:GetWidth());
	y = CLAMP(y, 0, frame:GetHeight());
	local child = frame:GetChild("SNIPER");
	child:SetUserValue("CURX", x);
	child:SetUserValue("CURY", y);
	local centerOffsetX = child:GetUserIValue("CENTER_X");
	local centerOffsetY = child:GetUserIValue("CENTER_Y");
	
	centerOffsetX = -centerOffsetX + x - frame:GetWidth() / 2;
	centerOffsetY = -centerOffsetY + y - frame:GetHeight() / 2;

	child:SetOffset( centerOffsetX, centerOffsetY);

end

