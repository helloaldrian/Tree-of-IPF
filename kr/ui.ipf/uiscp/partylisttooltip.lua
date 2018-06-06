-- partylisttooltip.lua

function UPDATE_PARTYLIST_TOOLTIP(tooltipframe, strarg, numarg1, numarg2, userData)
	local partyListInfo = tolua.cast(userData, "PARTYLIST_INFO");
	
end

function PARTY_INFO_UPDATE_TOOLTIP(tooltipframe, strarg, numarg1, numarg2, userData)
	
	local name = GET_CHILD_RECURSIVELY(tooltipframe,"partyname")
	local nearPartyList = session.party.GetNearPartyList();
	local eachpartyinfo = nearPartyList:Element(numarg1).partyInfo
	local eachpartymemberlist = nearPartyList:Element(numarg1):GetMemberList()

	local ppartyobj = eachpartyinfo:GetObject();

	if ppartyobj == nil then
		return;
	end

	local partyObj = GetIES(ppartyobj);

	if partyObj == nil then
		return;
	end

		
	-- ��Ƽ �̸�
	local name = GET_CHILD_RECURSIVELY(tooltipframe,'partyname')
	name:SetText(eachpartyinfo.info.name)
	
	local memo = GET_CHILD_RECURSIVELY(tooltipframe,'partymemo')
	memo:SetText(partyObj["Note"])

	local meminfogbox = GET_CHILD_RECURSIVELY(tooltipframe,'meminfo')

	DESTROY_CHILD_BYNAME(meminfogbox, 'eachmember_');
	for i = 0 , eachpartymemberlist:Count() - 1 do

		local ctrlheight = ui.GetControlSetAttribute('nearparty_each_member_info', 'height') 
		local set = meminfogbox:CreateOrGetControlSet('nearparty_each_member_info', 'eachmember_'..i, 20, 5 + ctrlheight*i);
		
		local eachpartymember = eachpartymemberlist:Element(i)
		local classicon = GET_CHILD_RECURSIVELY(set,'classicon')

		local meminfotext = GET_CHILD_RECURSIVELY(set,'meminfotext')
		local outmeminfotext = GET_CHILD_RECURSIVELY(set,'outmeminfotext')
		
		if geMapTable.GetMapName(eachpartymember:GetMapID()) ~= 'None' then		
			classicon:ShowWindow(1)
			meminfotext:ShowWindow(1)
			outmeminfotext:ShowWindow(0)
			meminfotext:SetTextByKey('name',eachpartymember:GetName())	 
			meminfotext:SetTextByKey('lv',eachpartymember:GetLevel())

			local jobclass = GetClassByType("Job",eachpartymember:GetIconInfo().job)
			meminfotext:SetTextByKey('job',jobclass.Name)

			if jobclass.CtrlType == "Warrior" then
				classicon:SetImage("partylist_swordman")
			elseif jobclass.CtrlType == "Wizard" then
				classicon:SetImage("partylist_wizard")
			elseif jobclass.CtrlType == "Archer" then
				classicon:SetImage("partylist_archer")
			else
				classicon:SetImage("partylist_cleric")
			end

		else
			classicon:ShowWindow(0)
			meminfotext:ShowWindow(0)
			outmeminfotext:ShowWindow(1)
			outmeminfotext:SetTextByKey('name',eachpartymember:GetName())
		end

	end
		
	
	local questText = GET_CHILD_RECURSIVELY(tooltipframe,'questTextval')
	local expText = GET_CHILD_RECURSIVELY(tooltipframe,'expTextval')
	local itemText = GET_CHILD_RECURSIVELY(tooltipframe,'itemTextval')

	if partyObj["IsQuestShare"] == 0 then
		questText:SetText(ScpArgMsg("PartyOptQuest_NonShare"))
	else
		questText:SetText(ScpArgMsg("PartyOptQuest_Share"))
	end

	if partyObj["ExpGainType"] == 0 then
		expText:SetText(ScpArgMsg("PartyOptExp_Each"))
	elseif partyObj["ExpGainType"] == 1 then
		expText:SetText(ScpArgMsg("PartyOptExp_Equal"))
	else
		expText:SetText(ScpArgMsg("PartyOptExp_Lv"))
	end

	if partyObj["ItemRouting"] == 0 then
		itemText:SetText(ScpArgMsg("PartyOptItem_Each"))
	elseif partyObj["ItemRouting"] == 1 then
		itemText:SetText(ScpArgMsg("PartyOptItem_Seq"))
	else
		itemText:SetText(ScpArgMsg("PartyOptItem_Ran"))
	end
	
	tooltipframe:Resize(tooltipframe:GetOriginalWidth(), 210 + (eachpartymemberlist:Count() * 30) )

	tooltipframe:Invalidate()

	
	
end