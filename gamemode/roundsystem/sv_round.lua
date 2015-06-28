include("../shared.lua")
include("sh_round.lua")

-- create network strings for round state changes
util.AddNetworkString("ROUND_STATE")
-- send this each time round state changes so that the player can update themselves

function ROUND:RoundSwitch( r ) -- this can be used to switch or restart states
	local old = ROUND_CURRENT
	local new = r

	if (not ROUND_TABLE[new]) then return end

	if (ROUND_TABLE[old]) then
		ROUND_TABLE[old].OnExit()
	end
	ROUND_TABLE[new].OnEnter()

	ROUND_CURRENT = new

	if SERVER then
		net.Start("ROUND_STATE")
		net.WriteInt( new, 16 )
		net.Broadcast()
	end
end

--commands
concommand.Add("round_switch", function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		local r = tonumber(args[1])
		ROUND:RoundSwitch( r )	
	end
end)