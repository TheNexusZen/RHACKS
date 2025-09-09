local jobId = game.JobId

if setclipboard then
    setclipboard(jobId)
elseif writeclipboard then
    writeclipboard(jobId)
end

game.StarterGui:SetCore("SendNotification", {
    Title = "JobId Copied",
    Text = "Send this JobId to your friend: " .. jobId,
    Duration = 10
})
