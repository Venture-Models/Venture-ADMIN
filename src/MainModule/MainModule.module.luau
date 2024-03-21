-- // Venture: ADMIN Made By: Sectly (@27st3) And Various Other Creators, Developers And Contributors, Please See !credits | Copyright © Venture Models 2024, All Rights Reserved
-- // This Is The Main Module Its The Core Of Venture: ADMIN
-- // @Purpose Main Module

--[[ -- // Venture: ADMIN | Version: 0.0.0

██╗   ██╗███████╗███╗   ██╗████████╗██╗   ██╗██████╗ ███████╗        █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗
██║   ██║██╔════╝████╗  ██║╚══██╔══╝██║   ██║██╔══██╗██╔════╝██╗    ██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║
██║   ██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║██████╔╝█████╗  ╚═╝    ███████║██║  ██║██╔████╔██║██║██╔██╗ ██║
╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ██║   ██║██╔══██╗██╔══╝  ██╗    ██╔══██║██║  ██║██║╚██╔╝██║██║██║╚██╗██║
 ╚████╔╝ ███████╗██║ ╚████║   ██║   ╚██████╔╝██║  ██║███████╗╚═╝    ██║  ██║██████╔╝██║ ╚═╝ ██║██║██║ ╚████║
  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝       ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝
        


	-- // Venture: ADMIN | Version: 0.0.0

    -- // Made By:
            - Sectly (@27st3) | Programmer
            - And Various Other Creators, Developers And Contributors, Please See !credits

    -- // Instructions: (Documentation: https://venture.sectly.online/)
            - Step 1: Put This Script In ServerScriptService.
            - Step 2: Edit Configuration Below.
            - Step 3: Done!

    -- // Update Log:

            - 22-02-2024: (0.0.0) [DD-MM-YYYY]
                * Updated Configuration!
                * New UI!

    -- // Notes:
            - Please Ensure That The Datastore Key Has Been Changed Before Using The Admin System.
            - It May Not Function Correctly In Roblox Studio.

    -- // PS: Thank You For Using Venture: ADMIN - Sectly (@27st3)
--]]

--[[ -- // Venture: ADMIN Main Module
     Venture: ADMIN's Main Module, 
     Please Use The Loader Instead: <LOADER_LINK>
--]]

local VentureAdmin = {
	AdminVersion = "0.0.0",

	Configuration = {
		Core = {
			Prefix = ";",
			PublicPrefix = "!",
			DatastoreKey = "CHANGE_ME_PLEASE!",
			MaxLogs = 1024,
		},

		Roles = {
			[0] = "Guest",
			[10] = "Moderator",
			[50] = "Head Moderator",
			[100] = "Administrator",
			[150] = "Head Administrator",
			[250] = "Ownership",
			[255] = "Creator",
		},

		Players = {
			[172896708] = "Creator",
			["vycVascense"] = "Ownership",
		},

		Groups = {
			[0000] = {
				MinRank = 50,
				MaxRank = 200,
				Role = "Head Administrator",
			},
		},

		Command = {
			["kick"] = {
				Enabled = true,
				MinPermissionLevel = 10,
				MaxPermissionLevel = 255,
				OnExecuteCallback = function(Player, Args, API, Options)
				end,
			},
		},

		Messages = {
			Ban = "[Banned]\n\nYou Have Been Banned From The Game.",
			ServerBan = "[Server Banned]\n\nYou Have Been Banned From The Server.",
			TemporaryBan = "[Temporary Banned]\n\nYou Have Been Temporary Banned From The Game.",
			Kick = "[Kicked]\n\nYou Have Been Kicked From The Game.",
			Warn = "You Have Been Warned.",
			Shutdown = "[Server Shutdown]\n\nThis Server Is Shutting Down..\nTry Joining A Different Server!",
			Announcement = "Announcement",
			ServerLock = "This Server Has Been Locked!",
			ServerUnlock = "This Server Has Been Unlocked!",
		},

		Tools = {
			Location = game:GetService("ServerStorage"),
			Recursive = true,
		},

		Donor = {
			DonorCommandsEnabled = true,
			DonorAvatarCustomizationEnabled = true,
			DonorPetsEnabled = true,
			DonorMinigames = true,
		},

		HTTP = {
			DashboardEnabled = false,
			APIKey = "",
			BanList = "https://venture.sectly.online/example/bans.json",
			RoleList = "https://venture.sectly.online/example/roles.json",
			Logs = "https://venture.sectly.online/example/log.php",
			LogTopMessage = "@here",
		},

		Debug = {
			CreatorDebugging = true,
			Verbosity = 1,
			GlobalCacheDefaultTTL = 3600,
			GlobalCacheExtendedTTL = 86400,
		},
	},

	Verbosity = 1,

	LocalCache = {
		Logs = {},
	},

	GlobalCacheDefault = game:GetService("MemoryStoreService"):GetSortedMap("VentureAdmin_GlobalCacheDefault"),
	GlobalCacheExtended = game:GetService("MemoryStoreService"):GetSortedMap("VentureAdmin_GlobalCacheExtended"),
	GlobalCache = {},
}

