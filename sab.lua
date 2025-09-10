--// Services
local sab = 109983668079237
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if game.PlaceId == sab then
    print("sab")


    
    Notify({
Description = "Succesfully Loaded! Place Id:"sab"";
Title = "Loadstring Loaded";
Duration = 5;
});
else
    print("not in sab")
    Notify({
Description = "You Arent In Steal A Brainrot Or In The New Player Servers";
Title = "Failed To Load | ErrorCode: 400";
Duration = 5;
});
end
