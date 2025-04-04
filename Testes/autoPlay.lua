function placeUnits()
	while getgenv().placeUnitsGG == true do
		local waypointsFolder = workspace.Map.Waypoints
		local waypoints = {}

		for _, child in ipairs(waypointsFolder:GetChildren()) do
			table.insert(waypoints, child)
		end

		function getWaypointByPercentage(waypoints, percentage)
			local n = #waypoints
			if n == 0 then
				return nil
			end
			local segment = 100 / n
			local index = percentage >= 100 and n or math.floor(percentage / segment) + 1
			return waypoints[index]
		end

		function getPositionsAroundPoint(center, radius, nPositions)
			local positions = {}
			local angleStep = (2 * math.pi) / nPositions
			for i = 0, nPositions - 1 do
				local angle = i * angleStep
				local x = center.X + radius * math.cos(angle)
				local z = center.Z + radius * math.sin(angle)
				local pos = Vector3.new(x, center.Y, z)
				table.insert(positions, pos)
			end
			return positions
		end

		function findClosestAirPart(point)
			local airFolder = workspace.Map.Map.Air
			local closestAir, minDist = nil, math.huge
			for _, part in ipairs(airFolder:GetChildren()) do
				if part:IsA("BasePart") then
					local dist = (part.Position - point).Magnitude
					if dist < minDist then
						minDist = dist
						closestAir = part
					end
				end
			end
			return closestAir
		end

		function placeEquippedUnits(positions, equippedUnits)
			local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlaceTower")

			for i, unitInfo in ipairs(equippedUnits) do
				local pos = positions[i]
				if pos and unitInfo.UnitName then
					local cf = CFrame.new(pos)
					remote:FireServer(unitInfo.UnitName, cf)
				end
			end
		end

		local selectedPercentage = 50
		local selectedWaypoint = getWaypointByPercentage(waypoints, selectedPercentage)

		if selectedWaypoint then
			local player = game.Players.LocalPlayer
			local retorno = game:GetService("ReplicatedStorage")
				:WaitForChild("Remotes")
				:WaitForChild("GetPlayerData")
				:InvokeServer(player)

			if typeof(retorno) == "table" then
				for key, value in pairs(retorno) do
					print("  ", key, "=", value)
				end

				local unitData = retorno["UnitData"]
				if typeof(unitData) == "table" then
					local equippedUnits = {}
					for _, unitInfo in pairs(unitData) do
						if unitInfo.Equipped == true then
							table.insert(equippedUnits, unitInfo)
						end
					end

					if #equippedUnits > 0 then
						local groundRadius = 5
						local groundPositions =
							getPositionsAroundPoint(selectedWaypoint.Position, groundRadius, #equippedUnits)
						placeEquippedUnits(groundPositions, equippedUnits)

						local closestAirPart = findClosestAirPart(selectedWaypoint.Position)
						if closestAirPart then
							local airRadius = 5
							local airPositions =
								getPositionsAroundPoint(closestAirPart.Position, airRadius, #equippedUnits)
							placeEquippedUnits(airPositions, equippedUnits)
						end
					end
				end
			end
		end
	end
end