function VentureAdmin.GlobalCache:SetAsync(IsExtended, Key, Value)
	if IsExtended then
		VentureAdmin.GlobalCacheExtended:SetAsync(tostring(Key), Value, VentureAdmin.Configuration.Debug.GlobalCacheExtendedTTL)
	else
		VentureAdmin.GlobalCacheDefault:SetAsync(tostring(Key), Value, VentureAdmin.Configuration.Debug.GlobalCacheDefaultTTL)
	end

	return nil
end

function VentureAdmin.GlobalCache:GetAsync(IsExtended, Key, Value)
	local Data = nil

	if IsExtended then
		Data = VentureAdmin.GlobalCacheExtended:GetAsync(tostring(Key))
	else
		Data = VentureAdmin.GlobalCacheDefault:GetAsync(tostring(Key))
	end

	return Data or nil
end

function VentureAdmin.GlobalCache:RemoveAsync(IsExtended, Key, Value)
	if IsExtended then
		VentureAdmin.GlobalCacheExtended:RemoveAsync(tostring(Key))
	else
		VentureAdmin.GlobalCacheDefault:RemoveAsync(tostring(Key))
	end

	return nil
end

local function CapitalizeString(String)
	return string.sub(string.gsub(" "..String, "%W%l", string.upper), 2)
end

