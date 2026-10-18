-- Painel de votos para simulacao local no Roblox Studio.
-- Nao modifica os valores oficiais registrados no servidor.
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
-- Limpa as duas versoes anteriores da interface.
for _, name in ipairs({"PainelVotosBrasil", "SimuladorVotosBrasil"}) do
    local previous = guiParent:FindFirstChild(name)
    if previous then previous:Destroy() end
end

local function make(class, properties, parent)
    local obj = Instance.new(class)
    for key,value in pairs(properties) do obj[key]=value end
    obj.Parent=parent
    return obj
end
local function round(obj, radius)
    make("UICorner",{CornerRadius=UDim.new(0,radius)},obj)
end
local white=Color3.fromRGB(245,247,250)
local green=Color3.fromRGB(30,180,105)
local gui=make("ScreenGui",{Name="PainelVotosBrasil",ResetOnSpawn=false,DisplayOrder=10},guiParent)
local frame=make("Frame",{
    Size=UDim2.fromOffset(330,300),
    Position=UDim2.new(.5,-165,.5,-150),
    BackgroundColor3=Color3.fromRGB(17,24,39),
    BorderSizePixel=0,Active=true
},gui)
round(frame,16)
make("UIStroke",{Color=green,Thickness=1.5,Transparency=.3},frame)

local header=make("Frame",{
    Size=UDim2.new(1,0,0,55),
    BackgroundColor3=Color3.fromRGB(25,42,48),
    BorderSizePixel=0,Active=true
},frame)
round(header,16)
make("TextLabel",{
    Size=UDim2.new(1,-105,1,0),Position=UDim2.fromOffset(14,0),
    Text="PAINEL DE VOTOS",TextColor3=white,TextSize=17,
    Font=Enum.Font.GothamBold,BackgroundTransparency=1,
    TextXAlignment=Enum.TextXAlignment.Left
},header)
local minimize=make("TextButton",{
    Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-75,0,12),
    Text="-",TextSize=21,Font=Enum.Font.GothamBold,TextColor3=white,
    BackgroundColor3=Color3.fromRGB(55,70,82)
},header)
round(minimize,8)
local close=make("TextButton",{
    Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-39,0,12),
    Text="X",TextSize=15,Font=Enum.Font.GothamBold,TextColor3=white,
    BackgroundColor3=Color3.fromRGB(180,55,65)
},header)
round(close,8)
local content=make("Frame",{
    Position=UDim2.fromOffset(0,55),Size=UDim2.new(1,0,1,-55),
    BackgroundTransparency=1
},frame)
local counter=make("TextLabel",{
    Position=UDim2.fromOffset(15,12),Size=UDim2.new(1,-30,0,48),
    Text="VOTOS SIMULADOS: 0",TextColor3=green,TextSize=19,
    Font=Enum.Font.GothamBold,BackgroundTransparency=1
},content)
local amount=make("TextBox",{
    Position=UDim2.fromOffset(20,72),Size=UDim2.new(1,-40,0,43),
    Text="",PlaceholderText="Digite a quantidade de votos",
    ClearTextOnFocus=false,TextColor3=white,
    PlaceholderColor3=Color3.fromRGB(155,165,175),
    TextSize=15,Font=Enum.Font.Gotham,
    BackgroundColor3=Color3.fromRGB(35,48,62)
},content)
round(amount,9)
local add=make("TextButton",{
    Position=UDim2.fromOffset(20,126),Size=UDim2.new(1,-40,0,43),
    Text="ADICIONAR VOTOS",TextColor3=white,TextSize=15,
    Font=Enum.Font.GothamBold,BackgroundColor3=green
},content)
round(add,9)
local reset=make("TextButton",{
    Position=UDim2.fromOffset(20,180),Size=UDim2.new(1,-40,0,37),
    Text="ZERAR CONTADOR",TextColor3=white,TextSize=14,
    Font=Enum.Font.GothamBold,BackgroundColor3=Color3.fromRGB(170,65,65)
},content)
round(reset,9)
local votes=0
add.MouseButton1Click:Connect(function()
    local n=tonumber(amount.Text)
    if not n or n~=math.floor(n) or n<1 or n>1000000000 then
        amount.Text=""
        amount.PlaceholderText="Digite um inteiro de 1 a 1 bilhao"
        return
    end
    votes=votes+n
    counter.Text="VOTOS SIMULADOS: "..tostring(votes)
    amount.Text=""
end)
reset.MouseButton1Click:Connect(function()
    votes=0
    counter.Text="VOTOS SIMULADOS: 0"
end)
close.MouseButton1Click:Connect(function() frame.Visible=false end)
local collapsed=false
minimize.MouseButton1Click:Connect(function()
    collapsed=not collapsed
    content.Visible=not collapsed
    frame.Size=collapsed and UDim2.fromOffset(330,55) or UDim2.fromOffset(330,300)
    minimize.Text=collapsed and "+" or "-"
end)
local dragging=false
local dragStart,startPos
header.InputBegan:Connect(function(event)
    if event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch then
        dragging=true dragStart=event.Position startPos=frame.Position
    end
end)
UIS.InputEnded:Connect(function(event)
    if event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
UIS.InputChanged:Connect(function(event)
    if dragging and (event.UserInputType==Enum.UserInputType.MouseMovement or event.UserInputType==Enum.UserInputType.Touch) then
        local delta=event.Position-dragStart
        frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
UIS.InputBegan:Connect(function(event,processed)
    if not processed and event.KeyCode==Enum.KeyCode.PageUp then
        frame.Visible=not frame.Visible
    end
end)
