local sab = 109983668079237
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;

if game.PlaceId == sab then
    Notify({
Description = "Succesfully Loaded! Place Id:"sab"";
Title = "Loadstring Loaded";
Duration = 5;
});
else
    Notify({
Description = "You Arent In Steal A Brainrot Or In The New Player Servers";
Title = "Failed To Load | ErrorCode: 400";
Duration = 5;
});
end