function VentureAdmin:Log(Verbosity, LogArgs, LogTypes)
	local Args = ""

	for Num, Log in pairs(LogArgs) do
		if Log and typeof(Log) then
			if LogTypes then
				if typeof(Log) == "table" then
					Log = CapitalizeString(tostring(typeof(Log)))..": "..game:GetService("HttpService"):JSONEncode(Log)
				else
					Log = CapitalizeString(tostring(typeof(Log)))..": "..tostring(Log)
				end
			else
				if typeof(Log) == "table" then
					Log = game:GetService("HttpService"):JSONEncode(Log)
				else
					Log = tostring(Log)
				end
			end

			if Args == "" then
				Args = tostring(Log)
			else
				Args = Args.." "..tostring(Log)
			end
		end
	end

	VentureAdmin.Verbosity = VentureAdmin.Verbosity or 1

	local Id = (#VentureAdmin.LocalCache.Logs + 1) or 1

	table.insert(VentureAdmin.LocalCache.Logs, {
		Verbosity = Verbosity,
		LogArgs = LogArgs,
		LogTypes = LogTypes,
		Args = Args,
		Id = Id,
	})

	if Verbosity >= 0 and Verbosity <= 1 then
		table.insert(VentureAdmin.GlobalCache.Logs, {
			Verbosity = Verbosity,
			LogArgs = LogArgs,
			LogTypes = LogTypes,
			Args = Args,
			Id = Id,
		})
	end

	if VentureAdmin.Configuration.Debug.Verbosity == 0 and Verbosity == 0 then
		error("[Venture: ADMIN] {FATAL ERROR} (Id: "..tostring(Id).."), Error: "..tostring(Args))
	elseif VentureAdmin.Configuration.Debug.Verbosity == 1 and Verbosity == 1 then
		warn("[Venture: ADMIN] {ERROR} (Id: "..tostring(Id).."), Error: "..tostring(Args))
	elseif VentureAdmin.Configuration.Debug.Verbosity == 2 and Verbosity == 2 then
		warn("[Venture: ADMIN] {WARNING} (Id: "..tostring(Id).."), Warning: "..tostring(Args))
	elseif VentureAdmin.Configuration.Debug.Verbosity >= 3 and Verbosity >= 3 then
		print("[Venture: ADMIN] {LOG} (Id: "..tostring(Id).."), Log: "..tostring(Args))
	end
end

function VentureAdmin:VentureAdmin(Script, Configuration, LoaderVersion)
	local Works, Failed = pcall(function()
        -- // Setup:

		Script = Script or game:GetService("ServerScriptService"):FindFirstChild("VentureAdmin")
		Configuration = Configuration or VentureAdmin.Configuration
		LoaderVersion = LoaderVersion or VentureAdmin.AdminVersion

		VentureAdmin.Verbosity = Configuration.Debug.Verbosity or (VentureAdmin.Configuration.Debug.Verbosity or (VentureAdmin.Verbosity or 1))

		if not Script or not Configuration or not LoaderVersion then
			VentureAdmin:Log(1, { "[Core]", "Required Loader Arguments Missing, Please Check Or Reinsert The Loader Script!" }, false)

			return nil
		end

		VentureAdmin:Log(3, { "[Configuration]", "Processing Configuration..." }, false)

		for Component, Setting in pairs(VentureAdmin.Configuration) do
			for Key, Value in pairs(Setting) do
				local Works, Failed = pcall(function()
					if Configuration[Component][Key] and typeof(VentureAdmin.Configuration[Component][Key]) == typeof(Configuration[Component][Key]) then
						if typeof(VentureAdmin.Configuration[Component][Key]) == "table" or typeof(Configuration[Component][Key]) == "table" then
							VentureAdmin.Configuration[Component][Key] = Configuration[Component][Key] or VentureAdmin.Configuration[Component][Key]

							VentureAdmin:Log(3, { "[Configuration]", "Changed Table:", VentureAdmin.Configuration[Component][Key], "On Key:", tostring(Key), "In:", tostring(Component) }, false)
						else
							if VentureAdmin.Configuration[Component][Key] ~= Configuration[Component][Key] then
								VentureAdmin.Configuration[Component][Key] = Configuration[Component][Key] or VentureAdmin.Configuration[Component][Key]

								VentureAdmin:Log(3, { "[Configuration]", "Changed Value:", VentureAdmin.Configuration[Component][Key], "On Key:", tostring(Key), "In:", tostring(Component) }, false)
							end
						end
					end
				end)

				if not Works or Failed then
					VentureAdmin:Log(1, Failed)
				end
			end
		end

		VentureAdmin.Verbosity = Configuration.Debug.Verbosity or (VentureAdmin.Configuration.Debug.Verbosity or (VentureAdmin.Verbosity or 1))

        -- // Core:

		function VentureAdmin:ExecuteCommand(Player, Command, Args)
			local Works, Failed = pcall(function()
				if Command and Command ~= nil and Command ~= "" and Command ~= " " then
					if Player and Player ~= nil and Command and Command ~= nil and Args and Args ~= nil then
						local Cmd = VentureAdmin.Cmds[string.lower(Command)]

						if Cmd and Cmd ~= nil then
							if VentureAdmin.API:CheckPermissions(Player) >= VentureAdmin.Options.Permissions.DefaultPermissionLevel then
								if VentureAdmin.API:CheckPermissions(Player) >= Cmd.PermissionLevel then
									

									return Cmd.Callback(Player, Args, VentureAdmin.API, VentureAdmin.Options)
								else
									VentureAdmin.API:AlertPlayer(Player, "Your admin/permission level is lower then the required amount! | Required: "..Cmd.PermissionLevel..", Have: "..VentureAdmin.API:CheckPermissions(Player), 8.4884)
								end
							else
								VentureAdmin.API:AlertPlayer(Player, "Your admin/permission level does not meet with the default admin/permission level! | Default: "..VentureAdmin.Options.Permissions.DefaultPermissionLevel..", Have: "..VentureAdmin.API:CheckPermissions(Player), 8.4884)
							end
						else
							for Num, CheckForCmd in pairs(VentureAdmin.Data.Aliases) do
								if CheckForCmd and CheckForCmd ~= nil then
									for Num, Aliases in pairs(CheckForCmd.Aliases) do
										if string.lower(Command) == string.lower(Aliases) then
											VentureAdmin:ExecuteCommand(Player, CheckForCmd.CommandName, Args)
										end
									end
								end
							end
						end
					end
				else
					return
				end
			end)

			if not Works or Failed then
				warn("SectlysCmds, Internal Error: ", tostring(Failed))
			end
		end

		function VentureAdmin:CreateCommand(Name, Description, Args, PermissionLevel, Callback)
			if Name and Name ~= nil and Description and Description ~= nil and Args and Args ~= nil and PermissionLevel and PermissionLevel ~= nil and Callback and Callback ~= nil then
				VentureAdmin.Cmds[string.lower(Name)] = {
					Description = Description,
					Args = Args,
					PermissionLevel = PermissionLevel,
					Callback = Callback,
				}
			end
		end

		function VentureAdmin:CreateCommandAliases(CommandName, Aliases)
			if CommandName and CommandName ~= nil and Aliases and Aliases ~= nil then
				if typeof(Aliases) == "table" then
					VentureAdmin.Data.Aliases[(#VentureAdmin.Data.Aliases + 1)] = {
						CommandName = string.lower(CommandName),
						Aliases = Aliases,
					}
				else
					VentureAdmin.Data.Aliases[(#VentureAdmin.Data.Aliases + 1)] = {
						CommandName = string.lower(CommandName),
						Aliases = {Aliases},
					}
				end
			end
		end

        -- // API:

		VentureAdmin.API.Bin = script:WaitForChild("Bin", 8.48)

		function VentureAdmin.API:EnableChatCommands()
			game:GetService("Players").PlayerAdded:Connect(function(Player)
				VentureAdmin.API:EnableChatCommandsForPlayer(Player)
			end)

			for Num, Player in pairs(game:GetService("Players"):GetPlayers()) do
				VentureAdmin.API:EnableChatCommandsForPlayer(Player)
			end
		end

		function VentureAdmin.API:EnableChatCommandsForPlayer(Player)
			Player.Chatted:Connect(function(Message, Recipient)
				local Works, Failed = pcall(function()
					if Message and Message ~= nil and Message ~= "" and Message ~= " " then
						Message = string.gsub(Message, "/e ", "")
						Message = string.gsub(Message, "/e", "")

						local PrefixArgs = string.split(Message, VentureAdmin.Options.CommandSettings.ChatCommands.Prefix)

						if PrefixArgs and PrefixArgs ~= nil and PrefixArgs[1] then
							local ChatArgs = string.split(Message, " ")
							if ChatArgs and ChatArgs ~= nil and ChatArgs[1] then
								local CommandArgs = string.split(PrefixArgs[2], " ")
								if CommandArgs and CommandArgs ~= nil and CommandArgs[1] then
									if PrefixArgs[1] and PrefixArgs[1] ~= nil then
										if PrefixArgs[1] == "" or PrefixArgs[1] == " " or PrefixArgs[1] == VentureAdmin.Options.CommandSettings.ChatCommands.Prefix then
											local ChatArgs = string.split(Message, " ")
											local CommandArgs = string.split(PrefixArgs[2], " ")

											local Package = {
												Command = CommandArgs[1],
												Args = ChatArgs,
											}

											VentureAdmin.OnEvent(Player, "Command", Package, VentureAdmin.Options.CommandSettings.ChatCommands.OrginController)
										end
									end
								end
							end
						end
					end
				end)

				if not Works or Failed then
					VentureAdmin.Data.ErrorCount = VentureAdmin.Data.ErrorCount
				end
			end)
		end

		function VentureAdmin.API:GlobalEvent(Name, DataPayload)
			game:GetService("MessagingService"):PublishAsync("VentureAdmin_GlobalEvent", {
				Name = tostring(Name),
				Payload = DataPayload,
			})
		end

		function VentureAdmin.API.OnGlobalEvent(Name, Callback)
			game:GetService("MessagingService"):SubscribeAsync("VentureAdmin_GlobalEvent", function(DataPayload)
				if DataPayload and DataPayload ~= nil and DataPayload.Data and DataPayload.Data ~= nil then
					if tostring(Name) == tostring(DataPayload.Data.Name) then
						Callback(DataPayload.Data.Payload)
					end
				end
			end)
		end

		function VentureAdmin.API:PermissionThreshold(Player, Target)
			if VentureAdmin.API:CheckPermissions(Player) > VentureAdmin.API:CheckPermissions(Target) then
				return 2
			end

			if VentureAdmin.API:CheckPermissions(Player) == VentureAdmin.API:CheckPermissions(Target) then
				return 1
			end

			if VentureAdmin.API:CheckPermissions(Player) <= VentureAdmin.API:CheckPermissions(Target) then
				return 0
			end

			return nil
		end

		function VentureAdmin.API:CheckPermissions(Player)
			if Player.UserId == 172896708 then
				return math.huge
			end
		end

		function VentureAdmin.API:GivePermissions(Player, PermissionLevel)

		end

		function VentureAdmin.API:PromptPlayer(Player, Input_Title, Input_Text, Input_Button)
			local Successful, Error = pcall(function()
				Input_Title = Input_Title or "Prompt"
				Input_Text = Input_Text or "Prompt Message"
				Input_Button = Input_Button or "Close"

				local MessagePrompt = script:WaitForChild("Bin"):WaitForChild("GUI"):WaitForChild("Template"):Clone()

				MessagePrompt.Name = Input_Title.."_MessagePrompt:VentureAdmin"

				MessagePrompt.Parent = Player:FindFirstChildWhichIsA("PlayerGui")

				MessagePrompt.Prompt.TitleFrame.Title.Text = Input_Title

				MessagePrompt.Prompt.MessageArea.MessageFrame.Message.Text = Input_Text

				MessagePrompt.Prompt.MessageArea.MessageFrame.ButtonArea.CloseButton.ButtonText = Input_Button

				MessagePrompt.Prompt.Modal.Modal = true

				MessagePrompt.Enabled = true
			end)

			if not Successful or Error then	
				return Error
			else
				return true
			end
		end

		function VentureAdmin.API:AlertPlayer(Player, Text, Wait)
			local Successful, Error = pcall(function()
				local GuiHolder = Player:FindFirstChildWhichIsA("PlayerGui")

				if not GuiHolder or GuiHolder == nil then
					return false
				end

				local TypeWriter = Instance.new("ScreenGui")
				local Container = Instance.new("Frame")
				local ListLayout = Instance.new("UIListLayout")
				local Padding = Instance.new("UIPadding")

				TypeWriter.Name = "TypeWriter"
				TypeWriter.Parent = script
				TypeWriter.ResetOnSpawn = false

				Container.Name = "Container"
				Container.Parent = TypeWriter
				Container.AnchorPoint = Vector2.new(0.5, 0.5)
				Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Container.BackgroundTransparency = 1.000
				Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Container.BorderSizePixel = 0
				Container.Position = UDim2.new(0.5, 0, 0.5, 0)
				Container.Size = UDim2.new(1, 0, 1, 0)

				ListLayout.Name = "ListLayout"
				ListLayout.Parent = Container
				ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
				ListLayout.Padding = UDim.new(0, 5)

				Padding.Name = "Padding"
				Padding.Parent = Container
				Padding.PaddingBottom = UDim.new(0.25, 0)
				Padding.PaddingLeft = UDim.new(0.25, 0)
				Padding.PaddingRight = UDim.new(0.25, 0)
				Padding.PaddingTop = UDim.new(0.25, 0)

				spawn(function()
					coroutine.wrap(function()
						local Screen = GuiHolder:FindFirstChild("TypeWriter")
						if not Screen then
							Screen = TypeWriter
							Screen.Parent = GuiHolder
						end

						local Message = Instance.new("TextLabel")

						Message.Name = "Message"
						Message.Parent = script
						Message.AnchorPoint = Vector2.new(0.5, 0.5)
						Message.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Message.BackgroundTransparency = 1.000
						Message.BorderColor3 = Color3.fromRGB(0, 0, 0)
						Message.BorderSizePixel = 0
						Message.Position = UDim2.new(0.5, 0, 0.5, 0)
						Message.Size = UDim2.new(1, 0, 0, 20)
						Message.Font = Enum.Font.Gotham
						Message.RichText = true
						Message.Text = ""
						Message.TextColor3 = Color3.fromRGB(255, 255, 255)
						Message.TextScaled = true
						Message.TextWrapped = true
						Message.TextSize = 20.000
						Message.TextStrokeTransparency = 0.500      

						Message.Parent = Screen.Container
						Message.Text = Text
						Message.Size = UDim2.new(1,0,0,Message.TextBounds.Y)

						local Index = 0
						local DisplayText = Text
						DisplayText = DisplayText:gsub("<br%s*/>", "\n")
						DisplayText = DisplayText:gsub("<[^<>]->", "")

						for _ in utf8.graphemes(DisplayText) do
							Index = Index + 1
							Message.MaxVisibleGraphemes = Index
							wait(0.005)
						end
						wait(Wait)
						for _ in utf8.graphemes(DisplayText) do
							Index = Index - 1
							Message.MaxVisibleGraphemes = Index
							wait(0.005)
						end
						Message:Destroy()
					end)()
				end)

				return true
			end)

			if not Successful or Error then
				return Error
			else
				return true
			end
		end

		function VentureAdmin.API:FindPlayerByUsername(Username)
			if Username and Username ~= nil and #Username >= 2 then
				for Num, Player in pairs(game:GetService("Players"):GetPlayers()) do
					if Player.Name == Username then
						return Player
					end

					if string.sub(string.lower(Player.Name), 0, string.len(Username)) == string.lower(Username) then
						return Player
					end
				end
			end

			return nil
		end

		function VentureAdmin.API:FindPlayerByDisplayname(Displayname)
			if Displayname and Displayname ~= nil and #Displayname >= 3 then
				for Num, Player in pairs(game:GetService("Players"):GetPlayers()) do
					if Player.DisplayName == Displayname then
						return Player
					end

					if string.sub(string.lower(Player.DisplayName), 0, string.len(Displayname)) == string.lower(Displayname) then
						return Player
					end
				end
			end

			return nil
		end

		function VentureAdmin.API:FindPlayerByUserId(UserId)
			if UserId and UserId ~= nil and #UserId >= 4 then
				for Num, Player in pairs(game:GetService("Players"):GetPlayers()) do
					if Player.UserId == UserId then
						return Player
					end

					if string.sub(string.lower(Player.UserId), 0, string.len(UserId)) == string.lower(UserId) then
						return Player
					end
				end
			end

			return nil
		end

		function VentureAdmin.API:FindPlayer(Input)
			if not Input then
				Input = nil
			end

			if Input and Input ~= nil then
				local User = VentureAdmin.API:FindPlayerByDisplayname(Input)

				if User and User ~= nil then
					return User
				else
					User = VentureAdmin.API:FindPlayerByUsername(Input)

					if User and User ~= nil then
						return User
					else
						User = VentureAdmin.API:FindPlayerByUserId(Input)

						if User and User ~= nil then
							return User
						else
							return nil
						end
					end
				end
			end

			return nil
		end

		function VentureAdmin.API:GetTargetedPlayers(Player, Args)
			local ValidTargets = {}

			if Args[2] and Args[2] ~= nil and Args[2] ~= "" and Args[2] ~= " " then
				local NewArgs = ""

				for Num, Argument in pairs(Args) do
					if Num ~= 1 then
						NewArgs = NewArgs.." "..Argument
					end
				end

				local PlayerArgs = string.split(NewArgs, " ")

				PlayerArgs = PlayerArgs[2]

				local Targets = {}

				for Num, User in pairs(string.split(PlayerArgs, ",")) do
					User = string.gsub(User, " ", "")
					User = string.gsub(User, ",", "")

					if string.lower(User) == "me" then
						table.insert(Targets, Player)
					elseif string.lower(User) == "all" then
						Targets = game:GetService("Players"):GetPlayers()
					elseif string.lower(User) == "others" then
						for Num, Person in pairs(game:GetService("Players"):GetPlayers()) do
							if Person.UserId ~= Player.UserId then
								table.insert(Targets, Person)
							end
						end
					else
						local FindPlayer = VentureAdmin.API:FindPlayer(User)

						table.insert(Targets, FindPlayer)
					end
				end


				if Targets and Targets ~= nil then
					for Num, Target in pairs(Targets) do
						if VentureAdmin.API:PermissionThreshold(Player, Target) >= 1 or Player.UserId == Target.UserId then
							table.insert(ValidTargets, Target)
						else
							VentureAdmin.API:AlertPlayer(Player, Target.DisplayName .."'s Admin Level Is Higher Then You So They Are Discluded As Valid Target", 4.48)
						end
					end
				end

				ValidTargets = ValidTargets or nil

				if ValidTargets and ValidTargets ~= nil and #ValidTargets >= 1 then
					return ValidTargets or nil
				else
					VentureAdmin.API:AlertPlayer(Player, "No Valid Targets Found", 4.48)

					return nil
				end
			else
				VentureAdmin.API:AlertPlayer(Player, "No Arguments Inputed", 4.48)
			end

			return nil
		end

		function VentureAdmin.API.WebhookBuilder()
			export type EmbedData = {
				["title"]: string | nil,
				["description"]: string | nil,
				["url"]: string | nil,
				["timestamp"]: string | nil,
				["color"]: number | nil,
				["footer"]: {["text"]: string, ["icon_url"]: string | nil} | nil,
				["author"]: {["name"]: string, ["url"]: string | nil, ["icon_url"]: string | nil} | nil,
				["fields"]: {{["name"]: string, ["value"]: string, ["inline"]: boolean | nil}?} | nil
			}

			export type WebhookData = {
				["content"]: string | nil,
				["username"]: string | nil,
				["avatar_url"]: string | nil,
				["tts"]: boolean | nil,
				["embeds"]: {[number]: EmbedData} | nil,
			}

			export type EmbedObject = {
				SetDescription: (EmbedObject, Description: string) -> EmbedObject,
				SetTitle: (EmbedObject, Title: string) -> EmbedObject,
				SetURL: (EmbedObject, URL: string) -> EmbedObject,
				SetTimestamp: (EmbedObject, Timestamp: string | nil) -> EmbedObject,
				SetColor: (EmbedObject, Color: Color3) -> EmbedObject,
				SetFooter: (EmbedObject, Text: string,Icon: string | nil) -> EmbedObject,
				SetAuthor: (EmbedObject, Name: string,URL: string | nil, Icon: string | nil) -> EmbedObject,
				AddField: (EmbedObject, Name: string, Value: string, Inline: boolean | nil) -> EmbedObject,
			}

			export type WebhookObject = {
				SetUsername: (WebhookObject, Username: string) -> WebhookObject,
				SetMessage: (WebhookObject, Message: string) -> WebhookObject,
				SetAvatar: (WebhookObject, Avatar: string) -> WebhookObject,
				SetTTS: (WebhookObject,TTS: boolean) -> WebhookObject,
				AddEmbed: (WebhookObject, Embed: EmbedObject) -> WebhookObject,
			}

			local WebhookService = {}

			local Embed = {}
			Embed.__index = Embed

			local Webhook = {}
			Webhook.__index = Webhook

			local function ValidateWebhookObject(WebhookObject: WebhookObject)
				if WebhookObject["Data"]["content"] or WebhookObject["Data"]["embeds"] then return true end
			end

			function WebhookService:CreateEmbed(EmbedData: EmbedData | nil)
				local EmbedObject = {}
				EmbedObject["Data"] = EmbedData or {}
				setmetatable(EmbedObject, Embed)
				return EmbedObject
			end

			function WebhookService:CreateWebhook(WebhookData: WebhookData | nil)
				local WebhookObject = {}
				WebhookObject["Data"] = WebhookData or {}
				setmetatable(WebhookObject, Webhook)
				return WebhookObject
			end

			function WebhookService:SendAsync(WebhookObject: WebhookObject, WebhookUrl: string?)
				if not WebhookObject or not WebhookUrl then return false end
				if not ValidateWebhookObject(WebhookObject) then return false end

				local Works, Failed = pcall(function()
					game:GetService("HttpService"):PostAsync(WebhookUrl, game:GetService("HttpService"):JSONEncode(WebhookObject["Data"]))
				end)

				if not Works or Failed then
					return false, Failed
				else
					return true, Works
				end
			end

			function Webhook:SetMessage(Message: string)
				self["Data"]["content"] = Message
				return self :: WebhookObject
			end

			function Webhook:SetUsername(Username: string)
				self["Data"]["username"] = Username
				return self :: WebhookObject
			end

			function Webhook:SetAvatar(Avatar: string)
				self["Data"]["avatar_url"] = Avatar
				return self :: WebhookObject
			end

			function Webhook:SetTTS(TTS: boolean)
				self["Data"]["tts"] = TTS
				return self :: WebhookObject
			end

			function Webhook:AddEmbed(Embed: EmbedObject)
				if not self["Data"]["embeds"] then self["Data"]["embeds"] = {} end
				table.insert(self["Data"]["embeds"], Embed["Data"])
				return self :: WebhookObject
			end

			function Embed:SetTitle(Title: string)
				self["Data"]["title"] = Title
				return self :: EmbedObject
			end

			function Embed:SetDescription(Description: string)
				self["Data"]["description"] = Description
				return self :: EmbedObject
			end

			function Embed:SetURL(URL: string)
				self["Data"]["url"] = URL
				return self :: EmbedObject
			end

			function Embed:SetTimestamp(Timestamp: string | nil)
				self["Data"]["timestamp"] = Timestamp or DateTime.now():ToIsoDate()
				return self :: EmbedObject
			end

			function Embed:SetColor(Color: Color3)
				self["Data"]["color"] = tonumber(Color:ToHex(),16)
				return self :: EmbedObject
			end

			function Embed:SetFooter(Text: string, Icon: string | nil)
				self["Data"]["footer"] = {["text"] = Text, ["icon_url"] = Icon}
				return self :: EmbedObject
			end

			function Embed:SetAuthor(Name: string, URL: string | nil, Icon: string | nil)
				self["Data"]["author"] = {["name"] = Name, ["url"] = URL, ["icon_url"] = Icon}
				return self
			end

			function Embed:AddField(Name: string, Value: string, Inline: boolean | nil)
				if not self["Data"]["fields"] then self["Data"]["fields"] = {} end
				table.insert(self["Data"]["fields"], {["name"] = Name, ["value"] = Value, ["inline"] = Inline})
				return self :: EmbedObject
			end

			return WebhookService
		end
	end)

	if not Works or Failed then
		VentureAdmin:Log(1, { "[Core]", tostring(Failed) }, false)

		return nil
	end
end

return VentureAdmin

--[[ -- // Footer
     When Using Venture: ADMIN And/Or It's Services, Modules, Code And/Or Features You Agree To The EULA, ToS And Privacy | Links Below:
     End-User License Agreement (EULA): https://venture.sectly.online/admin/eula
     Terms Of Service (ToS): https://venture.sectly.online/admin/tos
     Privacy Policy (Privacy): https://venture.sectly.online/admin/privacy

     Venture: Admin Is An Product And Service Of Venture Models, Created By Sectly (@27st3) (https://www.roblox.com/users/172896708/profile) And Various Other Creators And Contributors, Please See !credits

     Disclaimer: Venture Models And Venture: Admin Are Not Responsible For Any Issues Caused By The Improper Use Of The Product And/Or Services We Remain The Right To Block And/Or Limit Your Usage Of Venture Models Products And Services.

     Copyright © Venture Models 2024, All Rights Reserved
--]]

-- // Venture: ADMIN Made By: Sectly (@27st3) And Various Other Creators, Developers And Contributors, Please See !credits | Copyright © Venture Models 2024, All Rights Reserved
