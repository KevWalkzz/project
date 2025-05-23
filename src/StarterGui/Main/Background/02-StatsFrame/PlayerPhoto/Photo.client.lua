local imageLabel = script.Parent
local players = game.Players

local playerImg = players:GetUserThumbnailAsync(players.LocalPlayer.UserId, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420)

imageLabel.Image = playerImg
imageLabel.ImageTransparency = 0